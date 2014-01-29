package jp.quadro.mashup.twitter.events
{
	
	import flash.events.Event;

	/**
	 * XML読み込み用エラーイベントクラス
	 * @author aso
	 * @version 0.1
	 */
	public class DataIOErrorEvent extends Event
	{
		// IOエラーイベント
		public static const IO_ERROR:String = "_ioError";
		
		// エラーコード
		protected var _errorCode:String;
		// エラーメッセージ
		protected var _MessageDisplay:String;
		// エラー内容
		protected var _errorContent:String;
		
		/**
		 * コンストラクタ
		 * @param	type
		 * @param	bubbles
		 * @param	cancelable
		 * @return
		 */
		public function DataIOErrorEvent( type:String, bubbles:Boolean = false, cancelable:Boolean = false ):void
		{
			super( type, bubbles, cancelable );
		}
		
		// エラーコード
		public function get errorCode():String
		{
			return _errorCode;
		}
		public function set errorCode( code:String ):void
		{
			_errorCode = code;
		}
		
		// エラーメッセージ
		public function get MessageDisplay():String
		{
			return _MessageDisplay;
		}
		
		public function set MessageDisplay( message:String ):void
		{
			_MessageDisplay = message;
		}
		
		// エラー内容
		public function get errorContent():String
		{
			return _errorContent;
		}
		
		public function set errorContent( content:String ):void
		{
			_errorContent = content;
		}
	}
}
