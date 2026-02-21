package dirifin.ui;

import dirifin.play.objects.Player;
import flixel.util.FlxTimer;
import macohi.overrides.MState;

class SpinningPlayerState extends MState
{
	public var player:Player;

	public var spin_speed:Float = 0.4;

	override function create()
	{
		super.create();

		player = new Player();
		player.screenCenter();
		add(player);

		new FlxTimer().start(spin_speed, function(t)
		{
			switch (player.direction)
			{
				case LEFT:
					player.changeDirection(DOWN);
				case DOWN:
					player.changeDirection(RIGHT);
				case RIGHT:
					player.changeDirection(UP);
				case UP:
					player.changeDirection(LEFT);
			}
		}, 0);
	}
}
