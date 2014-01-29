package jp.quadro.ui
{
	import flash.display.Sprite;
	import flash.geom.Rectangle;
	import jp.quadro.events.UIEvent;
	
	public class ScrollBar extends Slider
	{
		public function ScrollBar (knob:Sprite, rectangle:Rectangle) 
		{
			super(knob, rectangle);
		}
		
		override protected function onSlide():void 
		{
			dispatchEvent(new UIEvent(UIEvent.SCROLL, value));
		}
	}
}
