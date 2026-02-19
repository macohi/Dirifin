package dirifin.ui;

import dirifin.input.Controls;
import flixel.FlxG;
import flixel.system.FlxAssets;
import macohi.backend.api.DiscordClient;
import macohi.funkin.koya.frontend.scenes.menustates.OptionsMenuState;

class OptionsState extends OptionsMenuState
{
	override function reloadMenuItems()
	{
		super.reloadMenuItems();

		if (!atlasText && text)
			for (text in itemsFlxTextGroup.members)
				text.font = FlxAssets.FONT_DEFAULT;
	}

	override function addItems() {}

	override function create()
	{
		super.create();

		DiscordClient.changePresence('Customizing the game', 'Options Menu');

		valueText.font = FlxAssets.FONT_DEFAULT;
		valueText.size = 16;

		select();
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);
	}

	override function controlsMoveVertical()
	{
		super.controlsMoveVertical();

		if (Controls.instance.justPressed('up'))
			select(-1);
		if (Controls.instance.justPressed('down'))
			select(1);
	}

	override function controlsOther()
	{
		super.controlsOther();

		if (Controls.instance.justPressed('accept'))
			acceptFunction();

		if (Controls.instance.justReleased('back'))
			FlxG.switchState(() -> new MainMenuState());
	}
}
