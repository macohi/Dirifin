package dirifin;

import flixel.util.FlxColor;

class Bullet extends DirectionSprite
{
	override public function new(?speedDamp:Null<Float>, ?x:Float, ?y:Float)
	{
		super(speedDamp, x, y);

		makeGraphic(16, 8, FlxColor.YELLOW);
		boundsPadding = this.width * 4;
	}

	public function makeBullet(player:Player):Bullet
	{
		screenCenter();

		changeDirection(player.direction, player);

		return this;
	}
}
