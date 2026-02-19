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
			var keys:Array<SaveField<Array<String>>> = [];

			return keys;
		}
	}

	override function altControls():Bool
	{
		return super.altControls();
	}
}
