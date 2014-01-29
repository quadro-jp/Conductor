package jp.quadro.events
{
	import flash.events.ProgressEvent;

	/**
	 * イベントクラス
	 * @author aso
	 * @version 0.1
	 */
	public class EasyLoadProgressEvent extends ProgressEvent
	{
		public static const PROGRESS:String = "progress";
		
		private var _bytesLoaded:uint;
		private var _bytesTotal:uint;
		private var _percent:uint;
		
		/**
		 * コンストラクタ
		 * @param	type
		 * @param	bubbles
		 * @param	cancelable
		 * @return
		 */
		public function EasyLoadProgressEvent(type:String, bytesLoaded:uint = 0, bytesTotal:uint = 0, bubbles:Boolean = false, cancelable:Boolean = false)
		{
			super( type, bubbles, cancelable, bytesLoaded, bytesTotal );
			_percent = bytesLoaded / bytesTotal * 100;
		}
		
		//public function get bytesLoaded():uint { return _bytesLoaded; }
		
		//public function get bytesTotal():uint { return _bytesTotal; }
		
		public function get percent():uint { return _percent; }
	}
}
