package dirifin;

import macohi.funkin.koya.frontend.ui.menustate.MenuState;

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

	override function controlsMoveVertical()
	{
		super.controlsMoveVertical();

		if (Controls.instance.justPressed('up'))
			select(-1);
		if (Controls.instance.justPressed('down'))
			select(1);
	}
}
