package dirifin.ui;

import dirifin.input.MenuStateControls;
import dirifin.ui.ModMenuState.ModsMenuState;
import flixel.FlxG;
import flixel.system.FlxAssets;
import flixel.util.FlxColor;
import macohi.backend.api.DiscordClient;
import macohi.funkin.koya.backend.modding.ModCore;
import macohi.funkin.koya.frontend.ui.menustate.MenuState;
import macohi.overrides.MText;

class MainMenuState extends MenuState
{
	override public function new()
	{
		super(null, Vertical);

		this.text = true;
		this.atlasText = false;
		this.itemList = ['Level Select', 'Credits', 'Mods', 'Options',];
		this.itemIncOffset = 80;
	}

	override function create()
	{
		super.create();

		DiscordClient.changePresence('Scrolling through the options', 'Main Menu');

		var leftWatermark:MText = new MText(10, 10, FlxG.width, 'left watermark', 16);
		leftWatermark.alignment = LEFT;

		leftWatermark.fieldWidth = FlxG.width - Math.abs(leftWatermark.x);
		leftWatermark.setBorderStyle(OUTLINE, FlxColor.BLACK, 3);

		leftWatermark.text = 'Version: ' + Version.VERSION;

		add(leftWatermark);

		select();
	}

	override function reloadMenuItems()
	{
		super.reloadMenuItems();

		if (!atlasText && text)
			for (text in itemsFlxTextGroup.members)
				text.font = FlxAssets.FONT_DEFAULT;
	}

	override function controlsMoveVertical()
		MenuStateControls.controlsMoveVertical(select);

	override function controlsOther()
		MenuStateControls.controlsOther(acceptFunction, null);

	override function select(change:Int = 0)
	{
		super.select(change);

		if (text && !atlasText)
			for (menuItem in itemsFlxTextGroup)
			{
				if (!(ModCore.instance.allMods.length > 0) && menuItem.text.toLowerCase() == 'mods')
					menuItem.alpha -= 0.4;
			}
	}

	override function accept(item:String)
	{
		super.accept(item);

		switch (item.toLowerCase())
		{
			case 'level select':
				FlxG.switchState(() -> new LevelSelectState());
			case 'credits':
				FlxG.switchState(() -> new CreditsRoll());
			case 'mods':
				if (ModCore.instance.allMods.length > 0)
					FlxG.switchState(() -> new ModsMenuState());
			case 'options':
				FlxG.switchState(() -> new OptionsState());
		}
	}
}
