package jp.quadro.events
{
	import flash.events.Event;
	import jp.quadro.core.ISceneData;

	/**
	 * イベントクラス
	 * @author aso
	 * @version 0.1
	 */
	public class SoundEvent extends Event
	{
		public static const SOUND_COMPLETE:String = "sound_complete";
		public static const SOUND_MUTE:String = "sound_mute";
		public static const VOLUME_CHANGE:String = "volume_change";
		
		private var _value:Number;
		
		/**
		 * コンストラクタ
		 * @param	type
		 * @param	bubbles
		 * @param	cancelable
		 * @return
		 */
		public function SoundEvent( type:String, value:Number, bubbles:Boolean = false, cancelable:Boolean = false ):void
		{
			super( type, bubbles, cancelable );
			
			_value = value;
		}
		
		public function get value():Number 
		{
			return _value;
		}
		
		/**
			@return A string containing all the properties of the event.
		*/
		override public function toString():String
		{
			return formatToString('SoundEvent', 'type', 'value',  'bubbles', 'cancelable');
		}
		
		/**
			@return Duplicates an instance of the event.
		*/
		override public function clone():Event
		{
			var e:SoundEvent = new SoundEvent(type, value, bubbles, cancelable);
			return e;
		}
	}
}
