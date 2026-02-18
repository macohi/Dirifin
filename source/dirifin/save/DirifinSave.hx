package dirifin.save;

import flixel.FlxG;
import macohi.save.Save;
import macohi.save.SaveField;

class DirifinSave extends Save
{
	public static var instance:DirifinSave;

	@:deprecated('"highscore" save field outdated as of 2.00')
	public var highscore:SaveField<Int>;

	public var highscores:SaveField<Map<String, Int>>;
	public var enabledMods:SaveField<Array<String>>;

	override public function new()
	{
		super();

		SAVE_VERSION = 2;
		init('Dirifin');
	}

	override function upgradeVersion(?onComplete:() -> Void)
	{
		switch (version.get())
		{
			case 1:
				highscores.get().set('level1', highscore.get());
		}

		Reflect.deleteField(FlxG.save.data, highscore.field);

		super.upgradeVersion(onComplete);
	}

	override function initFields()
	{
		super.initFields();

		highscore = new SaveField<Int>('highscore', 0, 'Highscore');
		highscores = new SaveField<Map<String, Int>>('highscores', [], 'Highscores');
		enabledMods = new SaveField<Array<String>>('enabledMods', [], 'Enabled Mods');
	}
}
