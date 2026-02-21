package dirifin.play;

import flixel.FlxG;
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
	?variation_chance:Float,

	?speed_multiplier:Float,
	?graphic:String,

	?present:String,
}

typedef LevelSettingsData =
{
	?difficulty:LevelDifficultyData,

	?camera_zoom:Float,
	?bg_scale_modifier:Array<Null<Float>>
}

typedef LevelDifficultyData =
{
	?regular:Int,
	?swd:Int,
}

typedef LevelJSONData =
{
	?enemy_spawning:EnemySpawningData,
	?enemy_variations:Array<EnemyVariationData>,
	?settings:LevelSettingsData,
}

class LevelJSONClass
{
	public static var DEFAULT_LEVEL_JSON:LevelJSONData = {
		enemy_spawning: {
			dupe_direction_chance: 10.0,
			spawn_chance: {
				max: 3.0,
				min: 0.0
			}
		}
	}

	public static function loadLevelJSON(level:String, ?parseEVP:Bool = true):LevelJSONData
	{
		var lvlJson:LevelJSONData = parseBaseJson(level) ?? DEFAULT_LEVEL_JSON;

		if (parseEVP)
			loadEnemyVariationPresents(lvlJson);

		return lvlJson;
	}

	public static function loadEnemyVariationPresents(baseJson:LevelJSONData)
	{
		if (baseJson.enemy_variations == null || baseJson.enemy_variations.length == 0) return;

		var newEnemyVariations:Array<EnemyVariationData> = [];

		for (i => variation in baseJson.enemy_variations)
		{
			if (variation == null || variation?.present == null)
				continue;

			var presentPath:String = AssetPaths.json('data/enemy_variation_presents/${variation.present}');
			var presentPathsAppend:Array<String> = AssetPaths.getAllModPaths(presentPath.replace('assets', '_append'));

			if (!KoyaAssets.exists(presentPath))
				continue;

			var presentJson:EnemyVariationData = null;

			try
			{
				presentJson = Json.parse(KoyaAssets.getText(presentPath));
			}
			catch (e)
			{
				presentJson = null;
				trace(e.message);
				WindowUtil.alert('Couldnt parse Enemy Variation Present', 'Cant parse Enemy Variation Present: $presentPath\n\n${e.message}');
			}

			if (presentJson == null)
				continue;

			for (path in presentPathsAppend)
			{
				if (!KoyaAssets.exists(path))
					continue;

				try
				{
					var mergePresentJson:EnemyVariationData = Json.parse(KoyaAssets.getText(path));

					presentJson = Json.parse(JsonMergeAndAppend.append(Json.stringify(presentJson), Json.stringify(mergePresentJson),
						variation.present // id does nothing with JSONS so yeah
					));
				}
				catch (e)
				{
					trace(e.message);
					WindowUtil.alert('Couldnt append mod enemy variation present',
						'Cant parse append JSON for enemy variation present: ${variation.present}\n\n${e.message}');
				}
			}

			presentJson = Json.parse(JsonMergeAndAppend.append(Json.stringify(presentJson), Json.stringify(variation),
				variation.present // id does nothing with JSONS so yeah
			));

			baseJson.enemy_variations.remove(variation);

			Reflect.deleteField(presentJson, 'present');
			newEnemyVariations.push(presentJson);
		}

		for (variation in newEnemyVariations)
			baseJson.enemy_variations.push(variation);
	}

	public static function parseBaseJson(level:String):LevelJSONData
	{
		var levelJSONPath:String = AssetPaths.json('data/levels/$level');

		if (!KoyaAssets.exists(levelJSONPath))
			return null;

		var levelJSONPathsAppend:Array<String> = AssetPaths.getAllModPaths(levelJSONPath.replace('assets', '_append'));

		try
		{
			var baseJson:LevelJSONData = Json.parse(KoyaAssets.getText(levelJSONPath));

			for (path in levelJSONPathsAppend)
			{
				if (!KoyaAssets.exists(path))
					continue;
				try
				{
					var mergeJson:LevelJSONData = Json.parse(KoyaAssets.getText(path));

					baseJson = Json.parse(JsonMergeAndAppend.append(Json.stringify(baseJson), Json.stringify(mergeJson),
						level // id does nothing with JSONS so yeah
					));
				}
				catch (e)
				{
					trace(e.message);
					WindowUtil.alert('Couldnt append mod level JSON', 'Cant parse Merge JSON for level: $level\n\n${e.message}');
				}
			}

			return baseJson;
		}
		catch (e)
		{
			trace(e.message);
			WindowUtil.alert('FAILED TO PARSE LEVEL JSON : $level', 'Cant parse JSON for level: $level\n\n${e.message}');
		}

		return null;
	}

	public static function getRandomEnemyVariation(data:Array<EnemyVariationData>):EnemyVariationData
	{
		if (data == null || data.length == 0)
			return null;

		var randomInt = FlxG.random.int(0, data.length - 1);
		for (i => variation in data)
		{
			if (FlxG.random.bool(variation?.variation_chance ?? ((randomInt == i) ? 100 : 0)))
				return variation;
		}

		return null;
	}
}
