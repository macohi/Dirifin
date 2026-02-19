package dirifin.input;

import flixel.input.keyboard.FlxKey;
import macohi.util.ControlClass;

using macohi.util.FlxKeyUtil;

class Controls
{
	public static var instance:ControlClass;

	public static function init()
	{
		trace('Initalizing Controls instance');
		instance = new ControlClass();

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

		trace('Initalized Controls instance');

		trace('Keybinds : ');
		for (keybind => keys in instance.keybinds)
			trace(' * $keybind : $keys');
	}
}
