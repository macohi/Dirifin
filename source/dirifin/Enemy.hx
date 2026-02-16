package dirifin;

import flixel.util.FlxColor;

class Enemy extends DirectionSprite
{
	override public function new(?x:Float, ?y:Float)
	{
		super(0.5, x, y);

		makeGraphic(64, 64, FlxColor.RED);
		boundsPadding = this.width * 5;
	}
}
