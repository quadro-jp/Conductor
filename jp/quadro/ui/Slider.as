package jp.quadro.ui
{
	import flash.display.Sprite;
	import flash.events.EventDispatcher;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import jp.quadro.events.SliderEvent;
	import jp.quadro.events.UIEvent;
	
	public class Slider extends EventDispatcher
	{
		private var _knob:Sprite;
		private var _rectangle:Rectangle;
		private var _value:Number;
		
		public function Slider (knob:Sprite, rectangle:Rectangle) 
		{
			_knob = knob;
			_knob.addEventListener(MouseEvent.MOUSE_DOWN, mouseDownHnadler);
			_knob.buttonMode = true;
			_rectangle = rectangle;
		}
		
		public function destroy ():void
		{
			onDestroy();
			
			_knob.removeEventListener(MouseEvent.MOUSE_DOWN, mouseDownHnadler);
			_knob.removeEventListener(MouseEvent.MOUSE_UP, mouseUpHnadler);
			_knob.removeEventListener(MouseEvent.MOUSE_MOVE, mouseMoveHnadler);
			_knob.buttonMode = false;
			_knob = null;
		}
		
		public function onDestroy():void 
		{
			
		}
		
		private function mouseDownHnadler(e:MouseEvent):void 
		{
			_knob.stage.addEventListener(MouseEvent.MOUSE_UP, mouseUpHnadler);
			_knob.stage.addEventListener(MouseEvent.MOUSE_MOVE, mouseMoveHnadler);
		}
		
		private function mouseUpHnadler(e:MouseEvent):void 
		{
			_knob.stage.removeEventListener(MouseEvent.MOUSE_UP, mouseUpHnadler);
			_knob.stage.removeEventListener(MouseEvent.MOUSE_MOVE, mouseMoveHnadler);
		}
		
		private function mouseMoveHnadler(e:MouseEvent):void 
		{
			_knob.y = _knob.parent.mouseY;
			_knob.y = _rectangle.y + _rectangle.height > _knob.y ? _knob.y : _rectangle.y + _rectangle.height;
			_knob.y = _rectangle.y < _knob.y ? _knob.y : _rectangle.y;
			
			_value = (_rectangle.height + _rectangle.y - _knob.y) / _rectangle.height;
			
			dispatchEvent(new SliderEvent(SliderEvent.SLIDE, _value));
			
			onSlide();
		}
		
		protected function onSlide():void 
		{
			
		}
		
		public function get value():Number 
		{
			return _value;
		}
		
		public function set value(value:Number):void 
		{
			_value = value;
			_knob.y = _rectangle.height * (1 - value) + _rectangle.y;
		}
	}
}
