package dirifin;

import flixel.FlxBasic;
import flixel.FlxG;
import flixel.util.FlxTimer;
import macohi.funkin.koya.backend.AssetPaths;

class MusicManager extends FlxBasic
{
	public static var tracks:Array<String> = ['dungeon drif'];

	public static function getRandomTrackPath():String
	{
		return getTrackPath(getRandomTrack());
	}

	public static function getRandomTrack():String
	{
		return tracks[FlxG.random.int(0, tracks.length - 1)];
	}

	public static function getTrackPath(track:String):String
	{
		return AssetPaths.music(track);
	}

	// 15% chance for it to play
	public static var MUSIC_FREQUENCY:Float = 15.0;

	public static var musicTimer:FlxTimer;

	override public function new()
	{
		super();

		musicTimer = new FlxTimer().start(0, function(mt)
		{
			if (!FlxG.sound.music?.playing || FlxG.sound.music == null)
			{
				if (FlxG.random.bool(MUSIC_FREQUENCY))
					FlxG.sound.playMusic(getRandomTrackPath(), 0.6);
				mt.time = FlxG.random.float(15, 60);
			}
			else
				mt.time += FlxG.random.float(30, 90);
		}, 0);
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);
	}
}
