package dirifin;

import dirifin.Player.PlayerDirection;
import flixel.group.FlxSpriteGroup.FlxTypedSpriteGroup;
import macohi.overrides.MState;

class PlayState extends MState
{
	public var player:Player;
	public var maxBullets:Int = 4;
	public var bullets:FlxTypedSpriteGroup<Bullet>;

	public var directionArrows:FlxTypedSpriteGroup<DirectionArrow>;

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

		for (i in 0...4)
		{
			var da = new DirectionArrow();
			da.screenCenter();
			da.ID = i;
			directionArrows.add(da);

			switch (i)
			{
				case PlayerDirection.LEFT:
					da.x -= player.width;
				case PlayerDirection.RIGHT:
					da.x += player.width;
					da.flipX = true;

				case PlayerDirection.UP:
					da.y -= player.height;
					da.angle = 90;
				case PlayerDirection.DOWN:
					da.y += player.height;
					da.angle = -90;
			}
		}

		directionControls();
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		directionControls();
		bulletUpdate();
	}

	public function directionControls()
	{
		if (Controls.instance.justPressed('left'))
			player.changeDirection(LEFT);
		if (Controls.instance.justPressed('down'))
			player.changeDirection(DOWN);
		if (Controls.instance.justPressed('up'))
			player.changeDirection(UP);
		if (Controls.instance.justPressed('right'))
			player.changeDirection(RIGHT);

		for (arrow in directionArrows.members)
			arrow.alpha = (player.direction == arrow.ID) ? 0.6 : 1.0;
	}

	public function bulletUpdate()
	{
		if (Controls.instance.justPressed('fire'))
			if (bullets.members.length < maxBullets)
				bullets.add(new Bullet().makeBullet(player));

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
}
