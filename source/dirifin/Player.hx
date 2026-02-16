package dirifin;

import macohi.funkin.koya.backend.AssetPaths;
import macohi.util.Direction;

class Player extends DirectionSprite
{
	override public function new(?x:Float, ?y:Float)
	{
		super(0, x, y);

		loadGraphic(AssetPaths.image('player'), true, 16, 16);
		addAnimByFrames('left', [0]);
		addAnimByFrames('down', [1]);
		addAnimByFrames('up', [2]);
		addAnimByFrames('right', [3]);

		applyPixelScale();

		changeDirection(this.direction);
	}

	override function changeDirection(direction:Direction, ?player:Player)
	{
		super.changeDirection(direction, player);

		switch (direction)
		{
			case LEFT:
				playAnim('LEFT'.toLowerCase());
			case DOWN:
				playAnim('DOWN'.toLowerCase());
			case UP:
				playAnim('UP'.toLowerCase());
			case RIGHT:
				playAnim('RIGHT'.toLowerCase());
		}
	}
}
