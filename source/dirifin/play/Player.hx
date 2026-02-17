package dirifin.play;

import macohi.funkin.koya.backend.AssetPaths;
import macohi.util.Direction;

class Player extends DirectionSprite
{
	override public function new(?x:Float, ?y:Float)
	{
		super(0, x, y);

		loadGraphic(AssetPaths.image('player'), true, 16, 16);
		addAnimByFrames('LEFT', [0]);
		addAnimByFrames('DOWN', [1]);
		addAnimByFrames('UP', [2]);
		addAnimByFrames('RIGHT', [3]);
		applyPixelScale();

		changeDirection(this.direction);
	}

	override function changeDirection(direction:Direction, ?player:Player)
	{
		super.changeDirection(direction, player);

		switch (direction)
		{
			case LEFT:
				playAnim('LEFT');
			case DOWN:
				playAnim('DOWN');
			case UP:
				playAnim('UP');
			case RIGHT:
				playAnim('RIGHT');
		}
		updateHitbox();
	}
}
