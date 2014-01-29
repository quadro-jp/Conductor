package jp.quadro.mashup.twitter.data
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
	/**
	 * 投稿データを保持するクラス（シングルトン）
	 * @author aso
	 * @version 0.1
	 */
	public class ContributeData implements IEventDispatcher
	{
		private static var _instance:ContributeData;
		private var _eventDispatcher:EventDispatcher;
		
		private var _contribute:String = "";
		private var _tweet:String = "";
		
		/**
		 * コンストラクタ
		 * @return
		 */
		public function ContributeData (enforcer:SingletonEnforcer)
		{
			_eventDispatcher = new EventDispatcher(this);
		}
		
		public static function getInstance():ContributeData
		{
			if (ContributeData._instance == null)
			{
				ContributeData._instance = new ContributeData(new SingletonEnforcer());
			}
			
			return ContributeData._instance;	
		}
		
		public function get contribute():String { return _contribute; }
		
		public function set contribute(value:String):void 
		{
			_contribute = value;
			dispatchEvent(new Event(Event.CHANGE));
		}
		
		public function get tweet():String { return _tweet; }
		
		public function set tweet(value:String):void 
		{
			_tweet = value;
			dispatchEvent(new Event("textChange"));
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