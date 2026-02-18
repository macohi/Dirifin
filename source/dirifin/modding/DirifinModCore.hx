package dirifin.modding;

import dirifin.save.DirifinSave;
import macohi.funkin.koya.backend.modding.ModCore;

class DirifinModCore extends ModCore
{
	override function get_enabledMods():Array<String>
	{
		return DirifinSave.instance.enabledMods.get() ?? [];
	}
}
