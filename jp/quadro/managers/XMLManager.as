package jp.quadro.managers
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.utils.Proxy;
	import jp.quadro.collection.DataBinder;
	import jp.quadro.events.DataLoadEvent;
	
	dynamic public class XMLManager extends Proxy implements IEventDispatcher
	{
		private static var _instance:XMLManager;
		private var _eventDispatcher:EventDispatcher;
		private var _binder:DataBinder;
		
		public function XMLManager(enforcer:SingletonEnforcer)
		{
			_eventDispatcher = new EventDispatcher(this);
			_binder = new DataBinder();
		}
		
		
		
		/**
		 * <p> XMLManagerのインスタンスを取得するメソッドです。 </p>
		 * 
		 * @param
		 */
		public static function getInstance():XMLManager
		{
			if (XMLManager._instance == null) XMLManager._instance = new XMLManager(new SingletonEnforcer());
			
			return XMLManager._instance;
		}
		
		
		
		/**
		 * <p> XMLを読み込んでシーン情報をパースします。 </p>
		 * 
		 * @param
		 */
		public function load(key:String, url:String):void
		{
			if (_binder.contains(key))
			{
				dispatchEvent(new DataLoadEvent(DataLoadEvent.LOAD_COMPLETE, key));
			}
			else
			{
				var urlLoader:URLLoader = new URLLoader();
				urlLoader.load(new URLRequest(url));
				urlLoader.addEventListener(Event.COMPLETE, onLoadCompleteHandler(key));
			}
		}
		
		
		
		/**
		 * <p> XMLを取得します。 </p>
		 * 
		 * @param
		 */
		public function getXML(key:String):XML
		{
			var xml:XML = _binder.getDataByKey(key) as XML;
			return xml;
		}
		
		
		
		private function onLoadCompleteHandler(key:String):Function
		{
			return function(e:Event):void
			{
				e.target.removeEventListener(Event.COMPLETE, arguments.callee);
				_binder.add(key, XML(e.target.data));
				dispatchEvent(new DataLoadEvent(DataLoadEvent.LOAD_COMPLETE, key));
			}
		}
		
		
		
		/**
		 * <p> EventListener </p>
		 * 
		 * @param
		 */
		public function addEventListener(type:String, listener:Function, useCapture:Boolean = false, priority:int = 0, weakRef:Boolean = false):void {
			_eventDispatcher.addEventListener(type, listener, useCapture, priority, weakRef);
		}
		
		public function dispatchEvent(event:Event):Boolean {
			return _eventDispatcher.dispatchEvent(event);
		}
		
		public function hasEventListener(type:String):Boolean {
			return _eventDispatcher.hasEventListener(type);
		}
		
		public function removeEventListener(type:String, listener:Function, useCapture:Boolean = false):void {
			_eventDispatcher.removeEventListener(type, listener, useCapture);
		}
		
		public function willTrigger(type:String):Boolean {
			return _eventDispatcher.willTrigger(type);
		}
	}
}