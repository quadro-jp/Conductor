package jp.quadro.events
{
	import flash.events.IOErrorEvent;

	/**
	 * イベントクラス
	 * @author aso
	 * @version 0.1
	 */
	public class EasyLoadIOErrorEvent extends IOErrorEvent
	{
		public static const IO_ERROR:String = "ioError";
		
		/**
		 * コンストラクタ
		 * @param	type
		 * @param	bubbles
		 * @param	cancelable
		 * @return
		 */
		public function EasyLoadIOErrorEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false, text:String = "")
		{
			super( type, bubbles, cancelable, text );
		}
	}
}
