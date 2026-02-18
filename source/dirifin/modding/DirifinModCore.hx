package dirifin.modding;

import dirifin.save.DirifinSave;
import macohi.funkin.koya.backend.modding.ModCore;

class DirifinModCore extends ModCore
{
	override public function new()
	{
		super();

		MOD_MIN_API_VERSION = 1.0;
	}

	override function get_enabledMods():Array<String>
	{
		return DirifinSave.instance.enabledMods.get() ?? [];
	}
}
