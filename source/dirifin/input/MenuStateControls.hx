package dirifin.input;

import flixel.FlxG;
import flixel.util.typeLimit.NextState;

class MenuStateControls
{
	public static function controlsMoveVertical(select:Int->Void, transitioning:Bool)
	{
		if (select == null || transitioning)
			return;

		if (Controls.instance.justPressed('ui_up'))
			select(-1);
		if (Controls.instance.justPressed('ui_down'))
			select(1);
	}

	public static function controlsMoveHorizontal(select:Int->Void, transitioning:Bool)
	{
		if (select == null || transitioning)
			return;

		if (Controls.instance.justPressed('ui_left'))
			select(-1);
		if (Controls.instance.justPressed('ui_right'))
			select(1);
	}

	public static function controlsOther(?acceptFunction:Void->Void, ?backState:NextState, transitioning:Bool)
	{
		if (transitioning)
			return;

		if (acceptFunction != null)
			if (Controls.instance.justPressed('ui_accept'))
				acceptFunction();

		if (backState != null)
			if (Controls.instance.justReleased('ui_back'))
				FlxG.switchState(backState);
	}
}
