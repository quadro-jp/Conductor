package jp.quadro.loader 
{
	import com.greensock.easing.Quad;
	import com.greensock.TweenMax;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.LoaderInfo;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import jp.quadro.core.IConnectable;
	import jp.quadro.display.BasicContainer;
	import jp.quadro.display.ResizeAlign;
	import jp.quadro.display.ResizeScaleMode;
	
	/**
	 * ...
	 * @author aso
	 */
	public class BasicLoadingIndicator extends BasicContainer implements IConnectable
	{
		private var _progress:Number = 0;
		private var _percent:int = 0;
		private var _easing:Number = 0.1;
		private var _indicator:MovieClip
		private var _loaderInfo:LoaderInfo;
		private var _lockCenter:Boolean;
		
		public function BasicLoadingIndicator(container:DisplayObjectContainer, lockCenter:Boolean = true, x:Number = 0, y:Number = 0)
		{
			setPosition(x, y);
			_lockCenter = lockCenter;
			
			super(container, -1, 'LoadingIndicator_' + name);
		}
		
		public function connect(loaderInfo:LoaderInfo):void
		{
			onConnect();
			_loaderInfo = loaderInfo;
			_loaderInfo.addEventListener(IOErrorEvent.IO_ERROR, errorEventHandler);
			addEventListener(Event.ENTER_FRAME, enterFrameHandler);
		}
		
		override protected function onAddedToStage():void 
		{
			create();
			
			if (_lockCenter)
			{
				addEventListener(Event.RESIZE, resizeHandler);
				resizeHandler(null);
			}
		}
		
		override protected function onRemovedFromStage():void 
		{
			if (_loaderInfo)
			{
				_loaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, errorEventHandler);
				_loaderInfo = null;
			}
		}
		
		protected function onConnect():void 
		{
			TweenMax.from(this, 0.25, { alpha:0.0 } );
		}
		
		protected function onProgress():void 
		{
			if(_indicator) _indicator.scaleX = _percent / 100;
		}
		
		protected function onLoadComplete():void
		{
			trace('onLoadComplete');
			
			removeEventListener(Event.ENTER_FRAME, enterFrameHandler);
			
			TweenMax.to(this, 0.25, { alpha:0, delay: 0.25, ease:Quad.easeInOut, onComplete:function():void
			{
				dispatchEvent(new Event(Event.COMPLETE));
				destroy();
			} } );
		}
		
		protected function onIOError():void 
		{
			destroy();
		}
		
		protected function create():void 
		{
			_indicator = new MovieClip();
			_indicator.graphics.beginFill(0xFFFFFF);
			_indicator.graphics.drawRect( -stage.stageWidth / 2, 0, stage.stageWidth, 2);
			_indicator.graphics.endFill();
			_indicator.scaleX = 0;
			addChild(_indicator);
		}
		
		private function enterFrameHandler(e:Event):void
		{
			if (_loaderInfo)
			{
				_progress = 100 * _loaderInfo.bytesLoaded / _loaderInfo.bytesTotal;
				
				if (_percent < _progress) _percent += Math.ceil((_progress - _percent) * _easing) ;
				
				onProgress();
				
				if (_percent >= 100) {
					removeEventListener(Event.ENTER_FRAME, enterFrameHandler);
					onLoadComplete();
				}
			}
		}
		
		private function errorEventHandler(e:IOErrorEvent):void 
		{
			_loaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, errorEventHandler);
			onIOError();
		}
		
		private function resizeHandler(e:Event):void 
		{
			x = stage.stageWidth / 2;
			y = stage.stageHeight / 2;
		}
		
		
		public function get percent():int 
		{
			return _percent;
		}
		
		public function get easing():Number 
		{
			return _easing;
		}
		
		public function set easing(value:Number):void 
		{
			_easing = value;
		}
		
		public function get url():String { return _loaderInfo.url; }
		public function get content():DisplayObject { return _loaderInfo.content; }
	}
}