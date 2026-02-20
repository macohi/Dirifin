package dirifin.ui;

import dirifin.input.MenuStateControls;
import flixel.FlxG;
import flixel.system.FlxAssets;
import macohi.backend.api.DiscordClient;
import macohi.funkin.koya.frontend.scenes.menustates.options.ControlRemap;
import macohi.funkin.vslice.util.SortUtil;

using macohi.util.ArrayUtil;
using macohi.util.FlxKeyUtil;

class ControlsRemapping extends ControlRemap
{
	override function reloadMenuItems()
	{
		super.reloadMenuItems();

		if (!atlasText && text)
			for (text in itemsFlxTextGroup.members)
				text.font = FlxAssets.FONT_DEFAULT;
	}

	override function altControls():Bool
	{
		return super.altControls();
	}

	override function create()
	{
		super.create();

		DiscordClient.changePresence('Customizing controls', 'Controls Remapping Menu');

		valueText.font = FlxAssets.FONT_DEFAULT;
		valueText.size = 16;

		select();
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);
	}

	override function controlsMoveVertical()
		MenuStateControls.controlsMoveVertical(select);

	override function controlsOther()
		MenuStateControls.controlsOther(acceptFunction, () -> new MainMenuState());

	override function back()
	{
		FlxG.switchState(() -> new OptionsState());
	}
}
