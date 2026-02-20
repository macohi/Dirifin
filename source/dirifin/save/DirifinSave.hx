package dirifin.save;

import dirifin.input.Controls;
import macohi.funkin.koya.frontend.scenes.menustates.options.KeybindPrompt;
import macohi.funkin.vslice.util.SortUtil;
import macohi.save.Save;
import macohi.save.SaveField;

class DirifinSave extends Save
{
	public static var instance:DirifinSave;

	public var highscores:SaveField<Map<String, Int>>;
	public var enabledMods:SaveField<Array<String>>;

	public var keybinds:Array<SaveField<Array<String>>> = [];

	public var shootWithDirectionals:SaveField<Bool>;

	override public function new()
	{
		super();

		SAVE_VERSION = 5;
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

		for (keybind => keybibnd_keybinds in Controls.instance.keybinds)
		{
			var keySave = new SaveField<Array<String>>(keybind, keybibnd_keybinds, keybind);
			keySave.get();

			keybinds.push(keySave);
		}

		keybinds.sort((field1, field2) ->
		{
			return SortUtil.alphabetically(field1.field, field2.field);
		});

		KeybindPrompt.keybinds = function()
		{
			var keys:Array<SaveField<Array<String>>> = [];

			for (key in DirifinSave.instance.keybinds)
				keys.push(key);

			return keys;
		}

		shootWithDirectionals = new SaveField<Bool>('shootWithDirectionals', false, 'Shoot with Directionals');
		shootWithDirectionals.description = 'Toggles if you shoot by changing direction\nEnabled: ';
	}
}
