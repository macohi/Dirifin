package dirifin;

import macohi.funkin.koya.frontend.ui.menustate.MenuState;

class MainMenuState extends MenuState
{
	override public function new()
	{
		super(null, Vertical);

		this.text = true;
		this.atlasText = false;
		this.itemList = ['Play', 'Credits', 'Option'];
	}
}
