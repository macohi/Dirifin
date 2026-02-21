package dirifin;

import dirifin.ui.LevelSelectState;
import dirifin.input.Controls;
import dirifin.modding.DirifinModCore;
import dirifin.save.DirifinSave;
import dirifin.ui.MainMenuState;
import dirifin.ui.SpinningPlayerState;
import flixel.FlxG;
import flixel.util.FlxTimer;
import haxe.Template;
import lime.app.Application;
import macohi.backend.api.DiscordClient;
import macohi.debugging.CrashHandler;
import macohi.debugging.CustomTrace;
import macohi.funkin.MegaVars;
import macohi.funkin.koya.backend.AssetPaths;
import macohi.funkin.koya.backend.AssetTextList;
import macohi.funkin.koya.backend.modding.ModCore;
import macohi.funkin.koya.backend.plugins.Cursor;
import macohi.funkin.koya.frontend.scenes.menustates.options.KeybindPrompt;
import macohi.util.MusicManager;

using macohi.funkin.vslice.util.AnsiUtil;
using macohi.util.FlxKeyUtil;
using macohi.util.StringUtil;

class InitState extends SpinningPlayerState
{
	public static var musicTextList:AssetTextList;

	override public function create()
	{
		super.create();

		CustomTrace.ALLOW_ANSI = false;
		haxe.Log.trace = CustomTrace.newTrace;

		Application.current.window.title = 'Dirifin ${Version.VERSION}';
		trace(Application.current.window.title.bold().bg_bright_green());

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
				{
					trace(' * $track');
					
					FlxG.assets.loadSound(track, true);
				}
			}

			if (FlxG.keys.justReleased.R)
				FlxG.openURL(CrashHandler.REPORT_PAGE);
		});

		defineManagement();

		LevelSelectState.levelsTextList = new AssetTextList(AssetPaths.txt('data/levels'));

		trace('Completed initalization');

		new FlxTimer().start((spin_speed * 4) * FlxG.random.int(0, 2), (t) ->
		{
			switchState(() -> new MainMenuState());
		});
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
			' Define Shit '.bg_bright_black(),
			' * Build: ::buildtype::',
			'',
			' * CLEAR_LOGS: ::CLEAR_LOGS::',
			' * ZOOM_OUT: ::ZOOM_OUT::',
			' * MOD_SUPPORT: ::MOD_SUPPORT::',
			' * CRASH_HANDLER: ::CRASH_HANDLER::',
			' * ENABLE_DISCORDRPC: ::ENABLE_DISCORDRPC::',
			' * ENABLE_NEWGROUNDS: ::ENABLE_NEWGROUNDS::',
		];

		var enabledBG = ' ✔ '.bg_bright_green();
		var disabledBG = ' ✖ '.bg_bright_red();

		for (shit in defineShit)
		{
			if (shit.isBlankStr())
			{
				trace('');
				continue;
			}

			var shitTemp = new Template(shit);
			trace('${shitTemp.execute({
				buildtype: #if debug 'Debug' #else 'Release' #end,

				ENABLE_NEWGROUNDS: #if ENABLE_NEWGROUNDS enabledBG #else disabledBG #end,
				MOD_SUPPORT: #if MOD_SUPPORT enabledBG #else disabledBG #end,
				CRASH_HANDLER: #if CRASH_HANDLER enabledBG #else disabledBG #end,
				ZOOM_OUT: #if ZOOM_OUT enabledBG #else disabledBG #end,
				ENABLE_DISCORDRPC: #if ENABLE_DISCORDRPC enabledBG #else disabledBG #end,
				CLEAR_LOGS: #if CLEAR_LOGS enabledBG #else disabledBG #end,
			})}'.bold());
		}
	}
}
