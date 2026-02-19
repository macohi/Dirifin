package dirifin.play;

import dirifin.input.Controls;
import dirifin.play.LevelJSON.LevelJSONClass;
import dirifin.play.LevelJSON.LevelJSONData;
import dirifin.ui.GameoverState;
import dirifin.ui.MainMenuState;
import flixel.FlxBasic;
import flixel.FlxCamera;
import flixel.FlxG;
import flixel.effects.FlxFlicker;
import flixel.group.FlxSpriteGroup.FlxTypedSpriteGroup;
import flixel.sound.FlxSound;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxSort;
import macohi.backend.PauseMState;
import macohi.funkin.MegaVars;
import macohi.funkin.koya.backend.AssetPaths;
import macohi.util.Direction;

using macohi.util.TimeUtil;

class PlayState extends PauseMState
{
	public var levelBG:LevelBG;
	public var levelID:String = 'level1';
	public var levelJSON:LevelJSONData;

	public var player:Player;

	public var maxBullets:Int = 4;
	public var bullets:FlxTypedSpriteGroup<Bullet>;

	public var score:Int = 0;

	public var directionArrows:FlxTypedSpriteGroup<DirectionArrow>;

	public var maxEnemies:Int = 6;
	public var enemies:FlxTypedSpriteGroup<Enemy>;

	public var camGame:FlxCamera;
	public var camHUD:FlxCamera;

	public var camGameObjects(get, never):Array<FlxBasic>;

	function get_camGameObjects():Array<FlxBasic>
		return [levelBG, player, bullets, directionArrows, enemies,];

	public var camHUDObjects(get, never):Array<FlxBasic>;

	function get_camHUDObjects():Array<FlxBasic>
		return [leftWatermark, rightWatermark, pauseBG];

	public static var LAST_PLAYED_LEVEL:String = null;

	override public function new(levelID:String = null)
	{
		super();

		this.levelID = levelID ?? 'level1';
		LAST_PLAYED_LEVEL = this.levelID;
		levelJSON = LevelJSONClass.loadLevelJSON(levelID);
	}

	override function create()
	{
		levelBG = new LevelBG(levelID);
		levelBG.scale.add(levelBG.scale.x, levelBG.scale.y);
		levelBG.updateHitbox();
		levelBG.screenCenter();
		add(levelBG);

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

		directionUpdate();

		super.create();

		rightWatermark.text = 'PAUSED';
		rightWatermark.size = 32;

		leftWatermark.text = 'v';
		leftWatermark.visible = true;
		leftWatermark.size = 16;

		initCameras();
	}

	public function initCameras()
	{
		camHUD = new FlxCamera();
		camGame = new FlxCamera();
		FlxG.cameras.add(camGame);
		FlxG.cameras.add(camHUD);
		camHUD.bgColor.alpha = 0;

		#if ZOOM_OUT
		camGame.zoom = .25;
		#else
		camGame.zoom = .5;
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

			directionUpdate();
			bulletUpdate();

			enemyUpdate();
		}
		else
		{
			if (Controls.instance.justPressed('back'))
			{
				FlxG.sound.play(MegaVars.SOUND_MENU_BACK, 1.0, false, null, true, function()
				{
					switchState(() -> new MainMenuState());
				});
			}
		}

		FlxG.watch.addQuick('inputQueue', inputQueue);

		if (score > Highscores.getHighscore(levelID))
			Highscores.setHighscore(levelID, score);

		leftWatermark.text = 'Level: ${levelID.toUpperCase()}\n';
		leftWatermark.text += 'Score: ${score}\n';
		leftWatermark.text += 'High Score: ${Highscores.getHighscore(levelID)}';
	}

	public var inputQueue:Array<String> = [];

	public function addToInputQueue()
	{
		for (control in ['fire', 'left', 'down', 'up', 'right'])
			if (Controls.instance.justPressed(control))
				inputQueue.push(control);
	}

	public function processInputQueue()
	{
		for (input in inputQueue)
		{
			if (input == 'fire')
			{
				if (bullets.members.length < maxBullets)
				{
					FlxG.sound.play(AssetPaths.sound('shoot'));
					bullets.add(new Bullet().makeBullet(player));
				}
			}
			else
			{
				if (input == 'left')
					player.changeDirection(LEFT);
				if (input == 'down')
					player.changeDirection(DOWN);
				if (input == 'up')
					player.changeDirection(UP);
				if (input == 'right')
					player.changeDirection(RIGHT);
			}

			inputQueue.remove(input);
		}
	}

	public function directionUpdate()
	{
		for (arrow in directionArrows.members)
			arrow.alpha = (player.direction == arrow.direction) ? 0.6 : 1.0;
	}

	public function bulletUpdate()
	{
		for (bullet in bullets.members)
		{
			bullet.move();
			if (bullet.outOfBounds && !bullet.dying)
			{
				bullet.dying = true;

				FlxTween.tween(bullet, {alpha: 0}, 0.15, {
					ease: FlxEase.quadInOut,
					onComplete: tween ->
					{
						bullets.members.remove(bullet);
						bullet.destroy();
					}
				});
			}
		}
	}

	public function generateDirectionArrows()
	{
		for (i in 0...4)
		{
			var da = new DirectionArrow();
			da.screenCenter();
			da.changeDirection(i, player);
			directionArrows.add(da);
		}
	}

	public var previousEnemyDir:Direction = -1;

	public function enemyUpdate()
	{
		if (FlxG.random.bool(FlxG.random.float(levelJSON?.enemySpawning?.spawn_chance?.min ?? 0, levelJSON?.enemySpawning?.spawn_chance?.max ?? 0)))
		{
			var newEnemyDir = FlxG.random.int(0, 3);

			if (enemies.members.length >= maxEnemies)
				return;

			if (newEnemyDir == previousEnemyDir && !FlxG.random.bool(levelJSON?.enemySpawning?.dupe_direction_chance ?? 10))
				return;

			previousEnemyDir = newEnemyDir;

			var newEnemy:Enemy = new Enemy();
			newEnemy.screenCenter();
			newEnemy.changeDirection(newEnemyDir, player);
			newEnemy.alpha = 0;
			FlxTween.tween(newEnemy, {x: newEnemy.x, y: newEnemy.y, alpha: 1}, 0.3, {ease: FlxEase.quadInOut});
			enemies.add(newEnemy);

			var monsterSpawn = new FlxSound().loadEmbedded(AssetPaths.sound('monster'));

			switch (newEnemy.direction)
			{
				case LEFT:
					monsterSpawn.pan = -10;
				case RIGHT:
					monsterSpawn.pan = 10;

				#if FLX_PITCH
				case DOWN:
					monsterSpawn.pitch = -10;
				case UP:
					monsterSpawn.pitch = 10;
				#end
			}

			monsterSpawn.play();
		}

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
				for (bullet in bullets.members)
					if (!destroyEnemy)
					{
						destroyEnemy = bullet.overlaps(enemy);

						if (destroyEnemy)
						{
							score += 100;
							FlxG.sound.play(AssetPaths.sound('explosion'));

							bullets.members.remove(bullet);
							bullet.destroy();
						}
					}

			if (destroyEnemy)
			{
				enemies.members.remove(enemy);
				enemy.destroy();
			}

			if (enemy.overlaps(player))
			{
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
					if (Controls.instance.justPressed('accept'))
						f.completionCallback(f);
				});
			}
		}
	}

	override function getPauseBoolean():Bool
	{
		return Controls.instance.justPressed('accept');
	}

	override function togglePaused()
	{
		super.togglePaused();

		rightWatermark.visible = paused;
	}
}
