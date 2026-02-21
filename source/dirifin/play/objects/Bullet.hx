package dirifin.play.objects;

class Bullet extends DirectionSprite
{
	public var dying:Bool = false;

	override public function new(?speedDamp:Null<Float>, ?x:Float, ?y:Float)
	{
		super(speedDamp, x, y);

		makeGraphic(16, 8);

		scale.set(2, 2);
		updateHitbox();

		boundsPadding = this.width * 4;
	}

	public function makeBullet(player:Player):Bullet
	{
		screenCenter();

		changeDirection(player.direction, player);

		return this;
	}
}
