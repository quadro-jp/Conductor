package jp.quadro.events
{
	import flash.events.Event;
	import jp.quadro.core.ISceneData;
	import jp.quadro.data.SceneId;
	import jp.quadro.notify.Intent;

	/**
	 * イベントクラス
	 * @author aso
	 * @version 0.1
	 */
	public class NotifyEvent extends Event
	{
		public static const INVOKE:String = "notify_invoke";
		
		private var _intent:Intent;
		
		/**
		 * コンストラクタ
		 * @param	type
		 * @param	bubbles
		 * @param	cancelable
		 * @return
		 */
		public function NotifyEvent( type:String, intent:Intent, bubbles:Boolean = false, cancelable:Boolean = false ):void
		{
			super( type, bubbles, cancelable );
			
			_intent = intent;
		}
		
		public function get intent():Intent 
		{
			return _intent;
		}
		
		/**
			@return A string containing all the properties of the event.
		*/
		override public function toString():String
		{
			return formatToString('NotifyEvent', 'type', 'intent',  'bubbles', 'cancelable');
		}
		
		/**
			@return Duplicates an instance of the event.
		*/
		override public function clone():Event
		{
			var e:NotifyEvent = new NotifyEvent(type, intent, bubbles, cancelable);
			return e;
		}
	}
}
