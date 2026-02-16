package dirifin;

import macohi.funkin.koya.backend.AssetPaths;
import macohi.overrides.MSprite;

class DirectionArrow extends MSprite
{
	override public function new(?x:Float, ?y:Float)
	{
		super(x, y);

		loadGraphic(AssetPaths.image('directionarrow'));
		applyPixelScale();
		centerOffsets();
	}
}
