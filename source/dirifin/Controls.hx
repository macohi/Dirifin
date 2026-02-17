package dirifin;

import flixel.input.keyboard.FlxKey;
import macohi.util.ControlClass;

using macohi.util.FlxKeyUtil;

class Controls
{
	public static var instance:ControlClass;

	public static function init()
	{
		instance = new ControlClass();

		instance.keybinds.set('left', [LEFT, A].keysArrayToStringArray());
		instance.keybinds.set('down', [DOWN, S].keysArrayToStringArray());
		instance.keybinds.set('up', [UP, W].keysArrayToStringArray());
		instance.keybinds.set('right', [RIGHT, D].keysArrayToStringArray());

		instance.keybinds.set('fire', [SPACE].keysArrayToStringArray());
		instance.keybinds.set('accept', [ENTER].keysArrayToStringArray());
		
		instance.keybinds.set('back', [ESCAPE].keysArrayToStringArray());
	}
}
