package dirifin.save;

import macohi.save.Save;
import macohi.save.SaveField;

class DirifinSave extends Save
{
	public static var instance:DirifinSave;

	public var highscore:SaveField<Int>;

	override public function new()
	{
		super();

		SAVE_VERSION = 1;
		init('Dirifin');
	}

	override function initFields()
	{
		super.initFields();

		highscore = new SaveField<Int>('highscore', 0, 'Highscore');
	}
}
