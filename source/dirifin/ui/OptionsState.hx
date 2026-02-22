package dirifin.ui;

import dirifin.input.MenuStateControls;
import dirifin.save.DirifinSave;
import flixel.FlxG;
import flixel.sound.FlxSound;
import flixel.system.FlxAssets;
import macohi.backend.api.DiscordClient;
import macohi.funkin.koya.frontend.scenes.menustates.OptionsMenuState;

class OptionsState extends OptionsMenuState
{
	override function reloadMenuItems()
	{
		super.reloadMenuItems();

		if (!atlasText && text)
			for (text in itemsFlxTextGroup.members)
			{
				text.font = FlxAssets.FONT_DEFAULT;
				text.size -= 16;
			}
	}

	override function addItems()
	{
		addItem('Control Remap', 'Select to go remap your controls', function()
		{
			FlxG.switchState(() -> new ControlsRemapping());
		});

		addItemBasedOnSaveField(DirifinSave.instance.shootWithDirectionals, function()
		{
			DirifinSave.instance.shootWithDirectionals.set(!DirifinSave.instance.shootWithDirectionals.get());
		});

		addItemBasedOnSaveField(DirifinSave.instance.extraLives, function()
		{
			DirifinSave.instance.extraLives.set(DirifinSave.instance.extraLives.get() + 1);

			if (DirifinSave.instance.extraLives.get() >= 3)
				DirifinSave.instance.extraLives.set(0);
		});
	}

	override function create()
	{
		super.create();

		DiscordClient.changePresence('Customizing the game', 'Options Menu');

		valueText.font = FlxAssets.FONT_DEFAULT;
		valueText.size = 16;

		select();
	}

	override function controlsMoveVertical()
		MenuStateControls.controlsMoveVertical(select, transitioning);

	override function controlsOther()
		MenuStateControls.controlsOther(acceptFunction, () -> new MainMenuState(), transitioning);

	override function acceptedFlicker(confirmMenu:FlxSound, item:String)
	{
		transitioning = true;

		super.acceptedFlicker(confirmMenu, item);
	}
}
