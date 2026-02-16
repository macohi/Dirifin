import flixel.FlxGame;
import macohi.debugging.CrashHandler;
import openfl.display.Sprite;

class Main extends Sprite
{
	public function new()
	{
		super();
		CrashHandler.initalize('', 'Dirifin_', '', 'Dirifin');

		addChild(new FlxGame(0, 0, PlayState));
	}
}
