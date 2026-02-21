package dirifin.play;

import flixel.FlxG;
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
		scale.set(
			1 + (MSprite.PIXEL_SCALE * (FlxG.width / width)),
			1 + (MSprite.PIXEL_SCALE * (FlxG.height / height))
		);
		trace(scale);
		updateHitbox();
	}
}
