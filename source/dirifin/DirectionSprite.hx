package dirifin;

import dirifin.Player.PlayerDirection;
import macohi.overrides.MSprite;

class DirectionSprite extends MSprite
{
	public var direction:PlayerDirection = DOWN;

	public function changeDirection(direction:PlayerDirection, ?player:Player)
	{
		this.direction = direction;

		if (player == null) return;

		switch (this.direction)
		{
			case LEFT:
				this.x -= player.width;
			case RIGHT:
				this.x += player.width;
				this.flipX = true;

			case UP:
				this.y -= player.height;
				this.angle = 90;
			case DOWN:
				this.y += player.height;
				this.angle = -90;
		}
	}
}
