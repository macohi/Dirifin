package dirifin.ui;

import dirifin.play.Highscores;
import dirifin.save.DirifinSave;
import dirifin.play.LevelJSON;
import macohi.overrides.MText;
import flixel.FlxG;
import flixel.group.FlxSpriteGroup;
import macohi.effects.DeltaruneKnight;
import dirifin.input.MenuStateControls;
import dirifin.play.PlayState;

class SurvivalModeState extends SpinningPlayerState
{
	public var float_tick:Int = 0;

	public var float_speed:Float = 1 / 16;
	public var float_height:Float = 100;

	public var ogPlayerY:Float = 0;

	public var playerTrail:FlxSpriteGroup;

	public var randomLevel:String = '';

	public var levelText:MText;

	override function create()
	{
		spin_speed = 0.1;

		super.create();

		ogPlayerY = player.y;

		playerTrail = DeltaruneKnight.createYTrailTargetY(player, ogPlayerY, spin_speed, .5, 4);
		insert(members.indexOf(player) - 1, playerTrail);

		randomLevel = LevelSelectState.levelsTextList.textList[FlxG.random.int(0, LevelSelectState.levelsTextList.textList.length - 1)];

		var levelJSON:LevelJSONData = LevelJSONClass.loadLevelJSON(randomLevel, false);

		function getLevelInfo(level:String)
		{
			var level:String = 'Level: ${level.toUpperCase()}';

			var suffix:String = '-survival';
			var hss:String = ' (SURVIVAL';

			if (DirifinSave.instance.shootWithDirectionals.get())
			{
				suffix += '-swd';
				hss += '-SWD';
			}

			hss += ')';

			var highscore:String = 'Highscore$hss: ${Highscores.getHighscore(level + suffix)}';

			return '${level}\n${highscore}';
		}

		levelText = new MText().makeText(getLevelInfo(randomLevel), 16);
		add(levelText);
		levelText.screenCenter();
		levelText.y = (FlxG.height * 0.9) - (levelText.height * 1);
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		float_tick++;

		player.y = ogPlayerY + (Math.sin(float_tick * float_speed) * float_height);

		for (trail in playerTrail.members)
		{
			if (trail == null)
				continue;

			trail.scale.set(player.scale.x, player.scale.y);
			trail.updateHitbox();
		}

		MenuStateControls.controlsOther(function()
		{
			PlayState.SURVIVAL_MODE = true;
			switchState(() -> new PlayState(randomLevel));
		}, () -> new MainMenuState(), false);
	}
}
