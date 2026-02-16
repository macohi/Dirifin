package dirifin;

import haxe.macro.Compiler;
import lime.app.Application;

class Version
{
	public static var VERSION(get, never):String;

	static function get_VERSION():String
	{
		var v = Application.current.meta.get('version');

		if (Compiler.getDefine('PRE_RELEASE') != null)
			v += ' Pre-Release ${Compiler.getDefine('PRE_RELEASE')}';

		return v;
	}
}
