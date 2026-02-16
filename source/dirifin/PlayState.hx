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
	}
}
