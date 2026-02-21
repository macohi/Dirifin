package dirifin.ui;

import flixel.FlxGame;
import flixel.system.FlxBasePreloader;

class LoadingScreen extends FlxBasePreloader
{
	override function create()
	{
		super.create();

		addChild(new FlxGame(0, 0, SpinningPlayerState, 60, 60, true));
	}
}
