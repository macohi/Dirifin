package dirifin.ui;

import dirifin.input.Controls;
import dirifin.play.PlayState;
import flixel.FlxG;
import flixel.util.FlxColor;
import macohi.backend.api.DiscordClient;
import macohi.overrides.MState;
import macohi.overrides.MText;

using macohi.util.FlxKeyUtil;

class GameoverState extends MState
{
	public var gameoverText:MText;

	override function create()
	{
		super.create();

		gameoverText = new MText(0, 0,
			FlxG.width).makeText('YOU DIED!\n\n'
				+ 'You can press ${Controls.instance.keybinds.get('accept').stringArrayToKeysArray().youCanPressString()} to go back to gameplay'
				+ '\n\nYou can press ${Controls.instance.keybinds.get('back').stringArrayToKeysArray().youCanPressString()} to go to the main menu',
				24);

		add(gameoverText);
		gameoverText.screenCenter();
		gameoverText.color = FlxColor.RED;

		DiscordClient.changePresence('DIED!', 'GAME OVER');
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (Controls.instance.justReleased('accept'))
			switchState(() -> new PlayState(PlayState.LAST_PLAYED_LEVEL));
		if (Controls.instance.justReleased('back'))
			switchState(() -> new MainMenuState());
	}
}
