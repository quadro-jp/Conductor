package jp.quadro.managers
{
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.utils.flash_proxy;
	import flash.utils.Proxy;
	import jp.quadro.collection.DataBinder;
	import jp.quadro.core.Document;
	
	dynamic public class InstanceManager extends Proxy implements IEventDispatcher
	{
		private static var _instance:InstanceManager;
		
		private var _eventDispatcher:EventDispatcher;
		private var _document:Document;
		private var _binder:DataBinder;
		private var _obj:*;
		
		/**
		 * <p> インスタンスを管理する為のクラスです。 </p>
		 * 
		 * @param　enforcer　
		 */
		public function InstanceManager(enforcer:SingletonEnforcer)
		{
			_eventDispatcher = new EventDispatcher(this);
			_binder = new DataBinder();
		}
		
		/**
		 * <p> インスタンスを取得するメソッドです。 </p>
		 * 
		 * @param
		 */
		public static function getInstance():InstanceManager
		{
			if (InstanceManager._instance == null) InstanceManager._instance = new InstanceManager(new SingletonEnforcer());
			
			return InstanceManager._instance;
		}
		
		
		
		public function add(key:String, instance:DisplayObject):void
		{
			_binder.add(key, instance);
		}
		
		public function remove(key:String):void
		{
			_binder.remove(key);
		}
		
		public function contains(key:String):Boolean
		{
			return _binder.contains(key);
		}
		
		public function getInstanceByKey(key:String):DisplayObject 
		{
			return _binder.getDataByKey(key) as DisplayObject;
		}
		
		public function getInstanceList():Array 
		{
			return _binder.getKeys();
		}
		
		public function get document():Document { return _document; }
		public function set document(value:Document):void { if (_document == null) _document = value; }
		
		
		
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
		
		/**
		 * <p> flash_proxy </p>
		 * 
		 * @param
		 */
		override flash_proxy function getProperty(name:*):* {
			var str:String = String(name);
			return str;
		}
		
		override flash_proxy function callProperty (name:*, ...rest) : * {
			return rest;
		}
		
		override flash_proxy function setProperty(name:*, value:*):void {
		  _obj[name] = value;
		}
		
		override flash_proxy function deleteProperty(name:*):Boolean {
		  return delete _obj[name];
		}
		
		override flash_proxy function hasProperty(name:*):Boolean {
		  return name in _obj;
		}
	}
}