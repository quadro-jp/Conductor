package jp.quadro.ui
{
	import flash.display.Sprite;
	import flash.geom.Rectangle;
	import jp.quadro.managers.SoundManager;
	import jp.quadro.events.SoundEvent;
	
	public class VolumeSlideController extends Slider
	{
		public function VolumeSlideController (knob:Sprite, rectangle:Rectangle) 
		{
			super(knob, rectangle);
			SoundManager.getInstance().addEventListener(SoundEvent.VOLUME_CHANGE, volumeChangeHandler);
		}
		
		private function volumeChangeHandler(e:SoundEvent):void 
		{
			value = e.value;
		}
		
		override protected function onSlide():void 
		{
			SoundManager.getInstance().volume = value;
		}
		
		override public function onDestroy():void 
		{
			SoundManager.getInstance().removeEventListener(SoundEvent.VOLUME_CHANGE, volumeChangeHandler);
		}
	}
}
