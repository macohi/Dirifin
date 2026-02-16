package dirifin;

class Player extends DirectionSprite
{
	override public function new(?x:Float, ?y:Float)
	{
		super(0, x, y);

		makeGraphic(64, 64);
		changeDirection(this.direction);
	}
}
