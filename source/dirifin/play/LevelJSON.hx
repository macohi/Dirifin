package dirifin.play;

import macohi.typedefs.MinMaxTypedef;

typedef EnemySpawningData =
{
	dupe_direction_chance:Float,
	spawn_chance:MinMaxTypedef
}

typedef LevelJSON =
{
	enemySpawning:EnemySpawningData
}
