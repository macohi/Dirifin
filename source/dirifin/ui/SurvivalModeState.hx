package dirifin.ui;

import dirifin.input.MenuStateControls;
import dirifin.play.PlayState;

class SurvivalModeState extends SpinningPlayerState
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
