package jp.quadro.media.video.events
{
	import flash.events.Event;

	/**
	 * イベントクラス
	 * @author aso
	 * @version 0.1
	 */
	public class FLVPlayerEvent extends Event
	{
		public static const PLAYING_STATE_ENTERED:String = "playingStateEntered";
		public static const COMPLETE:String = "complete";
		public static const CLOSE:String = "close";
		public static const DESTROYED:String = "destroyed";
		
		/**
		 * コンストラクタ
		 * @param	type
		 * @param	bubbles
		 * @param	cancelable
		 * @return
		 */
		public function FLVPlayerEvent( type:String, id:int = 0, bubbles:Boolean = false, cancelable:Boolean = false ):void
		{
			super( type, bubbles, cancelable );
		}
	}
}
