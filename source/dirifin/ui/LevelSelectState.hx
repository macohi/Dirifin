package dirifin.ui;

import dirifin.input.Controls;
import dirifin.play.PlayState;
import flixel.FlxG;
import macohi.funkin.koya.backend.AssetPaths;
import macohi.funkin.koya.backend.AssetTextList;
import macohi.funkin.koya.frontend.ui.menustate.MenuItem;
import macohi.funkin.koya.frontend.ui.menustate.MenuState;

class LevelSelectState extends MenuState
{
	public var levelsTextList:AssetTextList = new AssetTextList(AssetPaths.txt('data/levels'));

	override public function new()
	{
		super('levelIcons/', Horizontal);

		itemIncOffset = 160;
		itemList = levelsTextList.textList;
	}

	override function makeSprite(item:String, i:Int)
	{
		var menuItem = new MenuItem(item, menuItemPathPrefix, (menuType == Horizontal) ? -640 : 0, (menuType == Vertical) ? -640 : 0);

		menuItem.loadGraphic(AssetPaths.image('$menuItemPathPrefix$item'), true, 16, 16);
		menuItem.applyPixelScale();

		menuItem.addAnimByFrames('idle', [0], 24);
		menuItem.addAnimByFrames('selected', [1], 24);

		if (menuType == Horizontal)
			menuItem.screenCenter(Y);
		if (menuType == Vertical)
			menuItem.screenCenter(X);

		menuItem.ID = i;
		itemsSpriteGroup.add(menuItem);
	}

	override function controlsMoveHorizontal()
	{
		super.controlsMoveHorizontal();

		if (Controls.instance.justPressed('left'))
			select(-1);
		if (Controls.instance.justPressed('right'))
			select(1);
	}

	override function controlsOther()
	{
		super.controlsOther();

		if (Controls.instance.justPressed('accept'))
			acceptFunction();
	}

	override function accepted(item:String)
	{
		super.accepted(item);

		FlxG.switchState(() -> new PlayState(item));
	}
}
