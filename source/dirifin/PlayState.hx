package dirifin;

import macohi.overrides.MState;

class PlayState extends MState
{
	public var player:Player;

	override function create()
	{
		super.create();

		player = new Player();
		player.screenCenter();
		add(player);
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		directionControls();
	}

	public function directionControls()
	{
		if (Controls.instance.justReleased('left'))
			player.changeDirection(LEFT);
		if (Controls.instance.justReleased('down'))
			player.changeDirection(DOWN);
		if (Controls.instance.justReleased('up'))
			player.changeDirection(UP);
		if (Controls.instance.justReleased('right'))
			player.changeDirection(RIGHT);
	}
}
