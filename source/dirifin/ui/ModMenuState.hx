package dirifin.ui;

import dirifin.input.MenuStateControls;
import flixel.FlxG;
import flixel.sound.FlxSound;
import flixel.system.FlxAssets;
import macohi.backend.api.DiscordClient;
import macohi.funkin.koya.backend.modding.ModCore;
import macohi.funkin.koya.frontend.scenes.menustates.OptionsMenuState;

class ModsMenuState extends OptionsMenuState
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
		for (mod in ModCore.instance.allMods)
		{
			addItem(mod, ModCore.instance.enabledMods.contains(mod), function()
			{
				if (ModCore.instance.enabledMods.contains(mod))
					ModCore.instance.enabledMods.remove(mod);
				else
					ModCore.instance.enabledMods.push(mod);
			});

			FlxG.log.add('$mod : ${ModCore.instance.modMetadatas.get(mod)}');
			FlxG.log.add('$mod.description : ${ModCore.instance.modMetadatas.get(mod).description}');
		}
	}

	override function create()
	{
		super.create();

		DiscordClient.changePresence('Customizing the game', 'Mod Menu');

		valueText.font = FlxAssets.FONT_DEFAULT;
		valueText.size = 16;

		select();
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		var mod = this.itemList[currentSelection.value()];

		valueText.text = 'Mod: ${ModCore.instance.getModName(mod)}${(ModCore.instance.modMetadatas.get(mod)?.name != null) ? ' (${mod})' : ''}\n'
			+ 'Description: ${ModCore.instance.modMetadatas.get(mod)?.description}\n'
			+ 'Enabled: ${this.itemListValues.get(mod)}';
	}

	override function controlsMoveVertical()
		MenuStateControls.controlsMoveVertical(select);

	override function controlsOther()
		MenuStateControls.controlsOther(acceptFunction, () -> new MainMenuState());

	override function acceptedFlicker(confirmMenu:FlxSound, item:String)
	{
		transitioning = true;

		super.acceptedFlicker(confirmMenu, item);
	}
}
