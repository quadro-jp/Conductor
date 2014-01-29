package jp.quadro.managers 
{
	import com.greensock.TweenMax;
	import flash.errors.IllegalOperationError;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundTransform;
	import flash.net.URLRequest;
	import jp.quadro.events.SoundEvent;
	
	/**
	 * ...
	 * @author aso
	 */
	public class SoundManager extends EventDispatcher
	{
		private var _sound:Sound;
		private var _soundChannel:SoundChannel;
		private var _soundChannels:Array;
		private var _volume:Number = 1.0;
		private var _storeVolume:Number = 1.0;
		private var _url:String;
		private var _mute:Boolean;
		private var _isPlaying:Boolean;
		private var _isStreaming:Boolean;
		private var _isVideoPlaying:Boolean;
		private var _loop:Boolean;
		
		private static var _instance:SoundManager;
		
		public function SoundManager(enforcer:SingletonEnforcer)
		{
			if (enforcer == null) throw new IllegalOperationError("SoundManagerはインスタンスか出来ません。");
		}
		
		public static function getInstance():SoundManager
		{
			if (SoundManager._instance == null)
			{
				SoundManager._instance = new SoundManager(new SingletonEnforcer());
				SoundManager._instance._soundChannels = [];
				SoundManager._instance._soundChannel =  new SoundChannel();
			}
			
			return SoundManager._instance;
		}
		
		public function play(url:String, loop:Boolean = false):void
		{
			if (_mute) return;
			
			if (_isPlaying)
			{
				if (_url == url) return;
				
				_url = url;
				
				TweenMax.to(_soundChannel, 1.0, { volume:0.0, onComplete:function():void
				{
					_isPlaying = false;
					stop();
					play(url, loop);
				} } );
			}
			else
			{
				_isPlaying = true;
				_loop = loop;
				_url = url;
				
				var urlRequest:URLRequest = new URLRequest(url);
				_sound = new Sound(urlRequest);
				_sound.addEventListener(IOErrorEvent.IO_ERROR, IOErrorEventHandler);
				
				var _soundTransform:SoundTransform = new SoundTransform();
				_soundTransform.volume = _storeVolume;
				
				_soundChannel =  new SoundChannel();
				_soundChannels.push(_soundChannel);
				_soundChannel = _sound.play(0, 1, _soundTransform);
				_soundChannel.addEventListener (Event.SOUND_COMPLETE, playComplete);
			}
		}
		
		public function replay():void
		{
			if (!_isVideoPlaying && !_isPlaying && _url != null)
			{
				play(_url, _loop);
			}
		}
		
		private function IOErrorEventHandler(e:IOErrorEvent):void 
		{
			throw new Error("ファイルがありません。");
		}
		
		public function stop():void 
		{
			_soundChannel.removeEventListener (Event.SOUND_COMPLETE, playComplete);
			
			if (_soundChannel)
			{
				_isPlaying = false;
				_soundChannel.stop();
			}
			
			if (_isStreaming)
			{
				_isStreaming = false;
				_sound.close();
			}
		}
		
		private function SoundOpenHandler(e:Event):void 
		{
			_isStreaming = true;
		}
		
		private function playComplete(e:Event):void 
		{
			_soundChannel.removeEventListener (Event.SOUND_COMPLETE, playComplete);
			
			if (_soundChannel)
			{
				_isPlaying = false;
				_soundChannel.stop();
			}
			
			if (_isStreaming)
			{
				_isStreaming = false;
				_sound.close();
			}
			
			if (_loop) replay();
			
			dispatchEvent(new SoundEvent(SoundEvent.SOUND_COMPLETE, _volume));
		}
		
		public function fade():void
		{
			TweenMax.to(_soundChannel, 1.0, { volume:0.0, onComplete:function():void { stop(); }});
		}
		
		public function videoStart():void
		{
			_isVideoPlaying = true;
			
			TweenMax.to(_soundChannel, 1.0, { volume:0.0, onComplete:function():void
			{
				stop();
			}});
		}
		
		public function videoStop():void
		{
			_isVideoPlaying = false;
			if(!_mute) replay();
		}
		
		public function get volume():Number { return _volume; }
		
		public function set volume(value:Number):void 
		{
			_storeVolume = _volume = value;
			
			if (_soundChannel)
			{
				TweenMax.to(_soundChannel, 0, { volume:_volume } );
				dispatchEvent(new SoundEvent(SoundEvent.VOLUME_CHANGE, _volume));
			}
		}
		
		public function get soundChannel():SoundChannel { return _soundChannel; }
		
		public function get isStreaming():Boolean { return _isStreaming; }
		
		public function get isPlaying():Boolean { return _isPlaying; }
		
		public function get mute():Boolean { return _mute; }
		
		public function set mute(value:Boolean):void 
		{
			if (value == _mute) return;
			
			_isPlaying = false;
			
			if(_soundChannel) TweenMax.to(_soundChannel, 1.0, { volume:_storeVolume } );
			
			_mute = value;
			_mute ? stop() : replay();
			
			dispatchEvent(new SoundEvent(SoundEvent.SOUND_MUTE, _volume));
		}
		
		public function get isVideoPlaying():Boolean { return _isVideoPlaying; }
	}
}