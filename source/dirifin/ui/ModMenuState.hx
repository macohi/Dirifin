package dirifin.ui;

import flixel.FlxG;
import macohi.funkin.koya.backend.modding.ModCore;
import macohi.funkin.koya.frontend.scenes.menustates.OptionsMenuState;

class ModsMenuState extends OptionsMenuState
{
	override function addItems()
	{
		for (mod in ModCore.instance.allMods)
		{
			addItem(mod, ModCore.instance.enabledMods.contains(mod), function() {
				if (ModCore.instance.enabledMods.contains(mod)) ModCore.instance.enabledMods.remove(mod);
				else
					ModCore.instance.enabledMods.push(mod);
			});

			FlxG.log.add('$mod : ${ModCore.instance.modMetadatas.get(mod)}');
			FlxG.log.add('$mod.description : ${ModCore.instance.modMetadatas.get(mod).description}');
		}
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		var mod = this.itemList[currentSelection.value()];

		valueText.text = 'Mod: ${ModCore.instance.getModName(mod)}${(ModCore.instance.modMetadatas.get(mod)?.name != null) ? ' (${mod})' : ''}\n'
			+ 'Description: ${ModCore.instance.modMetadatas.get(mod)?.description}\n'
			+ 'Enabled: ${this.itemListValues.get(mod)}';
	}
}