package dirifin.ui;

import dirifin.input.MenuStateControls;
import dirifin.play.PlayState;

class SurvivalModeState extends SpinningPlayerState
{
	public var tick:Int = 0;

	public var speed:Float = 100;
	public var height:Float = 25;


	override function update(elapsed:Float)
	{
		super.update(elapsed);

		player.y = Math.sin(tick * speed) * height;

		MenuStateControls.controlsOther(function()
		{
			PlayState.SURVIVAL_MODE = true;
			switchState(() -> new PlayState());
		}, () -> new MainMenuState(), false);
	}
}
