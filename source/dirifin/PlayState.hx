package dirifin;

import flixel.FlxG;
import flixel.group.FlxSpriteGroup.FlxTypedSpriteGroup;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import macohi.overrides.MState;

class PlayState extends MState
{
	public var player:Player;
	public var maxBullets:Int = 4;
	public var bullets:FlxTypedSpriteGroup<Bullet>;

	public var directionArrows:FlxTypedSpriteGroup<DirectionArrow>;

	public var maxEnemies:Int = 8;
	public var enemies:FlxTypedSpriteGroup<Enemy>;

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

		#if ZOOM_OUT
		FlxG.camera.zoom = .25;
		#else
		FlxG.camera.zoom = .5;
		#end
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
					bullets.add(new Bullet().makeBullet(player));
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
			if (bullet.outOfBounds)
			{
				bullets.members.remove(bullet);
				bullet.destroy();
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

	public function enemyUpdate()
	{
		if (FlxG.random.bool(FlxG.random.float(0, 3)))
		{
			if (enemies.members.length >= maxEnemies)
				return;

			var newEnemy:Enemy = new Enemy();
			newEnemy.screenCenter();
			newEnemy.changeDirection(FlxG.random.int(0, 3), player);
			newEnemy.alpha = 0;
			FlxTween.tween(newEnemy, {alpha: 1}, 0.3, {ease: FlxEase.quadInOut});
			enemies.add(newEnemy);
		}

		for (enemy in enemies.members)
		{
			enemy.move();
			var destroyEnemy = enemy.outOfBounds;

			if (!destroyEnemy)
			{
				for (bullet in bullets.members)
				{
					if (!destroyEnemy)
					{
						destroyEnemy = bullet.overlaps(enemy);

						if (destroyEnemy)
						{
							bullets.members.remove(bullet);
							bullet.destroy();
						}
					}
					else
						continue;
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
