package dirifin;

import flixel.util.FlxColor;
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
			+ ' You can press ${Controls.instance.keybinds.get('accept').stringArrayToKeysArray().youCanPressString()} to go back', 24);

		add(gameoverText);
		gameoverText.screenCenter();
		gameoverText.color = FlxColor.RED;
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (Controls.instance.justReleased('accept'))
			switchState(() -> new PlayState());
	}
}
