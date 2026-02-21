package dirifin.input;

import dirifin.save.DirifinSave;
import flixel.input.keyboard.FlxKey;
import macohi.util.ControlClass;

using macohi.funkin.vslice.util.AnsiUtil;
using macohi.util.FlxKeyUtil;

class Controls
{
	public static var instance:ControlClass;

	public static function init()
	{
		trace(' CONTROLS '.bold().bg_bright_lilac() + ' Initalizing Controls instance');
		instance = new ControlClass();

		loadKeybinds();

		trace(' CONTROLS '.bold().bg_bright_lilac() + ' Initalized Controls instance');
	}

	public static function loadKeybinds()
	{
		instance.keybinds.set('ui_left', [LEFT, A].keysArrayToStringArray());
		instance.keybinds.set('ui_down', [DOWN, S].keysArrayToStringArray());
		instance.keybinds.set('ui_up', [UP, W].keysArrayToStringArray());
		instance.keybinds.set('ui_right', [RIGHT, D].keysArrayToStringArray());
		instance.keybinds.set('ui_accept', [ENTER].keysArrayToStringArray());
		instance.keybinds.set('ui_back', [ESCAPE].keysArrayToStringArray());

		instance.keybinds.set('gameplay_left', [LEFT, A].keysArrayToStringArray());
		instance.keybinds.set('gameplay_down', [DOWN, S].keysArrayToStringArray());
		instance.keybinds.set('gameplay_up', [UP, W].keysArrayToStringArray());
		instance.keybinds.set('gameplay_right', [RIGHT, D].keysArrayToStringArray());
		instance.keybinds.set('gameplay_fire', [SPACE].keysArrayToStringArray());

		if (DirifinSave.instance != null)
		{
			for (keybind in DirifinSave.instance.keybinds)
				if (instance.keybinds.exists(keybind.field))
					instance.keybinds.set(keybind.field, keybind.get());
			trace(' CONTROLS '.bold().bg_bright_lilac() + ' Loaded save keybinds');
		}
		else
		{
			trace(' CONTROLS '.bold().bg_bright_lilac() + ' Initalized default keybinds:');
		}

		#if debug
		for (keybind => keys in instance.keybinds)
			trace(' CONTROLS '.bold().bg_bright_lilac() + '  * $keybind : $keys');
		#end
	}
}
