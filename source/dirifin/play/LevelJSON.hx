package dirifin.play;

import haxe.Json;
import macohi.backend.JsonMergeAndAppend;
import macohi.funkin.koya.backend.AssetPaths;
import macohi.funkin.koya.backend.KoyaAssets;
import macohi.typedefs.MinMaxTypedef;
import macohi.util.WindowUtil;

using StringTools;

typedef EnemySpawningData =
{
	dupe_direction_chance:Float,
	spawn_chance:MinMaxTypedef,
}

typedef EnemyVariationData =
{
	?speed_multiplier:Float,
	?graphic:String,
}

typedef LevelJSONData =
{
	enemySpawning:EnemySpawningData,
	?enemyVariations:Array<EnemyVariationData>,
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
		var levelJSONPathMerge:Array<String> = AssetPaths.getAllModPaths(levelJSONPath.replace('assets', '_merge'));

		if (KoyaAssets.exists(levelJSONPath))
		{
			try
			{
				var baseJson:LevelJSONData = Json.parse(KoyaAssets.getText(levelJSONPath));

				for (path in levelJSONPathMerge)
				{
					var mergePath:String = path;

					if (KoyaAssets.exists(mergePath))
					{
						try
						{
							var mergeJson:LevelJSONData = Json.parse(KoyaAssets.getText(mergePath));

							baseJson = Json.parse(JsonMergeAndAppend.merge(
								Json.stringify(baseJson),
								Json.stringify(mergeJson),
								level // id does nothing with JSONS so yeah
							));
						}
						catch (e)
						{
							trace(e.message);
							WindowUtil.alert('Couldnt parse $mergePath', 'Cant parse Merge JSON for level: $level\n\n${e.message}');
						}
					}
				}

				return baseJson;
			}
			catch (e)
			{
				trace(e.message);
				WindowUtil.alert('FAILED TO PARSE LEVEL JSON : $level', 'Cant parse JSON for level: $level\n\n${e.message}');
			}
		}

		return DEFAULT_LEVEL_JSON;
	}
}
