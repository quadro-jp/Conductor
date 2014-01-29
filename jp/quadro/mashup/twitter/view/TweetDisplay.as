package jp.quadro.mashup.twitter.view
{
	import flash.display.*;
	import flash.events.Event;
	
	public class TweetDisplay extends Sprite 
	{
		private var _displayObject:DisplayObject;
		private var _bottom:uint;
		
		/**
		* コンストラクタ
		* @param	displayObject 外観
		*/
		public function TweetDisplay(displayObject:DisplayObject):void
		{
			_displayObject = displayObject;
			addEventListener(Event.ADDED_TO_STAGE, added);
		}
		
		private function added(e:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, added);
			addChild(_displayObject);
		}
	}
}