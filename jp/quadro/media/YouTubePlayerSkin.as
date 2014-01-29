package jp.quadro.media
{
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.display.StageDisplayState;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import jp.quadro.display.BasicContainer;
	import jp.quadro.ui.VolumeSlideController;
	import jp.quadro.events.SliderEvent;
	import jp.quadro.managers.SoundManager;
	import jp.quadro.events.SoundEvent;
	
	public class YouTubePlayerSkin extends BasicContainer
	{
		public static const PLAY_BUTTON:String = 'playButton';
		public static const MUTE_BUTTON:String = 'muteButton';
		public static const FULLSCREEN_BUTTON:String = 'fullscreenButton';
		
		public var remainTime:TextField;
		public var fullscreenButton:SimpleButton;
		public var muteButton:SimpleButton;
		public var playButton:SimpleButton;
		public var slider:MovieClip;
		public var seekBar:Sprite;
		public var bufferingBar:Sprite;
		public var volumeSlider:MovieClip;
		
		private var _apiPlayer:YouTubePlayer;
		private var _volumeController:VolumeSlideController;
		private var _slideRange:Number;
		private var _sliderDefualtPostion:Point;
		private var _isSliderPress:Boolean;
		
		override protected function onAddedToStage ():void
		{
			try { _apiPlayer = parent as YouTubePlayer; } 
			catch (err:Error) { throw new Error('YouTubePlayerSkinの追加は、YouTubePlayer.addSkin()を使用してください。'); }
			
			SoundManager.getInstance().addEventListener(SoundEvent.VOLUME_CHANGE, volumeChangeHandler);
			
			_volumeController = new VolumeSlideController(volumeSlider.knob, new Rectangle(7, 10, 0, 76));
			_volumeController.addEventListener(SliderEvent.SLIDE, SliderEventHandler);
			
			volumeSlider.visible = false;
			volumeSlider.addEventListener(MouseEvent.ROLL_OVER, rollOverHandler);
			volumeSlider.addEventListener(MouseEvent.ROLL_OUT, rollOutHandler);
			
			playButton.addEventListener(MouseEvent.CLICK, clickHandler);
			muteButton.addEventListener(MouseEvent.CLICK, clickHandler);
			muteButton.addEventListener(MouseEvent.MOUSE_OVER, mouseOverHandler);
			muteButton.addEventListener(MouseEvent.MOUSE_OUT, mouseOutHandler);
			fullscreenButton.addEventListener(MouseEvent.CLICK, clickHandler);
			
			seekBar.addEventListener(MouseEvent.CLICK, bufferingBarClickHandler);
			bufferingBar.addEventListener(MouseEvent.CLICK, bufferingBarClickHandler);
			
			slider.addEventListener(MouseEvent.MOUSE_DOWN, sliderPressHandler);
			slider.buttonMode = true;
			
			_slideRange = seekBar.width;
			_sliderDefualtPostion = new Point(slider.x, slider.y);
			
			seekBar.scaleX = 0.0;
			bufferingBar.scaleX = 0.0;
			
			stage.addEventListener(Event.FULLSCREEN, displayStateChangeHandler, false, 0, true);
			
			addEventListener(Event.ENTER_FRAME, enterFrameHandler);
		}
		
		override protected function onRemovedFromStage ():void
		{
			SoundManager.getInstance().removeEventListener(SoundEvent.VOLUME_CHANGE, volumeChangeHandler);
			_volumeController.removeEventListener(SliderEvent.SLIDE, SliderEventHandler);
			_volumeController.destroy();
			_volumeController = null;
			
			volumeSlider.removeEventListener(MouseEvent.ROLL_OVER, rollOverHandler);
			volumeSlider.removeEventListener(MouseEvent.ROLL_OUT, rollOutHandler);
			
			playButton.removeEventListener(MouseEvent.CLICK, clickHandler);
			muteButton.removeEventListener(MouseEvent.CLICK, clickHandler);
			muteButton.removeEventListener(MouseEvent.MOUSE_OVER, mouseOverHandler);
			muteButton.removeEventListener(MouseEvent.MOUSE_OUT, mouseOutHandler);
			fullscreenButton.removeEventListener(MouseEvent.CLICK, clickHandler);
			
			seekBar.removeEventListener(MouseEvent.CLICK, bufferingBarClickHandler);
			bufferingBar.removeEventListener(MouseEvent.CLICK, bufferingBarClickHandler);
			
			slider.removeEventListener(MouseEvent.MOUSE_DOWN, sliderPressHandler);
			
			removeEventListener(Event.ENTER_FRAME, enterFrameHandler);
		}
		
		
		private function volumeChangeHandler(e:SoundEvent):void 
		{
			if (e.value > 0) muteButton.alpha = 1.0;
		}
		
		private function SliderEventHandler(e:SliderEvent):void 
		{
			
		}
		
		private function displayStateChangeHandler(e:Event):void 
		{
			fullscreenButton.alpha = stage.displayState == StageDisplayState.FULL_SCREEN ? 0.0: 1.0;
		}
		
		private function enterFrameHandler(e:Event):void 
		{
			if(_apiPlayer.isReady && _apiPlayer.getPlayerState() > 0 && _apiPlayer.getPlayerState() < 5)
			{
				var videoBytesTotal:Number = _apiPlayer.getVideoBytesTotal();
				var videoStartBytes:Number = _apiPlayer.getVideoStartBytes();
				var videoBytesLoaded:Number = _apiPlayer.getVideoBytesLoaded();
				var currentTime:Number = _apiPlayer.getCurrentTime();
				var duration:Number = _apiPlayer.getDuration();
				var currentMinutes:Number = Math.floor(currentTime) % 60;
				var formatCurrentMinutes:String = currentMinutes < 10 ? "0" + currentMinutes : "" + currentMinutes;
				var totalMinutes:Number = Math.floor(duration) % 60;
				var formatTotalMinutes:String = totalMinutes < 10 ? "0" + totalMinutes : "" + totalMinutes;
				var remainTime:String = Math.floor(currentTime / 60) + ":" + formatCurrentMinutes + " / " + Math.floor(duration / 60) + ":" + formatTotalMinutes;
				var bufferingParcentage:Number = (videoStartBytes + videoBytesLoaded) / (videoStartBytes + videoBytesTotal);
				
				setRemainTime(remainTime);
				setSeekParcentage(currentTime / duration);
				setBufferingParcentage(bufferingParcentage);
				
				if (currentTime / duration == 1) playButton.alpha = 0.0;
			}
		}
		
		private function clickHandler(e:MouseEvent):void 
		{
			var button:SimpleButton = e.currentTarget as SimpleButton;
			
			switch (button.name) 
			{
				case YouTubePlayerSkin.PLAY_BUTTON :
					
					if (_apiPlayer.getPlayerState() == YouTubePlayer.STATE_PLAYING)
					{
						button.alpha = 0.0;
						_apiPlayer.pauseVideo();
					} else {
						button.alpha = 1.0;
						_apiPlayer.playVideo();
					}
				break;
				
				case YouTubePlayerSkin.MUTE_BUTTON :
					
					if (_apiPlayer.getSoundState() == YouTubePlayer.SOUND_MUTE)
					{
						button.alpha = 1.0;
						_apiPlayer.unMute();
					} else {
						button.alpha = 0.0;
						_apiPlayer.mute();
					}
					
					volumeSlider.visible = false;
					
				break;
				
				case YouTubePlayerSkin.FULLSCREEN_BUTTON :
					
					_apiPlayer.fullScreen();
					
				break;
			}
		}
		
		private function rollOverHandler(e:MouseEvent):void 
		{
			killAnimate(volumeSlider);
			animate(0.0, { autoAlpha:1.0 }, null, volumeSlider );
		}
		
		private function rollOutHandler(e:MouseEvent):void 
		{
			killAnimate(volumeSlider);
			animate(0.5, { autoAlpha:0.0, delay:0.0 }, null, volumeSlider );
		}
		
		private function mouseOverHandler(e:MouseEvent):void 
		{
			killAnimate(volumeSlider);
			animate(0.5, { autoAlpha:1.0 }, null, volumeSlider );
		}
		
		private function mouseOutHandler(e:MouseEvent):void 
		{
			animate(0.5, { autoAlpha:0.0, delay:2.0 }, null, volumeSlider );
		}
		
		private function sliderMoveHandler(e:MouseEvent):void 
		{
			if (!_isSliderPress) return;
			_apiPlayer.seekTo (Math.floor((mouseX - seekBar.x) / _slideRange * _apiPlayer.getDuration()));
		}
		
		private function sliderPressHandler(e:MouseEvent):void 
		{
			if (e.type == MouseEvent.MOUSE_DOWN)
			{
				_isSliderPress = true;
				slider.startDrag(false, new Rectangle(_sliderDefualtPostion.x, _sliderDefualtPostion.y, _slideRange, 0));
				slider.addEventListener(MouseEvent.MOUSE_UP, sliderPressHandler);
				stage.addEventListener(MouseEvent.MOUSE_MOVE, sliderMoveHandler);
				stage.addEventListener(MouseEvent.MOUSE_UP, sliderPressHandler);
			} else {
				_isSliderPress = false;
				slider.stopDrag();
				slider.removeEventListener(MouseEvent.MOUSE_UP, sliderPressHandler);
				stage.removeEventListener(MouseEvent.MOUSE_MOVE, sliderMoveHandler);
				stage.removeEventListener(MouseEvent.MOUSE_UP, sliderPressHandler);
			}
		}
		
		private function bufferingBarClickHandler(e:MouseEvent):void 
		{
			_apiPlayer.seekTo (Math.floor((mouseX - seekBar.x) / _slideRange * _apiPlayer.getDuration()));
		}
		
		public function setRemainTime(remain:String):void
		{
			remainTime.text = remain;
		}
		
		public function setSeekParcentage(percent:Number):void
		{
			seekBar.scaleX = percent;
			slider.x = seekBar.width + _sliderDefualtPostion.x;
		}
		
		public function setBufferingParcentage(percent:Number):void
		{
			bufferingBar.scaleX = percent;
		}
		
		public function setVolume(volume:Number):void
		{
			_apiPlayer.volume = volume;
		}
	}
}