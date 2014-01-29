package jp.quadro.events
{
	import flash.events.Event;

	/**
	 * イベントクラス
	 * @author aso
	 * @version 0.1
	 */
	public class AnimationEvent extends Event
	{
		public static const COMPLETE:String = "animation_complete";
		public static const SKIP:String = "animation_skip";
		
		/**
		 * コンストラクタ
		 * @param	type
		 * @param	bubbles
		 * @param	cancelable
		 * @return
		 */
		public function AnimationEvent( type:String, bubbles:Boolean = false, cancelable:Boolean = false ):void
		{
			super( type, bubbles, cancelable );
		}
	}
}
