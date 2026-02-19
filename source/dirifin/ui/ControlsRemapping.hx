package dirifin.ui;

import dirifin.input.Controls;
import flixel.input.keyboard.FlxKey;
import macohi.funkin.koya.frontend.scenes.menustates.options.ControlRemap;
import macohi.funkin.koya.frontend.scenes.menustates.options.KeybindPrompt;
import macohi.save.SaveField;

using macohi.util.ArrayUtil;
using macohi.util.FlxKeyUtil;

class ControlsRemapping extends ControlRemap
{
	override public function new()
	{
		super();

		KeybindPrompt.keybinds = function()
		{
			var keys:Array<SaveField<String>> = [];

			return keys;
		}
	}

	override function altControls():Bool
	{
		var ci = Controls.instance;
		var keys:Array<FlxKey> = [];

		for (alt_keys in [ci.keybinds.get('ui_left'), ci.keybinds.get('ui_right')])
		{
			var thekeysinthekeybind = alt_keys.stringArrayToKeysArray();

			for (thekeys in thekeysinthekeybind)
				keys.push(thekeys.keyToString());
		}

		valueText.text += '\n\n( Toggle alts via ${keys.youCanPressString()} )';

		return super.altControls();
	}
}
