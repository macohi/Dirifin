package dirifin.ui;

import dirifin.input.MenuStateControls;
import dirifin.play.Highscores;
import dirifin.play.LevelBG;
import dirifin.play.LevelJSON.LevelJSONClass;
import dirifin.play.LevelJSON.LevelJSONData;
import dirifin.play.PlayState;
import dirifin.save.DirifinSave;
import flixel.FlxG;
import flixel.group.FlxSpriteGroup.FlxTypedSpriteGroup;
import flixel.math.FlxMath;
import flixel.sound.FlxSound;
import flixel.system.FlxAssets;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import macohi.backend.api.DiscordClient;
import macohi.funkin.koya.backend.AssetPaths;
import macohi.funkin.koya.backend.AssetTextList;
import macohi.funkin.koya.frontend.scenes.menustates.OptionsMenuState;
import macohi.funkin.koya.frontend.ui.menustate.MenuItem;

class LevelSelectState extends OptionsMenuState
{
	public var levelsTextList:AssetTextList = new AssetTextList(AssetPaths.txt('data/levels'));

	public var levelBGs:FlxTypedSpriteGroup<LevelBG> = new FlxTypedSpriteGroup<LevelBG>();

	override public function new()
	{
		super();

		menuItemPathPrefix = 'levelIcons/';
		menuType = Horizontal;

		itemIncOffset = 160;

		text = false;
	}

	override function addItems()
	{
		super.addItems();

		for (level in levelsTextList.textList)
		{
			var levelJSON:LevelJSONData = LevelJSONClass.loadLevelJSON(level, false);

			function getLevelInfo(level:String)
			{
				var diff:String = 'Difficulty: ${levelJSON?.settings?.difficulty?.regular ?? 0}';
				var highscore:String = 'Highscore: ${Highscores.getHighscore(level)}';

				if (DirifinSave.instance.shootWithDirectionals.get())
				{
					diff = 'Difficulty (SWD): ${levelJSON?.settings?.difficulty?.swd ?? 0}';
					highscore = 'Highscore (SWD): ${Highscores.getHighscore(level + '-swd')}';
				}

				return '${diff}\n${highscore}';
			}

			addItem(level, getLevelInfo(level), null);
		}
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
		MenuStateControls.controlsMoveHorizontal(select, transitioning);

	override function controlsOther()
		MenuStateControls.controlsOther(acceptFunction, () -> new MainMenuState(), transitioning);

	override function accept(item:String)
	{
		super.accept(item);

		FlxG.switchState(() -> new PlayState(item));
	}

	override function create()
	{
		super.create();

		DiscordClient.changePresence('What to play...', 'Level Select');

		valueText.font = FlxAssets.FONT_DEFAULT;
		valueText.size = 16;

		insert(0, levelBGs);

		for (i => level in itemList)
		{
			var levelBG = new LevelBG(level);

			levelBG.screenCenter();
			levelBG.ID = i;
			levelBG.alpha = 0;

			if (levelBG.graphic != null)
				levelBGs.add(levelBG);
		}

		select();
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		for (levelBG in levelBGs)
		{
			levelBG.screenCenter();

			if (menuType == Vertical)
				levelBG.y = FlxMath.lerp(levelBG.y, (FlxG.height - levelBG.height) / 2 - (currentSelection.value() * 6), .1);
			else
				levelBG.x = FlxMath.lerp(levelBG.x, (FlxG.width - levelBG.width) / 2 - (currentSelection.value() * 6), .1);
		}

		valueText.text = '${this.itemListValues.get(this.itemList[currentSelection.value()])}';
		valueText.y = valueBG.getGraphicMidpoint().y - (valueText.height / 2);
	}

	override function select(change:Int = 0)
	{
		super.select(change);

		for (levelBG in levelBGs)
		{
			FlxTween.cancelTweensOf(levelBG);
			FlxTween.tween(levelBG, {
				alpha: (currentSelection.value() == levelBG.ID) ? 0.4 : 0
			}, 0.3, {
				ease: FlxEase.quadInOut
			});
		}
	}

	override function acceptedFlicker(confirmMenu:FlxSound, item:String)
	{
		transitioning = true;

		super.acceptedFlicker(confirmMenu, item);
	}
}
