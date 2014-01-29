package jp.quadro.events
{
	import flash.events.Event;

	/**
	 * イベントクラス
	 * @author aso
	 * @version 0.1
	 */
	public class ProcessEvent extends Event
	{
		public static const PROCESS_WAIT:String = "process_wait";
		public static const PROCESS_INIT:String = "process_init";
		public static const PROCESS_START:String = "process_start";
		public static const PROCESS_COMPLETE:String = "process_complete";
		public static const UPDATE:String = "update";
		
		/**
		 * コンストラクタ
		 * @param	type
		 * @param	bubbles
		 * @param	cancelable
		 * @return
		 */
		public function ProcessEvent( type:String, bubbles:Boolean = false, cancelable:Boolean = false ):void
		{
			super( type, bubbles, cancelable );
		}
	}
}
