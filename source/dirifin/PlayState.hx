package dirifin;

import flixel.FlxBasic;
import flixel.FlxCamera;
import flixel.FlxG;
import flixel.group.FlxSpriteGroup.FlxTypedSpriteGroup;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxSort;
import macohi.funkin.koya.backend.AssetPaths;
import macohi.overrides.MState;
import macohi.util.Direction;

class PlayState extends MState
{
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
		return [player, bullets, directionArrows, enemies,];

	public var camHUDObjects(get, never):Array<FlxBasic>;

	function get_camHUDObjects():Array<FlxBasic>
		return [leftWatermark, rightWatermark,];

	override function create()
	{
		super.create();

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

		leftWatermark.text = 'v';
		leftWatermark.visible = true;

		initCameras();
	}

	public function initCameras()
	{
		camHUD = new FlxCamera();
		camGame = new FlxCamera();
		FlxG.cameras.add(camGame);
		FlxG.cameras.add(camHUD);
		camHUD.bgColor.alpha = 0;
		// camGame.bgColor.alpha = 0;

		#if ZOOM_OUT
		camGame.zoom = .25;
		#else
		camGame.zoom = .5;
		#end

		for (camGameOBJ in camGameObjects)
			camGameOBJ.cameras = [camGame];
		for (camHUDOBJ in camHUDObjects)
			camHUDOBJ.cameras = [camHUD];
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (FlxG.keys.justPressed.ANY)
			addToInputQueue();
		processInputQueue();

		FlxG.watch.addQuick('inputQueue', inputQueue);

		directionUpdate();
		bulletUpdate();

		enemyUpdate();

		if (score > DirifinSave.instance.highscore.get())
			DirifinSave.instance.highscore.set(score);

		leftWatermark.text = '';
		leftWatermark.text += 'Version: ' + Version.VERSION;
		leftWatermark.text += '\nScore: $score';
		leftWatermark.text += '\nHigh Score: ${DirifinSave.instance.highscore.get()}';
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
		if (FlxG.random.bool(FlxG.random.float(0, 3)))
		{
			var newEnemyDir = FlxG.random.int(0, 3);

			if (enemies.members.length >= maxEnemies)
				return;

			if (newEnemyDir == previousEnemyDir && !FlxG.random.bool(10))
				return;

			FlxG.sound.play(AssetPaths.sound('monster'));
			var newEnemy:Enemy = new Enemy();
			newEnemy.screenCenter();
			newEnemy.changeDirection(newEnemyDir, player);
			newEnemy.alpha = 0;
			FlxTween.tween(newEnemy, {x: newEnemy.x, y: newEnemy.y, alpha: 1}, 0.3, {ease: FlxEase.quadInOut});
			enemies.add(newEnemy);
		}

		enemies.members.sort((o1, o2) -> FlxSort.byY(FlxSort.DESCENDING, o1, o2));

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
				switchState(() -> new GameoverState());
		}
	}
}
