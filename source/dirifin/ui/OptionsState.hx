package dirifin.ui;

import dirifin.input.MenuStateControls;
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

	override function addItems()
	{
		// delayed
		// addItem('Control Remap', 'Select to go remap your controls', function()
		// {
		// 	FlxG.switchState(() -> new ControlsRemapping());
		// });
	}

	override function create()
	{
		super.create();

		DiscordClient.changePresence('Customizing the game', 'Options Menu');

		valueText.font = FlxAssets.FONT_DEFAULT;
		valueText.size = 16;

		select();
	}

	override function controlsMoveVertical()
		MenuStateControls.controlsMoveVertical(select);

	override function controlsOther()
		MenuStateControls.controlsOther(acceptFunction, () -> new MainMenuState());
}
