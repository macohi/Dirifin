package dirifin;

import haxe.macro.Compiler;
import lime.app.Application;

class Version
{
	public static var VERSION(get, never):String;

	static function get_VERSION():String
	{
		var v = Application.current.meta.get('version');

		var PRERELEASE:String = Compiler.getDefine('PRE_RELEASE')?.split('=')[0] ?? null;
		if (PRERELEASE != null)
			if (Std.parseInt(PRERELEASE) > 0)
				v += ' Pre-Release ${PRERELEASE}';

		return v;
	}
}
