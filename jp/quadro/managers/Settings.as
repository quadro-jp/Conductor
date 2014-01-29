package jp.quadro.managers
{
	import flash.display.StageAlign;
	import flash.display.StageQuality;
	import flash.display.StageScaleMode;
	
	/**
	 * ...
	 * @author aso
	 */
	public class Settings extends Object 
	{
		private static var _file:String = 'website.xml';
		private static var _domain:String;
		private static var _lang:String = "jp";
		private static var _path:Object = { xml:'scene/', image:'images/'};
		private static var _width:Number;
		private static var _height:Number;
		private static var _autolock:Boolean = true;
		private static var _deeplink:Boolean = true;
		private static var _debug:Boolean = false;
		
		static public function get domain():String { return _domain; }
		static public function set domain(value:String):void { _domain = value; }
		static public function get lang():String { return _lang; }
		static public function set lang(value:String):void { _lang = value; }
		static public function get path():Object { return _path; }
		static public function get autolock():Boolean { return _autolock; }
		static public function set autolock(value:Boolean):void { _autolock = value; }
		static public function get deeplink():Boolean { return _deeplink; }
		static public function set deeplink(value:Boolean):void { _deeplink = value; }
		static public function get debug():Boolean { return _debug; }
		static public function set debug(value:Boolean):void { _debug = value; }
		static public function get width():Number { return _width; }
		static public function set width(value:Number):void { _width = value; }
		static public function get height():Number { return _height; }
		static public function set height(value:Number):void { _height = value; }
		static public function get file():String { return _file; }
		static public function set file(value:String):void { _file = value; }
	}
}