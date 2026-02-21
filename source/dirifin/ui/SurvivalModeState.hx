package dirifin.ui;

import macohi.effects.DeltaruneKnight;
import dirifin.input.MenuStateControls;
import dirifin.play.PlayState;

class SurvivalModeState extends SpinningPlayerState
{
	public var float_tick:Int = 0;

	public var float_speed:Float = 100;
	public var float_height:Float = 25;

	override function create() {
		spin_speed = 0.1;

		super.create();

		DeltaruneKnight.createYTrail(player, -200, 0.1, .5, 25);
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		float_tick++;

		player.y = Math.sin(float_tick * float_speed) * float_height;

		MenuStateControls.controlsOther(function()
		{
			PlayState.SURVIVAL_MODE = true;
			switchState(() -> new PlayState());
		}, () -> new MainMenuState(), false);
	}
}
