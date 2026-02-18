package dirifin.play;

import dirifin.save.DirifinSave;

class Highscores
{
	public static function getHighscore(levelID:String)
	{
		if (!DirifinSave.instance.highscores.get().exists(levelID))
			setHighscore(levelID, 0);

		return DirifinSave.instance.highscores.get().get(levelID);
	}

	public static function setHighscore(levelID:String, score:Int = 0)
	{
		DirifinSave.instance.highscores.get().set(levelID, score);
	}
}
