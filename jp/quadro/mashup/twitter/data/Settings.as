package jp.quadro.mashup.twitter.data
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import jp.quadro.utils.MathUtil;
	
	/**
	 * 各種設定を保持するクラス（シングルトン）
	 * @author aso
	 * @version 0.1
	 */
	public class Settings implements IEventDispatcher
	{
		private static var _instance:Settings;
		private var _eventDispatcher:EventDispatcher;
		
		private const _OFFCIAL_SITE:String = "https://twitter.com/";
		private const _PHP_URL:String = "http://labs.quadro.jp/twitter/update.php";
		private const _CERTIFICATION_URL:String = "http://labs.quadro.jp/twitter/";
		private const _NAME_SPACE:Namespace = new Namespace("http://www.w3.org/2005/Atom");
		
		private var _screen_name:String = "_screen_name";
		private var _oauth_token:String = "_oauth_token";
		private var _oauth_secret:String = "_oauth_secret";
		private var _url:String = "http://labs.quadro.jp/twitter/";
		private var _word:String = "";
		private var _duration:uint = 5000;
		private var _lang:String = "ja";
		private var _retry:uint = 2;
		
		/**
		 * コンストラクタ
		 * @return
		 */
		public function Settings(enforcer:SingletonEnforcer)
		{
			_eventDispatcher = new EventDispatcher(this);
		}
		
		public static function getInstance():Settings
		{
			if (Settings._instance == null)
			{
				Settings._instance = new Settings(new SingletonEnforcer());
			}
			
			return Settings._instance;	
		}
		
		public function get PHP_URL():String { return _PHP_URL; }
		public function get NAME_SPACE():Namespace { return _NAME_SPACE; }
		public function get OFFCIAL_SITE():String { return _OFFCIAL_SITE; }
		public function get CERTIFICATION_URL():String { return _CERTIFICATION_URL; }
		
		public function get word():String { return _word; }
		public function set word(value:String):void { _word = value; }
		
		public function get url():String { return encodeURI(_url); }
		public function set url(value:String):void { _url = value; }
		
		public function get duration():uint { return _duration; }
		public function set duration(value:uint):void { _duration = value; }
		
		public function get oauth_token():String { return _oauth_token; }
		public function set oauth_token(value:String):void { _oauth_token = value; }
		
		public function get oauth_secret():String { return _oauth_secret; }
		public function set oauth_secret(value:String):void { _oauth_secret = value; }
		
		public function get screen_name():String { return _screen_name; }
		public function set screen_name(value:String):void { _screen_name = value; }
		
		public function get lang():String 
		{
			return _lang;
		}
		
		public function set lang(value:String):void 
		{
			_lang = value;
		}
		
		public function get retry():uint 
		{
			return _retry;
		}
		
		public function set retry(value:uint):void 
		{
			_retry = value;
		}
		
		
		
		
		public function addEventListener(type:String, listener:Function, useCapture:Boolean = false, priority:int = 0, weakRef:Boolean = false):void
		{
			_eventDispatcher.addEventListener(type, listener, useCapture, priority, weakRef);
		}
		
		public function dispatchEvent(event:Event):Boolean
		{
			return _eventDispatcher.dispatchEvent(event);
		}
		
		public function hasEventListener(type:String):Boolean
		{
			return _eventDispatcher.hasEventListener(type);
		}
		
		public function removeEventListener(type:String, listener:Function, useCapture:Boolean = false):void
		{
			_eventDispatcher.removeEventListener(type, listener, useCapture);
		}
		
		public function willTrigger(type:String):Boolean
		{
			return _eventDispatcher.willTrigger(type);
		}
	}
}

class SingletonEnforcer {}