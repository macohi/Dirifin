package dirifin.ui;

import flixel.group.FlxSpriteGroup;
import macohi.effects.DeltaruneKnight;
import dirifin.input.MenuStateControls;
import dirifin.play.PlayState;

class SurvivalModeState extends SpinningPlayerState
{
	public var float_tick:Int = 0;

	public var float_speed:Float = 50;
	public var float_height:Float = 100;

	public var ogPlayerY:Float = 0;

	public var playerTrail:FlxSpriteGroup;

	override function create()
	{
		spin_speed = 0.1;

		super.create();

		ogPlayerY = player.y;

		playerTrail = DeltaruneKnight.createYTrail(player, ogPlayerY, 0.1, .5, 3);
		add(playerTrail);
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		float_tick++;

		player.y = ogPlayerY + (Math.sin(float_tick * float_speed) * float_height);

		for (trail in playerTrail.members)
		{
			trail.scale.set(player.scale.x, player.scale.y);
			trail.updateHitbox();
		}

		MenuStateControls.controlsOther(function()
		{
			PlayState.SURVIVAL_MODE = true;
			switchState(() -> new PlayState());
		}, () -> new MainMenuState(), false);
	}
}
