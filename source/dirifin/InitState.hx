package dirifin;

import dirifin.input.Controls;
import dirifin.modding.DirifinModCore;
import dirifin.save.DirifinSave;
import dirifin.ui.MainMenuState;
import flixel.FlxG;
import macohi.debugging.CrashHandler;
import macohi.funkin.MegaVars;
import macohi.funkin.koya.backend.AssetPaths;
import macohi.funkin.koya.backend.AssetTextList;
import macohi.funkin.koya.backend.modding.ModCore;
import macohi.funkin.koya.backend.plugins.Cursor;
import macohi.overrides.MState;
import macohi.util.MusicManager;

class InitState extends MState
{
	public static var musicTextList:AssetTextList;

	override public function create()
	{
		super.create();

		CrashHandler.initalize('', 'Dirifin_', '', 'Dirifin');

		initalizeInstances();

		addPlugins();

		initalizeMacohiStuff();

		FlxG.signals.postUpdate.add(function()
		{
			if (FlxG.keys.justReleased.R)
				FlxG.openURL(CrashHandler.REPORT_PAGE);
		});

		switchState(() -> new MainMenuState());
	}

	public function initalizeInstances()
	{
		Controls.init();
		DirifinSave.instance = new DirifinSave();
	}

	public function addPlugins()
	{
		FlxG.plugins.addPlugin(new Cursor());
		Cursor.cursorVisible = false;

		FlxG.plugins.addPlugin(new MusicManager());

		musicTextList = new AssetTextList(AssetPaths.txt('data/songs'));
		MusicManager.tracks = musicTextList.textList;
	}

	public function initalizeMacohiStuff()
	{
		AssetPaths.soundExt = 'wav';

		MegaVars.KOYA_MENUBG_DESAT = function(lib) return null;
		MegaVars.KOYA_MENUBG_PINK = function(lib) return null;

		MegaVars.SOUND_MENU_BACK = AssetPaths.sound('menu_back');
		MegaVars.SOUND_MENU_SCROLL = AssetPaths.sound('menu_scroll');
		MegaVars.SOUND_MENU_CONFIRM = AssetPaths.sound('menu_confirm');

		MegaVars.KOYA_MENUITEM_LIBRARY = null;

		ModCore.instance = new DirifinModCore();
		ModCore.instance.init();
	}
}
