package dirifin;

import flixel.util.FlxColor;

class Enemy extends DirectionSprite
{
	override public function new(?x:Float, ?y:Float)
	{
		super(x, y);
		makeGraphic(64, 64, FlxColor.RED);
	}
}
