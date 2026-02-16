package dirifin;

import flixel.FlxG;
import macohi.overrides.MSprite;
import macohi.util.Direction;

class DirectionSprite extends MSprite
{
	override public function new(?speedDamp:Null<Float>, ?x:Float, ?y:Float)
	{
		super(x, y);

		if (speedDamp != null)
			this.speedDamp = speedDamp;
	}

	public var speedDamp:Float = 0.5;
	public var boundsPadding:Float = 0;

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

	public var direction:Direction = DOWN;

	public function changeDirection(direction:Direction, ?player:Player)
	{
		this.direction = direction;

		if (player == null)
			return;

		switch (this.direction)
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
	}
}
