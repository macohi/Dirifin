package dirifin;



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
		super(0, x, y);

		makeGraphic(64, 64);
		changeDirection(this.direction);
	}
}
