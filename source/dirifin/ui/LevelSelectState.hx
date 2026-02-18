package dirifin.ui;

import macohi.funkin.koya.frontend.ui.menustate.MenuState;

class LevelSelectState extends MenuState
{
	override public function new()
	{
		super('levelIcons/', Horizontal);

		itemIncOffset = 80;
		itemList = ['level1', 'level2',];
	}
}
