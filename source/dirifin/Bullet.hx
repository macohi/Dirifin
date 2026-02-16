package dirifin;

import flixel.util.FlxColor;
import macohi.funkin.koya.backend.AssetPaths;

class Bullet extends DirectionSprite
{
	public var dying:Bool = false;

	override public function new(?speedDamp:Null<Float>, ?x:Float, ?y:Float)
	{
		super(speedDamp, x, y);

		loadGraphic(AssetPaths.image('bullet'));
		boundsPadding = this.width * 4;
	}

	public function makeBullet(player:Player):Bullet
	{
		screenCenter();

		changeDirection(player.direction, player);

		return this;
	}
}
