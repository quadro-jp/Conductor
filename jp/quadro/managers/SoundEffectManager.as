package jp.quadro.managers 
{
	import flash.errors.IllegalOperationError;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundTransform;
	import flash.net.URLRequest;
	
	/**
	 * ...
	 * @author aso
	 */
	public class SoundEffectManager extends EventDispatcher
	{
		private static var _instance:SoundEffectManager;
		
		public function SoundEffectManager(enforcer:SingletonEnforcer)
		{
			if (enforcer == null) throw new IllegalOperationError("SoundEffectManagerはインスタンスか出来ません。");
		}
		
		public static function getInstance():SoundEffectManager
		{
			if (SoundEffectManager._instance == null)
			{
				SoundEffectManager._instance = new SoundEffectManager(new SingletonEnforcer());
			}
			
			return SoundEffectManager._instance;
		}
		
		public function play(url:String):void
		{
			var sound:Sound;
			var soundTransform:SoundTransform;
			var soundChannel:SoundChannel;
			
			sound = new Sound(new URLRequest(url));
			soundTransform = new SoundTransform();
			soundTransform.volume = SoundManager.getInstance().volume/2;
			soundChannel = new SoundChannel();
			soundChannel = sound.play(0, 0, soundTransform);
			soundChannel.addEventListener (Event.SOUND_COMPLETE, playComplete);
			soundChannel.addEventListener (Event.OPEN, SoundOpenHandler);
			
			//trace("soundTransform.volume",soundTransform.volume, SoundManager.getInstance().volume);
		}
		
		private function SoundOpenHandler(e:Event):void 
		{
			dispatchEvent(new Event(Event.OPEN));
		}
		
		private function playComplete(e:Event):void 
		{
			dispatchEvent(new Event(Event.SOUND_COMPLETE));
		}
	}
}