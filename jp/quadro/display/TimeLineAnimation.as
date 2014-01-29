package jp.quadro.display 
{
	import com.greensock.easing.Linear;
	import com.greensock.TweenMax;
	import flash.display.DisplayObjectContainer;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import jp.quadro.events.AnimationEvent;
	import jp.quadro.managers.SceneManager;
	
	/**
	 * ...
	 * @author aso
	 */
	public class TimeLineAnimation extends AbstractMovieClip
	{
		private var _callBack:Function;
		private var _isAnimationStart:Boolean;
		private var _isAnimationSkip:Boolean;
		
		public function TimeLineAnimation(container:DisplayObjectContainer = null)
		{
			super(container);
			
			_isAnimationSkip = false;
			
			stop();
		}
		
		override protected function onRemovedFromStage():void 
		{
			if (SceneManager.getInstance().document) {
				SceneManager.getInstance().document.stage.removeEventListener(MouseEvent.CLICK, clickHandler);
			}
			
			_callBack = null;
		}
		
		public function start(callBack:Function = null, frame:int = 1):void 
		{
			if (_isAnimationStart) return;
			
			if (SceneManager.getInstance().document) {
				SceneManager.getInstance().document.stage.addEventListener(MouseEvent.CLICK, clickHandler);
			}
			
			_isAnimationStart = true;
			_callBack = callBack;
			gotoAndStop(frame);
			animate(Math.round((totalFrames - frame) / stage.frameRate * 10000) / 10000, { frame:totalFrames, ease:Linear.easeNone, onComplete:onComplete } );
			
			onAnimationStart();
		}
		
		public function skip():void 
		{
			if (SceneManager.getInstance().document) {
				SceneManager.getInstance().document.stage.removeEventListener(MouseEvent.CLICK, clickHandler);
			}
			
			killAnimate();
			gotoAndStop(totalFrames);
			
			if (_callBack != null) _callBack();
			
			_isAnimationStart = false;
			
			dispatchEvent(new AnimationEvent(AnimationEvent.SKIP));
			onAnimationSkip();
			onAnimationComplete();
		}
		
		protected function onAnimationStart():void 
		{
			
		}
		
		protected function onAnimationSkip():void 
		{
			
		}
		
		protected function onAnimationComplete():void 
		{
			
		}
		
		private function clickHandler(e:MouseEvent):void 
		{
			if (_isAnimationSkip) skip();
		}
		
		private function onComplete():void 
		{
			if (SceneManager.getInstance().document) {
				SceneManager.getInstance().document.stage.removeEventListener(MouseEvent.CLICK, clickHandler);
			}
			
			if (_callBack != null) _callBack();
			
			_isAnimationStart = false;
			
			dispatchEvent(new AnimationEvent(AnimationEvent.COMPLETE));
			onAnimationComplete();
		}
		
		public function get isAnimationSkip():Boolean 
		{
			return _isAnimationSkip;
		}
		
		public function set isAnimationSkip(value:Boolean):void 
		{
			_isAnimationSkip = value;
		}
		
		public function get isAnimationStart():Boolean 
		{
			return _isAnimationStart;
		}
	}
}