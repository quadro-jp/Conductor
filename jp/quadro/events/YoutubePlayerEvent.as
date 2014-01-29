package jp.quadro.events
{
	import flash.events.Event;

	/**
	 * イベントクラス
	 * @author aso
	 * @version 0.1
	 */
	public class YoutubePlayerEvent extends Event
	{
		public static const ENDED:String = 'ended';
		public static const PLAYING:String = 'playing';
		public static const BUFFER:String = 'buffer';
		public static const PAUSED:String = 'paused';
		public static const CUED:String = 'cued';
		
		/**
		 * コンストラクタ
		 * @param	type
		 * @param	bubbles
		 * @param	cancelable
		 * @return
		 */
		public function YoutubePlayerEvent( type:String, bubbles:Boolean = false, cancelable:Boolean = false ):void
		{
			super( type, bubbles, cancelable );
		}
		
		/**
			@return A string containing all the properties of the event.
		*/
		override public function toString():String
		{
			return formatToString('YoutubePlayerEvent', 'type', 'bubbles', 'cancelable');
		}
		
		/**
			@return Duplicates an instance of the event.
		*/
		override public function clone():Event
		{
			var e:YoutubePlayerEvent = new YoutubePlayerEvent(type, bubbles, cancelable);
			return e;
		}
	}
}
