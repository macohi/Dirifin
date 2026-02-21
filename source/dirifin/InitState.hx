package dirifin;

import dirifin.input.Controls;
import dirifin.modding.DirifinModCore;
import dirifin.save.DirifinSave;
import dirifin.ui.MainMenuState;
import flixel.FlxG;
import haxe.Template;
import macohi.backend.api.DiscordClient;
import macohi.debugging.CrashHandler;
import macohi.debugging.CustomTrace;
import macohi.funkin.MegaVars;
import macohi.funkin.koya.backend.AssetPaths;
import macohi.funkin.koya.backend.AssetTextList;
import macohi.funkin.koya.backend.modding.ModCore;
import macohi.funkin.koya.backend.plugins.Cursor;
import macohi.funkin.koya.frontend.scenes.menustates.options.KeybindPrompt;
import macohi.overrides.MState;
import macohi.util.MusicManager;

using macohi.funkin.vslice.util.AnsiUtil;
using macohi.util.FlxKeyUtil;

class InitState extends MState
{
	public static var musicTextList:AssetTextList;

	override public function create()
	{
		super.create();

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

		defineManagement();

		trace('Completed initalization');

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
		Controls.loadKeybinds();
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

		DiscordClient.CLIENT_ID = '1473856507652083984';
		DiscordClient.LARGE_IMAGE_TEXT = 'Dirifin (${Version.VERSION})';
		DiscordClient.initialize();

		#if ENABLE_DISCORDRPC
		DiscordClient.changePresence('Initalizing stuff', 'InitState');
		trace('Initalized Discord RPC!');
		#else
		trace('Discord RPC not enabled');
		#end

		KeybindPrompt.getSave = function() return null;
		KeybindPrompt.getKeybind = (keybind, getSave) ->
		{
			for (bind in DirifinSave.instance.keybinds)
				if (bind.field == keybind)
					return bind;

			return null;
		}
		KeybindPrompt.getBack = function() return Controls.instance.justReleased('ui_back');

		KeybindPrompt.extraControls = function():String
		{
			return '\n\n'
				+ 'BACKSPACE to remove bind\n'
				+ 'SHIFT + BACKSPACE to add a bind\n'
				+ '${Controls.instance.keybinds.get('ui_back').stringArrayToKeysArray().youCanPressString()} to leave\n';
		}

		KeybindPrompt.extraControlFunctions = function(prompt:KeybindPrompt):Bool
		{
			if (FlxG.keys.justPressed.BACKSPACE)
			{
				if (!FlxG.keys.pressed.SHIFT)
				{
					prompt.promptText.text = 'Removed OG Bind #${prompt.keyNum + 1}';
					prompt.keybindField.get().remove(prompt.keybindField.get()[prompt.keyNum]);
				}
				else
				{
					prompt.promptText.text = 'Added extra bind';
					prompt.keybindField.get().push(null);
				}
				prompt.pauseTick = 100;

				return false;
			}

			return true;
		}

		trace('Initalized KeybindPrompt shit!');
	}

	public function defineManagement()
	{
		var defineShit = [
			'Define Shit',
			' * Build: ::buildtype::',
			' * CLEAR_LOGS:::CLEAR_LOGS::',
		];

		var enabled_bg = ' enabled '.bg_bright_green();
		var disabled_bg = ' disabled '.bg_bright_red();

		for (shit in defineShit)
		{
			var shitTemp = new Template(shit);
			trace(' ${shitTemp.execute({
				buildtype: #if debug 'Debug' #else 'Release' #end,

				CLEAR_LOGS: #if CLEAR_LOGS enabled_bg #else disabled_bg #end,
			})} '.bold()
				.bg_bright_black());
		}
	}
}
