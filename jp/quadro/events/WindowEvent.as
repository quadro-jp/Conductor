package jp.quadro.events
{
	import flash.events.Event;
	import jp.quadro.core.IWindow;

	/**
	 * イベントクラス
	 * @author aso
	 * @version 0.1
	 */
	public class WindowEvent extends Event
	{
		public static const CHANGE:String = "change";
		public static const WINDOW_CLOSE:String = "window_close";
		public static const WINDOW_OPEN:String = "window_open";
		public static const CLOSE_COMPLETE:String = "close_complete";
		public static const OPEN_COMPLETE:String = "open_complete";
		private static var _window:IWindow;
		/**
		 * コンストラクタ
		 * @param	type
		 * @param	bubbles
		 * @param	cancelable
		 * @return
		 */
		public function WindowEvent( window:IWindow, type:String, bubbles:Boolean = false, cancelable:Boolean = false ):void
		{
			_window = window;
			super( type, bubbles, cancelable );
		}
		
		static public function get window():IWindow 
		{
			return _window;
		}
	}
}
