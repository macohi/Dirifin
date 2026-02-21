package dirifin.ui;

import flixel.util.FlxColor;
import macohi.overrides.MSubState;
import macohi.overrides.MText;

class LoadingScreen extends MSubState
{
	public var loadingString(default, set):String = '';

	function set_loadingString(value:String):String
	{
		trace('Loading : ' + value);
		return value;
	}

	public var loadingText:MText;

	override function create()
	{
		super.create();

		loadingText = new MText().makeText('Loading...', 32);
		add(loadingText);
		loadingText.color = FlxColor.WHITE;
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		loadingText.screenCenter();
		loadingText.text = 'Loading : $loadingString';
	}
}
