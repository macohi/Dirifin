package dirifin;

import macohi.debugging.CrashHandler;
import macohi.overrides.MState;

class InitState extends MState
{
	override public function create()
	{
		super.create();

		CrashHandler.initalize('', 'Dirifin_', '', 'Dirifin');
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);
	}
}
