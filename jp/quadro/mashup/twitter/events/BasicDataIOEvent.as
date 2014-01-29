package jp.quadro.mashup.twitter.events
{
	import flash.events.Event;

	/**
	 * イベントクラス
	 * @author aso
	 * @version 0.1
	 */
	internal class BasicDataIOEvent extends Event
	{
		protected var _xml:XML;
		
		/**
		 * コンストラクタ
		 * @param	type
		 * @param	bubbles
		 * @param	cancelable
		 * @return
		 */
		public function BasicDataIOEvent( type:String, bubbles:Boolean = false, cancelable:Boolean = false ):void
		{
			super( type, bubbles, cancelable );
		}
		
		/**
		 * 読み込まれたXMLの取得
		 * @return
		 */
		public function get xml():XML
		{
			return _xml;
		}
		
		/**
		 * エラーコードの取得
		 * @return
		 */
		public function get errorCode():String
		{
			return _xml.error.code;
		}
	}
}
