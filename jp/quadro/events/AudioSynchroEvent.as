package jp.quadro.events
{
	import flash.events.Event;

	/**
	 * イベントクラス
	 * @author aso
	 * @version 0.1
	 */
	public class AudioSynchroEvent extends Event
	{
		public static const CHANGE_VOLUME:String = "change_volume";
		public static const MUTE:String = "mute";
		
		/**
		 * コンストラクタ
		 * @param	type
		 * @param	bubbles
		 * @param	cancelable
		 * @return
		 */
		public function AudioSynchroEvent( type:String, bubbles:Boolean = false, cancelable:Boolean = false ):void
		{
			super( type, bubbles, cancelable );
		}
	}
}
