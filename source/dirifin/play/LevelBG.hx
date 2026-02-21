package dirifin.play;

import macohi.funkin.koya.backend.AssetPaths;
import macohi.overrides.MSprite;

class LevelBG extends MSprite
{
	override public function new(levelID:String, ?x:Float, ?y:Float)
	{
		super(x, y);

		loadGraphic(AssetPaths.image('levelsBGs/$levelID'));

		if (this.graphic == null)
		{
			visible = false;
			return;
		}

		applyPixelScale();
	}

	override function applyPixelScale()
	{
		var calc_width = width / camera.width * camera.zoom;
		var calc_height = height / camera.height * camera.zoom;

		scale.set(
			MSprite.PIXEL_SCALE + calc_width,
			MSprite.PIXEL_SCALE + calc_height
		);
		
		// trace(calc_width);
		// trace(calc_height);
		// trace(scale);

		updateHitbox();
	}
}
