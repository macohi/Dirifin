package dirifin.play;

import macohi.funkin.koya.backend.AssetPaths;

class DirectionArrow extends DirectionSprite
{
	override public function new(?x:Float, ?y:Float)
	{
		super(0.5, x, y);

		loadGraphic(AssetPaths.image('directionarrow'));
		applyPixelScale();
		centerOffsets();
	}
}
