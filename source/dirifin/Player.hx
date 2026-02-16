package dirifin;

import flixel.util.FlxColor;
import macohi.overrides.MSprite;

enum abstract PlayerDirection(Int) from Int to Int
{
	var LEFT = 0;
	var DOWN = 1;
	var UP = 2;
	var RIGHT = 3;
}

class Player extends MSprite
{
	public var direction:PlayerDirection = DOWN;

	override public function new(?x:Float, ?y:Float)
	{
		super(x, y);

		changeDirection(this.direction);
	}

	public function changeDirection(direction:PlayerDirection)
	{
		this.direction = direction;

		makeGraphic(64, 64, switch (this.direction)
		{
			case LEFT: FlxColor.PURPLE;
			case DOWN: FlxColor.BLUE;
			case UP: FlxColor.LIME;
			case RIGHT: FlxColor.RED;
		});
		applyPixelScale();
	}
}
