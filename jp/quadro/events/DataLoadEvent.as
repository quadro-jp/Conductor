package jp.quadro.events
{
	import flash.events.Event;

	/**
	 * イベントクラス
	 * @author aso
	 * @version 0.1
	 */
	public class DataLoadEvent extends Event
	{
		public static const LOAD_COMPLETE:String = "complete";
		
		private var _key:String;
		
		/**
		 * コンストラクタ
		 * @param	type
		 * @param	bubbles
		 * @param	cancelable
		 * @return
		 */
		public function DataLoadEvent( type:String, key:String, bubbles:Boolean = false, cancelable:Boolean = false ):void
		{
			_key = key;
			super( type, bubbles, cancelable );
		}
		
		public function get key():String 
		{
			return _key;
		}
	}
}
