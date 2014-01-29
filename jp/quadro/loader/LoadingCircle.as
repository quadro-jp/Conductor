package jp.quadro.loader
{
	import com.greensock.TweenMax;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	public class LoadingCircle extends BasicLoadingIndicator
	{
		private var _parts:Array;
		private var _timer:Timer;
		private var _count:Number;
		private var _size:uint;
		private var _color:Number;
		private var _radian:Number;
		private var _radius:Number;
		
		public function LoadingCircle(container:DisplayObjectContainer, lockCenter:Boolean = false, x:Number = 0, y:Number = 0)
		{
			super(container, lockCenter, x, y);
		}
		
		override protected function create():void 
		{
			_radian = Math.PI / 180;
			_radius = 12;
			_size = 12;
			_color = 0x555555;
			
			_parts = [];
			
			var n:Number = 12;
			
			for (var i:uint = 0; i <= n-1; i++)
			{
				var angle:Number = (360 / n) * i;
				var mc:Sprite = draw();
				mc.x = Math.sin(_radian * angle) * _radius;
				mc.y = Math.cos(_radian * angle) * _radius;
				mc.rotation = -angle;
				mc.alpha = .3;
				addChild(mc);
				_parts[i] = mc;
			}
		}
		
		override protected function onConnect():void 
		{
			TweenMax.to(this, 0.0, { scaleX:0, scaleY:0, alpha:0.0 } );
			TweenMax.to(this, 0.5, { scaleX:1, scaleY:1, alpha:1.0 } );
			start();
		}
		
		override protected function onProgress():void
		{
			
		}
		
		override protected function onLoadComplete():void
		{
			TweenMax.to(this, 0.25, { alpha:0, onComplete:function():void {
				dispatchEvent(new Event(Event.COMPLETE));
				destroy();
			} } );
		}
		
		override protected function onRemovedFromStage():void
		{
			_timer.stop();
			_timer.removeEventListener(TimerEvent.TIMER, timerEventHandler);
			_timer = null;
			
			for (var i:uint = 0; i <= _parts.length - 1; i++)
			{
				_parts[i].removeEventListener(Event.ENTER_FRAME, update);
			}
			
			_parts = null;
		}
		
		private function start():void 
		{
			_count = 0;
			_timer = new Timer(33, 0);
			_timer.addEventListener(TimerEvent.TIMER, timerEventHandler);
			_timer.start();
		}
		
		private function timerEventHandler(e:TimerEvent):void
		{
			_parts[_count].alpha = 1;
			_parts[_count].addEventListener(Event.ENTER_FRAME, update);
			_count--;
			if (_count < 0) _count = _parts.length - 1;
		}
		
		private function update(e:Event):void
		{
			e.currentTarget.alpha += (.3 - e.currentTarget.alpha) * .1;
		}
		
		private function draw():Sprite 
		{
			var mc:Sprite = new Sprite();
			mc.graphics.beginFill(_color);
			mc.graphics.drawRoundRect( -(_size / 4) / 2, -(_size / 1.5) / 2, _size / 4, _size, _size / 3);
			mc.graphics.endFill();
			return mc;
		}
	}
}