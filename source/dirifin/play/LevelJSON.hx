package dirifin.play;

import haxe.Json;
import macohi.funkin.koya.backend.AssetPaths;
import macohi.funkin.koya.backend.KoyaAssets;
import macohi.typedefs.MinMaxTypedef;
import macohi.util.WindowUtil;

typedef EnemySpawningData =
{
	dupe_direction_chance:Float,
	spawn_chance:MinMaxTypedef
}

typedef LevelJSONData =
{
	enemySpawning:EnemySpawningData
}

class LevelJSONClass
{
	public static var DEFAULT_LEVEL_JSON:LevelJSONData = {
		enemySpawning: {
			dupe_direction_chance: 10.0,
			spawn_chance: {
				max: 3.0,
				min: 0.0
			}
		}
	}

	public static function loadLevelJSON(level:String):LevelJSONData
	{
		var levelJSONPath:String = AssetPaths.json('data/levels/$level');

		if (KoyaAssets.exists(levelJSONPath))
		{
			try
			{
				return Json.parse(KoyaAssets.getText(levelJSONPath));
			}
			catch (e)
			{
				WindowUtil.alert('FAILED TO PARSE LEVEL JSON : $level', 'Cant parse JSON for level: $level\n\n${e.message}');
				trace(e.message);
			}
		}

		return DEFAULT_LEVEL_JSON;
	}
}
