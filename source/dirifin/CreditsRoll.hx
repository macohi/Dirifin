package dirifin;

import flixel.FlxG;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import macohi.funkin.koya.backend.AssetPaths;
import macohi.overrides.MState;
import macohi.overrides.MText;
import macohi.util.StringUtil;

class CreditsRoll extends MState
{
	public var credits:Array<String> = StringUtil.splitTextAssetByNewlines(AssetPaths.txt('data/credits'));

	public var lines:FlxTypedGroup<MText>;

	override function create()
	{
		super.create();

		lines = new FlxTypedGroup<MText>();
		add(lines);

		var i = 0;
		for (line in credits)
		{
			var lineText = new MText().makeText(line, 16);
			lines.add(lineText);
			lineText.ID = i;

			lineText.x = 10;

			lineText.y = FlxG.height * 1.5;
			lineText.y -= i * 48;

			var time = credits.length * (lineText.size * (i + 1));
			trace('$line : $time');
			FlxTween.tween(lineText, {y: -lineText.y}, time, {
				ease: FlxEase.quadInOut,
				onComplete: function(t)
				{
					lines.members.remove(lineText);
					lineText.destroy();
				}
			});

			i++;
		}
	}
}
