package jp.quadro.events
{
	import flash.events.Event;

	/**
	 * イベントクラス
	 * @author aso
	 * @version 0.1
	 */
	public class SliderEvent extends Event
	{
		public static const SLIDE:String = "slide";
		
		private var _value:Number;
		
		/**
		 * コンストラクタ
		 * @param	type
		 * @param	bubbles
		 * @param	cancelable
		 * @return
		 */
		public function SliderEvent( type:String, value:Number, bubbles:Boolean = false, cancelable:Boolean = false ):void
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
			return formatToString('SliderEvent', 'type', 'value',  'bubbles', 'cancelable');
		}
		
		/**
			@return Duplicates an instance of the event.
		*/
		override public function clone():Event
		{
			var e:SliderEvent = new SliderEvent(type, value, bubbles, cancelable);
			return e;
		}
	}
}
