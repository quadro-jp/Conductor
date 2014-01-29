package jp.quadro.mashup.twitter.events
{
	import jp.quadro.mashup.twitter.data.*;

	/**
	 * タイムライン読み込みイベントクラス
	 * @author aso
	 * @version 0.1
	 */
	public class TimeLineLoadEvent extends BasicDataIOEvent
	{
		public static const COMPLETE:String = "timeLineLoadComplete";
		
		/**
		 * コンストラクタ
		 * @param	type
		 * @param	bubbles
		 * @param	cancelable
		 * @return
		 */
		public function TimeLineLoadEvent( type:String, xml:XML, bubbles:Boolean = false, cancelable:Boolean = false ):void
		{
			super( type, bubbles, cancelable );
			_xml = xml;
		}
	}
}
