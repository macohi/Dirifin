package dirifin.ui;

import dirifin.input.MenuStateControls;
import dirifin.play.PlayState;
import dirifin.play.objects.Player;
import flixel.util.FlxTimer;
import macohi.overrides.MState;

class SurvivalModeState extends MState
{
	public var player:Player;

	override function create()
	{
		super.create();

		player = new Player();
		player.screenCenter();
		add(player);

		new FlxTimer().start(0.4, function(t)
		{
			switch (player.direction)
			{
				case LEFT:
					player.changeDirection(DOWN);
				case DOWN:
					player.changeDirection(UP);
				case UP:
					player.changeDirection(RIGHT);
				case RIGHT:
					player.changeDirection(LEFT);
			}
		}, 0);
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
