package dirifin.play;

import dirifin.input.Controls;
import dirifin.play.LevelJSON;
import dirifin.play.objects.*;
import dirifin.save.DirifinSave;
import dirifin.ui.*;
import flixel.*;
import flixel.effects.FlxFlicker;
import flixel.group.FlxSpriteGroup.FlxTypedSpriteGroup;
import flixel.sound.FlxSound;
import flixel.tweens.*;
import flixel.util.FlxSort;
import macohi.backend.PauseMState;
import macohi.backend.api.DiscordClient;
import macohi.funkin.MegaVars;
import macohi.funkin.koya.backend.AssetPaths;
import macohi.util.Direction;

using macohi.util.StringUtil;
using macohi.util.TimeUtil;

class PlayState extends PauseMState
{
	/**
		Level Background Asset
	**/
	public var levelBG:LevelBG;

	/**
		Level ID / Level Json Name
	**/
	public var levelID:String = 'level1';

	/**
		Level Json Data
	**/
	public var levelJSON:LevelJSONData;

	/**
		Player Object
	**/
	public var player:Player;

	/**
		Object required in `bullets` until
		the player cannot fire anymore
	**/
	public var maxBullets:Int = 4;

	/**
		Bullets Sprite Group
	**/
	public var bullets:FlxTypedSpriteGroup<Bullet>;

	/**
		Direction Arrows Sprite Group
	**/
	public var directionArrows:FlxTypedSpriteGroup<DirectionArrow>;

	/**
		Amount of objects in `enemies`
		that will prevent further enemy
		spawnings
	**/
	public var maxEnemies:Int = 6;

	/**
		Enemy Sprite Group
	**/
	public var enemies:FlxTypedSpriteGroup<Enemy>;

	/**
		Gameplay Camera
	**/
	public var camGame:FlxCamera;

	/**
		HUD Camera
	**/
	public var camHUD:FlxCamera;

	/**
		Objects to be added to `camGame`
	**/
	public var camGameObjects(get, never):Array<FlxBasic>;

	function get_camGameObjects():Array<FlxBasic>
		return [levelBG, player, bullets, directionArrows, enemies,];

	/**
		Objects to be added to `camHUD`
	**/
	public var camHUDObjects(get, never):Array<FlxBasic>;

	function get_camHUDObjects():Array<FlxBasic>
		return [leftWatermark, rightWatermark, pauseBG];

	/**
		The `levelID` from the
		previous play session
	**/
	public static var LAST_PLAYED_LEVEL:String = null;

	/**
		Boolean to control
		if survival mode functionality
		should be enabled
	**/
	public static var SURVIVAL_MODE:Bool = false;

	/**
		Current health
	**/
	public var health:Int = 1;

	/**
		Current score
	**/
	public var score:Int = 0;

	override public function new(levelID:String = null)
	{
		super();

		health = 1;
		if (SURVIVAL_MODE)
			health = 3;

		this.levelID = levelID ?? 'level1';
		LAST_PLAYED_LEVEL = this.levelID;
		levelJSON = LevelJSONClass.loadLevelJSON(levelID);

		DiscordClient.changePresence('LevelID: ${this.levelID}', 'In level');
	}

	override function create()
	{
		levelBG = new LevelBG(levelID);
		levelBG.scale.add(levelBG.scale.x, levelBG.scale.y);
		levelBG.updateHitbox();
		levelBG.screenCenter();
		add(levelBG);

		if (levelJSON?.settings?.bg_scale_modifier != null)
		{
			levelBG.scale.x += levelJSON?.settings?.bg_scale_modifier[0] ?? 0;
			levelBG.scale.y += levelJSON?.settings?.bg_scale_modifier[1] ?? 0;
		}

		player = new Player();
		player.screenCenter();
		add(player);

		directionArrows = new FlxTypedSpriteGroup<DirectionArrow>();
		add(directionArrows);

		bullets = new FlxTypedSpriteGroup<Bullet>();
		add(bullets);

		enemies = new FlxTypedSpriteGroup<Enemy>();
		add(enemies);

		generateDirectionArrows();

		directionArrowUpdate();

		super.create();

		rightWatermark.text = 'PAUSED';
		rightWatermark.size = 32;

		leftWatermark.text = 'v';
		leftWatermark.visible = true;
		leftWatermark.size = 12;

		initCameras();

		directionArrowUpdate();
	}

	/**
		Creates each directional arrow
	**/
	public function generateDirectionArrows()
	{
		Direction.forEachDirectional((i) ->
		{
			var da = new DirectionArrow();
			da.screenCenter();
			da.changeDirection(i, player);
			directionArrows.add(da);
		});
	}

	/**
		Initalize the
		gameplay and HUD cameras
		and add their objects
	**/
	public function initCameras()
	{
		camHUD = new FlxCamera();
		camGame = new FlxCamera();
		FlxG.cameras.add(camGame);
		FlxG.cameras.add(camHUD);
		camHUD.bgColor.alpha = 0;

		camGame.zoom = levelJSON?.settings?.camera_zoom ?? .5;

		#if ZOOM_OUT
		camGame.zoom *= 0.5;
		#end

		for (camGameOBJ in camGameObjects)
			if (camGameOBJ != null)
				camGameOBJ.cameras = [camGame];
		for (camHUDOBJ in camHUDObjects)
			if (camHUDOBJ != null)
				camHUDOBJ.cameras = [camHUD];
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (!paused)
		{
			if (FlxG.keys.justPressed.ANY)
				addToInputQueue();
			processInputQueue();

			bulletUpdate();

			enemyUpdate();

			if (health < 1)
				deathFunction();
		}
		else
		{
			if (!Controls.instance.justPressed('ui_back'))
				return;

			FlxG.sound.play(MegaVars.SOUND_MENU_BACK, 1.0, false, null, true, function()
			{
				if (SURVIVAL_MODE)
					switchState(() -> new SurvivalModeState());

				switchState(() -> new LevelSelectState());
			});
		}

		FlxG.watch.addQuick('inputQueue', inputQueue);

		leftWatermark.text = 'Level: ${levelID.toUpperCase()}\n';
		leftWatermark.text += 'Score: ${score}\n';

		var hsta = '';

		if (SURVIVAL_MODE)
		{
			leftWatermark.text += 'Health ${health}\n';

			hsta += 'survival';

			if (DirifinSave.instance.shootWithDirectionals.get())
				hsta += '-';
		}

		if (DirifinSave.instance.shootWithDirectionals.get())
			hsta += 'swd';

		addHighScoreText(hsta);
	}

	/**
		Add the highscore text,
		perform current score and current level highscore checks
		and take into account suffixes for the saving
	**/
	public function addHighScoreText(suffix:String = '')
	{
		if (suffix.isBlankStr())
			suffix = '';

		var suff = (suffix == '') ? '' : '-$suffix';
		var suffTXT = (suff == '') ? '' : ' (${suffix.toUpperCase()})';

		if (score > Highscores.getHighscore(levelID + suff))
			Highscores.setHighscore(levelID + suff, score);

		leftWatermark.text += 'High Score${suffTXT}: ${Highscores.getHighscore(levelID + suff)}';
	}

	/**
		Array of inputs
		that were added
	**/
	public var inputQueue:Array<String> = [];

	/**
		Checks the gameplay controls
		and if they're in use they're
		added to `inputQueue`
	**/
	public function addToInputQueue()
	{
		for (control in [
			'gameplay_fire',
			'gameplay_left',
			'gameplay_down',
			'gameplay_up',
			'gameplay_right'
		])
			if (Controls.instance.justPressed(control))
				inputQueue.push(control);
	}

	/**
		Parse all inputs inside of `inputQueue`
	**/
	public function processInputQueue()
	{
		for (input in inputQueue)
		{
			if (input == 'gameplay_fire')
			{
				if (!DirifinSave.instance.shootWithDirectionals.get())
					playerFire();
			}
			else
			{
				if (input == 'gameplay_left')
					player.changeDirection(LEFT);
				if (input == 'gameplay_down')
					player.changeDirection(DOWN);
				if (input == 'gameplay_up')
					player.changeDirection(UP);
				if (input == 'gameplay_right')
					player.changeDirection(RIGHT);

				if (DirifinSave.instance.shootWithDirectionals.get())
					playerFire();

				directionArrowUpdate();
			}

			inputQueue.remove(input);
		}
	}

	/**
		Spawns bullets if there
		is no more bullets then `maxBullets`
	**/
	public function playerFire()
	{
		if (bullets.members.length >= maxBullets)
			return;

		FlxG.sound.play(AssetPaths.sound('shoot'));
		bullets.add(new Bullet().makeBullet(player));
	}

	/**
		Updates direction arrows to
		change their visibility if they're
		the current player direction arrow
		or not
	**/
	public function directionArrowUpdate()
	{
		for (arrow in directionArrows.members)
			arrow.alpha = (player.direction == arrow.direction) ? 1.0 : 0.3;
	}

	/**
		Move bullets and perform checks and functions
		for if or when they're going to deactivate
	**/
	public function bulletUpdate()
	{
		for (bullet in bullets.members)
		{
			if (bullet == null)
				continue;

			bullet.move();

			if (!(bullet.outOfBounds && !bullet.dying))
				continue;

			bullet.dying = true;

			FlxTween.tween(bullet, {alpha: 0}, 0.15, {
				ease: FlxEase.quadInOut,
				onComplete: tween ->
				{
					bullets.members.remove(bullet);
					bullet.destroy();
				},
				onUpdate: tween ->
				{
					if (bullet == null)
						tween.cancel();
				},
			});
		}
	}

	/**
		The direction of
		the last spawned enemy
	**/
	public var previousEnemyDir:Direction = -1;

	/**
		Creates a new enemy
		if certain conditions
		are met
	**/
	public function makeEnemy()
	{
		var enemySpawningData:EnemySpawningData = levelJSON?.enemy_spawning ?? null;
		var enemyVariationData:Array<EnemyVariationData> = levelJSON?.enemy_variations ?? [];

		var enemyVariation:EnemyVariationData = LevelJSONClass.getRandomEnemyVariation(enemyVariationData);

		var newEnemyDir = Direction.randomDirection();

		var spawnChance = FlxG.random.float(enemySpawningData?.spawn_chance?.min ?? 0, enemySpawningData?.spawn_chance?.max ?? 3);

		if (!FlxG.random.bool(spawnChance)
			|| enemies.members.length >= maxEnemies
			|| newEnemyDir == previousEnemyDir
			&& !FlxG.random.bool(enemySpawningData?.dupe_direction_chance ?? 10))
			return;

		previousEnemyDir = newEnemyDir;

		var newEnemy:Enemy = new Enemy(enemyVariation);
		newEnemy.screenCenter();
		newEnemy.changeDirection(newEnemyDir, player);
		newEnemy.alpha = 0;

		FlxTween.tween(newEnemy, {x: newEnemy.x, y: newEnemy.y, alpha: 1}, 0.3, {
			ease: FlxEase.quadInOut,
			onUpdate: tween ->
			{
				if (newEnemy == null)
					tween.cancel();
			}
		});

		enemies.add(newEnemy);

		FlxG.sound.play(AssetPaths.sound('monster'));
	}

	/**
		Perform Zindex sorting on the enemies sprite group and
		performing update operations on enemies
	**/
	public function enemyUpdate()
	{
		makeEnemy();

		enemies.members.sort(function(o1, o2)
		{
			var sortVal = FlxSort.DESCENDING;

			if (o1.direction == UP || o2.direction == UP)
				sortVal = FlxSort.ASCENDING;

			return FlxSort.byY(sortVal, o1, o2);
		});

		for (enemy in enemies.members)
		{
			enemy.move();
			var destroyEnemy = enemy.outOfBounds;

			if (!destroyEnemy)
				enemyCheckForBulletCollision(enemy);

			if (enemy.overlaps(player) && !destroyEnemy)
			{
				destroyEnemy = true;
				health -= 1;

				FlxG.sound.play(AssetPaths.sound('hurt'));

				FlxFlicker.flicker(player, 0.3);
			}

			if (destroyEnemy)
			{
				enemies.members.remove(enemy);
				enemy.destroy();
			}
		}
	}

	/**
		Performs checks on `enemy`
		against every bullet in
		the bullets sprite group
		for collision
	**/
	function enemyCheckForBulletCollision(enemy:Enemy)
	{
		var destroyEnemy:Bool = false;

		for (bullet in bullets.members)
		{
			if (!destroyEnemy)
				destroyEnemy = bullet.overlaps(enemy);

			if (destroyEnemy)
			{
				performScoring(enemy);
				FlxG.sound.play(AssetPaths.sound('explosion'));

				bullets.members.remove(bullet);
				bullet.destroy();
			}
		}

		return destroyEnemy;
	}

	/**
		Perform scoring operations
	**/
	public function performScoring(enemy:Enemy)
	{
		score += 100;
	}

	/**
		The keycheck for pausing
	**/
	override function getPauseBoolean():Bool
	{
		return Controls.instance.justPressed('ui_accept');
	}

	/**
		When the game pauses or unpauses
		this is run to perform the
		required operations
	**/
	override function togglePaused()
	{
		super.togglePaused();

		rightWatermark.visible = paused;
	}

	/**
		When the current health is lesser
		then 1. This is run.
	**/
	public function deathFunction()
	{
		health = 0;

		togglePaused();

		rightWatermark.visible = false;
		canPause = false;

		directionArrows.clear();

		remove(player);
		insert(members.length, player);

		var deathSound = new FlxSound().loadEmbedded(AssetPaths.sound('death'));
		deathSound.play();

		FlxFlicker.flicker(player, deathSound.length.convert_ms_to_s() + 100.convert_ms_to_s(), 0.04, false, true, function(f)
		{
			switchState(() -> new GameoverState());
		}, function(f)
		{
			if (Controls.instance.justPressed('ui_accept'))
				f.completionCallback(f);
		});
	}
}
