package dirifin;

import dirifin.input.Controls;
import dirifin.modding.DirifinModCore;
import dirifin.save.DirifinSave;
import dirifin.ui.MainMenuState;
import flixel.FlxG;
import haxe.Timer;
import macohi.debugging.CrashHandler;
import macohi.debugging.CustomTrace;
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

		Timer.measure(function()
		{
			CustomTrace.ALLOW_ANSI = false;
			haxe.Log.trace = CustomTrace.newTrace;
			
			CrashHandler.initalize('', 'Dirifin_', '', 'Dirifin');

			initalizeInstances();

			addPlugins();

			initalizeMacohiStuff();

			FlxG.signals.postUpdate.add(function()
			{
				if (musicTextList != null && !compareMusicTracks())
				{
					trace('UPDATING TRACK LIST');
					MusicManager.tracks = musicTextList.textList;

					trace('Track list:');
					for (track in MusicManager.tracks)
						trace(' * $track');
				}

				if (FlxG.keys.justReleased.R)
					FlxG.openURL(CrashHandler.REPORT_PAGE);
			});

			trace('Completed initalization');
		});

		switchState(() -> new MainMenuState());
	}

	public function compareMusicTracks():Bool
	{
		var mmt:Int = 0;
		var mtltl:Int = 0;

		for (track in MusicManager.tracks)
			mmt += track.length;

		for (track in musicTextList.textList)
			mtltl += track.length;

		return mmt == mtltl;
	}

	public function initalizeInstances()
	{
		Controls.init();
		DirifinSave.instance = new DirifinSave();
	}

	public function addPlugins()
	{
		trace('Adding plugins');

		FlxG.plugins.addPlugin(new Cursor());
		Cursor.cursorVisible = false;

		trace('Hidden cursor');

		FlxG.plugins.addPlugin(new MusicManager());
		musicTextList = new AssetTextList(AssetPaths.txt('data/songs'));
		MusicManager.tracks = musicTextList.textList;

		trace('Added plugins');
	}

	public function initalizeMacohiStuff()
	{
		AssetPaths.soundExt = 'wav';

		trace('Initalized AssetPaths stuff');

		MegaVars.KOYA_MENUBG_DESAT = function(lib) return null;
		MegaVars.KOYA_MENUBG_PINK = function(lib) return null;

		MegaVars.SOUND_MENU_BACK = AssetPaths.sound('menu_back');
		MegaVars.SOUND_MENU_SCROLL = AssetPaths.sound('menu_scroll');
		MegaVars.SOUND_MENU_CONFIRM = AssetPaths.sound('menu_confirm');

		MegaVars.KOYA_MENUITEM_LIBRARY = null;

		trace('Initalized MegaVars stuff');

		ModCore.instance = new DirifinModCore();
		ModCore.instance.init();

		trace('Initalized MOD CORE!');
	}
}
