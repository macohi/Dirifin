package dirifin;

import haxe.macro.Compiler;
import lime.app.Application;

class Version
{
	public static var VERSION(get, never):String;

	static function get_VERSION():String
	{
		var v = Application.current.meta.get('version');

		var PRE_RELEASE = Compiler.getDefine('PRE_RELEASE').split('=')[0];
		if (PRE_RELEASE != null)
			if (Std.parseInt(PRE_RELEASE) > 0)
				v += ' Pre-Release ${PRE_RELEASE}';

		return v;
	}
}
