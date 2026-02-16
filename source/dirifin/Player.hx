package dirifin;

import macohi.overrides.MSprite;

enum abstract PlayerDirection(Int) from Int to Int
{
	var LEFT = 0;
	var DOWN = 1;
	var UP = 2;
	var RIGHT = 3;
}

class Player extends DirectionSprite
{
	override public function new(?x:Float, ?y:Float)
	{
		super(x, y);

		makeGraphic(64, 64);
		changeDirection(this.direction);
	}

	override function changeDirection(direction:PlayerDirection, ?player:Player)
	{
		super.changeDirection(direction, null);
	}
}
