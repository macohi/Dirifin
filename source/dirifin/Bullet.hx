package dirifin;

import flixel.FlxG;
import flixel.util.FlxColor;

class Bullet extends DirectionSprite
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
		switch (direction)
		{
			case LEFT:
				this.x -= this.width * speedDamp;
			case RIGHT:
				this.x += this.width * speedDamp;

			case UP:
				this.y -= this.width * speedDamp;
			case DOWN:
				this.y += this.width * speedDamp;
		}

		outOfBounds = (x < -boundsPadding) || (x > (FlxG.width + boundsPadding)) || (y < -boundsPadding) || (y > (FlxG.height + boundsPadding));
	}

	public var outOfBounds:Bool = false;

	public function makeBullet(player:Player):Bullet
	{
		screenCenter();

		changeDirection(player.direction, player);

		return this;
	}
}
