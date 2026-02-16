package dirifin;

import flixel.FlxG;
import flixel.util.FlxColor;
import macohi.funkin.koya.backend.AssetPaths;
import macohi.overrides.MState;
import macohi.overrides.MText;

using macohi.util.FlxKeyUtil;

class GameoverState extends MState
{
	public var gameoverText:MText;

	override function create()
	{
		super.create();

		gameoverText = new MText().makeText('YOU DIED!\n\n'
			+ 'You can press ${Controls.instance.keybinds.get('accept').stringArrayToKeysArray().youCanPressString()} to go back', 24);

		add(gameoverText);
		gameoverText.screenCenter();
		gameoverText.color = FlxColor.RED;

		FlxG.sound.play(AssetPaths.sound('death'));
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (Controls.instance.justReleased('accept'))
			switchState(() -> new PlayState());
	}
}
