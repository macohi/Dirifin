package dirifin;

import flixel.FlxG;
import flixel.util.FlxColor;
import macohi.funkin.koya.frontend.ui.menustate.MenuState;
import macohi.overrides.MText;

class MainMenuState extends MenuState
{
	override public function new()
	{
		super(null, Vertical);

		this.text = true;
		this.atlasText = false;
		this.itemList = ['Play', 'Credits', 'Options'];
		this.itemIncOffset = 80;
	}

	override function create()
	{
		super.create();

		var leftWatermark:MText = new MText(10, 10, FlxG.width, 'left watermark', 8);
		leftWatermark.alignment = LEFT;

		leftWatermark.fieldWidth = FlxG.width - Math.abs(leftWatermark.x);
		leftWatermark.setBorderStyle(OUTLINE, FlxColor.BLACK, 3);
		leftWatermark.visible = false;

		leftWatermark.text = 'Version: ' + Version.VERSION;
		
		add(leftWatermark);
	}

	override function controlsMoveVertical()
	{
		super.controlsMoveVertical();

		if (Controls.instance.justPressed('up'))
			select(-1);
		if (Controls.instance.justPressed('down'))
			select(1);
	}

	override function controlsOther()
	{
		super.controlsOther();

		if (Controls.instance.justPressed('accept'))
			acceptFunction();
	}

	override function accept(item:String)
	{
		super.accept(item);

		if (item.toLowerCase() == 'play')
			FlxG.switchState(() -> new PlayState());
	}
}
