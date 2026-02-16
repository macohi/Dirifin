package dirifin;

import macohi.debugging.CrashHandler;
import macohi.funkin.koya.backend.AssetPaths;
import macohi.overrides.MState;

class InitState extends MState
{
	override public function create()
	{
		super.create();

		CrashHandler.initalize('', 'Dirifin_', '', 'Dirifin');

		Controls.init();

		AssetPaths.soundExt = 'wav';

		switchState(() -> new PlayState());
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);
	}
}
