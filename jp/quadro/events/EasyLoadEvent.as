package jp.quadro.events
{
	import flash.display.DisplayObject;
	import flash.events.Event;

	/**
	 * イベントクラス
	 * @author aso
	 * @version 0.1
	 */
	public class EasyLoadEvent extends Event
	{
		public static const START:String = "start";
		public static const LOAD_COMPLETE:String = "complete";
		public static const TRANSITION_COMPLETE:String = "transition_complete";
		
		private var _content:DisplayObject;
		
		/**
		 * コンストラクタ
		 * @param	type
		 * @param	bubbles
		 * @param	cancelable
		 * @return
		 */
		public function EasyLoadEvent( type:String, ontent:DisplayObject = null, bubbles:Boolean = false, cancelable:Boolean = false ):void
		{
			super( type, bubbles, cancelable );
			_content = content;
		}
		
		public function get content():DisplayObject { return _content; }
	}
}
