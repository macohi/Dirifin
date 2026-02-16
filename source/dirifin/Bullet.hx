package dirifin;

import dirifin.Player.PlayerDirection;
import flixel.FlxG;
import flixel.util.FlxColor;
import macohi.overrides.MSprite;

class Bullet extends MSprite
{
	public var speedDamp:Float = 0.5;
	public var boundsPadding:Float = 0;

	override public function new(?speedDamp:Null<Float>)
	{
		super();

		if (speedDamp != null)
			this.speedDamp = speedDamp;

		makeGraphic(16, 8, FlxColor.YELLOW);
		boundsPadding = this.width * 4;
	}

	public function move()
	{
		if (ID == PlayerDirection.LEFT)
			this.x -= this.width * speedDamp;
		if (ID == PlayerDirection.RIGHT)
			this.x += this.width * speedDamp;

		if (ID == PlayerDirection.UP)
			this.y -= this.width * speedDamp;
		if (ID == PlayerDirection.DOWN)
			this.y += this.width * speedDamp;

		outOfBounds = (x < -boundsPadding) || (x > (FlxG.width + boundsPadding)) || (y < -boundsPadding) || (y > (FlxG.height + boundsPadding));
	}

	public var outOfBounds:Bool = false;

	public function makeBullet(player:Player):Bullet
	{
		this.ID = player.direction;
		screenCenter();

		switch (player.direction)
		{
			case LEFT:
				this.x -= player.width;
			case RIGHT:
				this.x += player.width;
				this.flipX = true;

			case UP:
				this.y -= player.height;
				this.angle = 90;
			case DOWN:
				this.y += player.height;
				this.angle = -90;
		}

		return this;
	}
}
