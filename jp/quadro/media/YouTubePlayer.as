package jp.quadro.media
{
	import flash.display.DisplayObjectContainer;
	import flash.display.StageDisplayState;
	import flash.events.Event;
	import flash.geom.Rectangle;
	import flash.system.Security;
	import jp.quadro.display.BasicContainer;
	import jp.quadro.events.SoundEvent;
	import jp.quadro.events.YoutubePlayerEvent;
	import jp.quadro.managers.SoundManager;
	
	public class YouTubePlayer extends BasicContainer
	{
		private static const API_PLAYER_URL:String = 'http://www.youtube.com/apiplayer?version=3';
		private static const API_PLAYER_KEY:String = 'apiPlayer';
		public static const STATE_ENDED:Number = 0;
		public static const STATE_PLAYING:Number = 1;
		public static const STATE_BUFFER:Number = 3;
		public static const STATE_PAUSED:Number = 2;
		public static const STATE_CUED:Number = 5;
		public static const SOUND_MUTE:Number = 10;
		public static const SOUND_UNMUTE:Number = 11;
		
		private var _manager:SoundManager;
		private var _fullScreenSourceRect:Rectangle;
		private var _apiPlayer:Object;
		private var _isReady:Boolean;
		private var _isMute:Boolean;
		private var _url:String;
		private var _volume:Number;
		private var _skin:YouTubePlayerSkin;
		private var _screenWidth:Number;
		private var _screenHeight:Number;
		
		public function YouTubePlayer(container:DisplayObjectContainer, skin:YouTubePlayerSkin = null)
		{
			_skin = skin;
			_screenWidth = 640;
			_screenHeight = 360;
			super(container, -1, 'YouTubePlayer_' + name);
		}
		
		override protected function onAddedToStage():void
		{
			Security.allowDomain("*");
			_manager = SoundManager.getInstance();
			_manager.addEventListener(SoundEvent.VOLUME_CHANGE, volumeChangeHandler);
			_volume = _manager.volume * 100;
		}
		
		override protected function onEasyLoadComplete():void
		{
			if(!_apiPlayer) _apiPlayer = getResourceByKey(API_PLAYER_KEY) as Object;
			_apiPlayer.addEventListener("onReady", onReadyHandler);
			_apiPlayer.addEventListener("onError", onErrorHandler);
			_apiPlayer.addEventListener("onStateChange", onStateChangeHandler);
			_apiPlayer.addEventListener("onPlaybackQualityChange", onPlaybackQualityChangeHandler);
			
			if(_skin) addSkin(_skin);
		}
		
		public function addSkin(skin:YouTubePlayerSkin):void 
		{
			addChild(skin);
		}
		
		override protected function onRemovedFromStage():void
		{
			if(_apiPlayer)
			{
				_apiPlayer.removeEventListener("onReady", onReadyHandler);
				_apiPlayer.removeEventListener("onError", onErrorHandler);
				_apiPlayer.removeEventListener("onStateChange", onStateChangeHandler);
				_apiPlayer.removeEventListener("onPlaybackQualityChange", onPlaybackQualityChangeHandler);
				_apiPlayer.destroy();
				_apiPlayer = null;
			}
			
			_manager.videoStop();
			_manager.removeEventListener(SoundEvent.VOLUME_CHANGE, volumeChangeHandler);
			_manager = null;
		}
		
		private function onReadyHandler(e:Event):void
		{
			/**
			 * 再生に関するメソッドは、以下の4種類
			 * 1.指定するvideoIDの動画のサムネイルをロード。スタートボタンを中央に表示したまま停止。
			 * player.cueVideoById(videoId:String, startSeconds:Number, suggestedQuality:String):Void
			 * 2.指定するvideoURLの動画のサムネイルをロード。スタートボタンを中央に表示したまま停止。
			 * player.cueVideoByUrl(mediaContentUrl:String, startSeconds:Number):Void
			 * 3.指定するvideoIDの動画をロードして自動的に再生を開始する。
			 * player.loadVideoById(videoId:String, startSeconds:Number, suggestedQuality:String):Void
			 * 4.指定するvideoURLの動画をロードして自動的に再生を開始する。
			 * player.loadVideoByUrl(mediaContentUrl:String, startSeconds:Number):Void
			 */
			
			_isReady = true;
			_apiPlayer.setSize(_screenWidth, _screenHeight);
			_apiPlayer.setVolume(_volume);
			_apiPlayer.loadVideoByUrl(_url);
		}
		
		private function onErrorHandler(e:Event):void
		{
			/**
			 * エラーコード
			 * 100 要求した動画が見つからないとき
			 * 150,101 要求した動画が組み込みプレイヤーでの再生を許可していないとき
			 */
			//trace("Error", Object(e).data);
		}
		
		private function onStateChangeHandler(e:Event):void
		{
			/**
			 * -1 未スタート（SWFが最初にロードされたとき）
			 * 0 終了
			 * 1 再生中
			 * 2 一時停止
			 * 3 バッファリング
			 * 5 停止（SWFが読み込まれ，再生可能になったとき）
			 */
			
			if (!e) return;
			
			var state:Object = Object(e).data;
			
			switch(state)
			{
				case STATE_ENDED :
					dispatchEvent(new YoutubePlayerEvent(YoutubePlayerEvent.ENDED));
					_skin.setSeekParcentage(0);
					_skin.setBufferingParcentage(0);
					_apiPlayer.stopVideo();
				break;
					
				case STATE_PLAYING :
					dispatchEvent(new YoutubePlayerEvent(YoutubePlayerEvent.PLAYING));
					_manager.videoStart();
				break;
					
				case STATE_PAUSED :
					dispatchEvent(new YoutubePlayerEvent(YoutubePlayerEvent.PAUSED));
				break;
					
				case STATE_CUED :
					dispatchEvent(new YoutubePlayerEvent(YoutubePlayerEvent.CUED));
				break;
			}
		}
		
		private function onPlaybackQualityChangeHandler(e:Event):void
		{
			//trace("PlaybackQualityChange", Object(e).data);
		}
		
		private function volumeChangeHandler(e:SoundEvent):void 
		{
			volume = e.target.volume * 100;
		}
		
		public function loadVideoByUrl(url:String):void
		{
			_url = url;
			
			if (!_apiPlayer)
			{
				load(API_PLAYER_URL, { key:API_PLAYER_KEY } );
			}
			else
			{
				onEasyLoadComplete();
			}
		}
		
		public function playVideo():void
		{
			_apiPlayer.playVideo();
		}

		public function pauseVideo():void
		{
			_apiPlayer.pauseVideo();
		}
		
		public function stopVideo():void
		{
			_apiPlayer.stopVideo();
		}
		
		public function getPlayerState():int {
			return _apiPlayer.getPlayerState();
		}
		
		public function getVideoBytesTotal():Number 
		{
			return _apiPlayer.getVideoBytesTotal();
		}
		
		public function getVideoStartBytes():Number 
		{
			return _apiPlayer.getVideoStartBytes();
		}
		
		public function getVideoBytesLoaded():Number 
		{
			return _apiPlayer.getVideoBytesLoaded();
		}
		
		public function getCurrentTime():Number 
		{
			return _apiPlayer.getCurrentTime();
		}
		
		public function getDuration():Number 
		{
			return _apiPlayer.getDuration();
		}
		
		public function getSoundState():int 
		{
			return _isMute ? YouTubePlayer.SOUND_MUTE : YouTubePlayer.SOUND_UNMUTE;
		}
		
		public function mute():void
		{
			_isMute = true;
			_apiPlayer.mute();
		}
		
		public function unMute():void
		{
			_isMute = false;
			_apiPlayer.unMute();
		}
		
		public function seekTo(time:Number):void
		{
			_apiPlayer.seekTo(time, true);
		}
		
		public function fullScreen():void
		{
			stage.fullScreenSourceRect = _fullScreenSourceRect;
			
			switch(stage.displayState)
			{
				case StageDisplayState.NORMAL :
					stage.displayState = StageDisplayState.FULL_SCREEN;
				break;
				
				case StageDisplayState.FULL_SCREEN :
					stage.displayState = StageDisplayState.NORMAL;
				break;
			}
		}
		
		public function get volume():Number 
		{
			return _volume;
		}
		
		public function set volume(value:Number):void 
		{
			_volume = value;
			
			if(_apiPlayer) _apiPlayer.setVolume(value);
		}
		
		public function get screenWidth():Number 
		{
			return _screenWidth;
		}
		
		public function set screenWidth(value:Number):void 
		{
			_screenWidth = value;
		}
		
		public function get screenHeight():Number 
		{
			return _screenHeight;
		}
		
		public function set screenHeight(value:Number):void 
		{
			_screenHeight = value;
		}
		
		public function get isReady():Boolean 
		{
			return _isReady;
		}
		
		public function get fullScreenSourceRect():Rectangle 
		{
			return _fullScreenSourceRect;
		}
		
		public function set fullScreenSourceRect(value:Rectangle):void 
		{
			_fullScreenSourceRect = value;
		}
	}
}