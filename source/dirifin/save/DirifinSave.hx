package dirifin.save;

import macohi.save.Save;
import macohi.save.SaveField;

class DirifinSave extends Save
{
	public static var instance:DirifinSave;

	public var highscores:SaveField<Map<String, Int>>;
	public var enabledMods:SaveField<Array<String>>;

	override public function new()
	{
		super();

		SAVE_VERSION = 3;
		init('Dirifin');
	}

	override function upgradeVersion(?onComplete:() -> Void)
	{
		switch (version.get())
		{
			case 1:
				trace('Support for v1 saves has ended as of 3.00');
		}

		super.upgradeVersion(onComplete);
	}

	override function initFields()
	{
		super.initFields();

		highscores = new SaveField<Map<String, Int>>('highscores', [], 'Highscores');
		enabledMods = new SaveField<Array<String>>('enabledMods', [], 'Enabled Mods');
	}
}
