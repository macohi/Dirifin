package dirifin;

import macohi.funkin.koya.backend.AssetPaths;
import macohi.util.Direction;

class Enemy extends DirectionSprite
{
	override public function new(?x:Float, ?y:Float)
	{
		super(-0.1, x, y);

		loadGraphic(AssetPaths.image('enemy'), true, 16, 16);
		addAnimByFrames('LEFT', [0]);
		addAnimByFrames('DOWN', [1]);
		addAnimByFrames('UP', [2]);
		addAnimByFrames('RIGHT', [3]);
		applyPixelScale();

		boundsPadding = this.width * 10;

		changeDirection(direction);
	}

	public var startMulti:Float = 9.0;

	override function changeDirection(direction:Direction, ?player:Player)
	{
		this.direction = direction;

		if (player == null)
			return;

		switch (this.direction)
		{
			case LEFT:
				this.x -= player.width * startMulti;
				this.flipX = true;
				playAnim('LEFT');
			case RIGHT:
				this.x += player.width * startMulti;
				playAnim('RIGHT');

			case UP:
				this.y -= player.height * startMulti;
				this.angle = -90;
				playAnim('UP');
			case DOWN:
				this.y += player.height * startMulti;
				this.angle = 90;
				playAnim('DOWN');
		}

		updateHitbox();
	}
}
