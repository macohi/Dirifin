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
		scale.set(Math.round(FlxG.width / width), Math.round(FlxG.height / height));
		updateHitbox();
	}
}
