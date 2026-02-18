package dirifin.ui;

import dirifin.input.Controls;
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

		for (i => line in credits)
		{
			if (StringUtil.isBlankStr(line))
				continue;

			var lineText = new MText().makeText(line, 16);
			lines.add(lineText);
			lineText.ID = i;

			lineText.x = 10;

			lineText.y = FlxG.height * 1.5;
			lineText.y += i * 48;

			var time = (i + 4) + credits.length / 5;
			trace('$line : $time');
			FlxTween.tween(lineText, {y: (-lineText.y + (i * 32))}, time, {
				ease: FlxEase.circIn,
				onComplete: function(t)
				{
					lines.members.remove(lineText);
					lineText.destroy();

					trace(lines.members.length);
					if (lines.members.length == 0)
						switchState(() -> new MainMenuState());
				}
			});
		}
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (Controls.instance.justReleased('back'))
			switchState(() -> new MainMenuState());
	}
}
