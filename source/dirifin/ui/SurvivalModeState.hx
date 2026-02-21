package dirifin.ui;

import dirifin.input.MenuStateControls;
import dirifin.play.PlayState;
import macohi.overrides.MState;

class SurvivalModeState extends MState
{
	override function create()
	{
		super.create();
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		MenuStateControls.controlsOther(function()
		{
			PlayState.SURVIVAL_MODE = true;
			switchState(() -> new PlayState());
		}, () -> new MainMenuState(), false);
	}
}
