package dirifin;

import dirifin.Player.PlayerDirection;
import flixel.group.FlxSpriteGroup.FlxTypedSpriteGroup;
import macohi.overrides.MState;

class PlayState extends MState
{
	public var player:Player;

	public var directionArrows:FlxTypedSpriteGroup<DirectionArrow>;

	override function create()
	{
		super.create();

		player = new Player();
		player.screenCenter();
		add(player);

		directionArrows = new FlxTypedSpriteGroup<DirectionArrow>();
		add(directionArrows);
		
		for (i in 0...3)
		{
			var da = new DirectionArrow();
			da.ID = i;
			directionArrows.add(da);

			switch(i)
			{
				case PlayerDirection.LEFT:
					da.x = player.x - player.width - da.width;
				case PlayerDirection.RIGHT:
					da.x = player.x + player.width + da.width;
					da.flipX = true;
					
				case PlayerDirection.UP:
					da.y = player.y - player.height - da.height;
					da.angle = -90;
				case PlayerDirection.DOWN:
					da.y = player.y + player.height + da.height;
					da.angle = 90;
			}
		}
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
