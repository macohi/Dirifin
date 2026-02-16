package dirifin;

import flixel.FlxG;
import macohi.debugging.CrashHandler;
import macohi.funkin.koya.backend.AssetPaths;
import macohi.funkin.koya.backend.plugins.Cursor;
import macohi.overrides.MState;
#if !js
import flixel.addons.plugin.screengrab.FlxScreenGrab;
#end

class InitState extends MState
{
	override public function create()
	{
		super.create();

		CrashHandler.initalize('', 'Dirifin_', '', 'Dirifin');

		Controls.init();
		DirifinSave.instance = new DirifinSave();

		FlxG.plugins.addPlugin(new Cursor());
		Cursor.cursorVisible = false;

		#if !js
		FlxG.plugins.addPlugin(new FlxScreenGrab());
		FlxScreenGrab.defineHotKeys([F2], true, true);
		#end

		AssetPaths.soundExt = 'wav';

		switchState(() -> new PlayState());
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);
	}
}
