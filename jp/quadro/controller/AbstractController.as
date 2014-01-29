package jp.quadro.controller
{
	import flash.display.DisplayObjectContainer;
	import flash.events.MouseEvent;
	import jp.quadro.display.AbstractSprite;
	import jp.quadro.managers.NotificationManager;
	import jp.quadro.notify.Intent;
	
	/**
	 * ...
	 * @author aso
	 */
	public class AbstractController extends AbstractSprite
	{
		private var _enable:Boolean;
		private var _notificationManager:NotificationManager;
		private var _type:String;
		private var _isMouseOver:Boolean;
		private var _isRollOver:Boolean;
		private var _isMouseDrag:Boolean;
		private var _isMouseDown:Boolean;
		
		public function AbstractController(container:DisplayObjectContainer = null, group:String = "", key:String = "", id:uint = 0)
		{
			super(container, -1, key, group);
		}
		
		public function notify(intent:Intent):void
		{
			_notificationManager.invoke(intent);
		}
		
		public function onClick():void { }
		public function onDoubleClick():void { }
		public function onMouseDown():void { }
		public function onMouseUp():void { }
		public function onMouseMove():void { }
		public function onMouseOver():void { }
		public function onMouseOut():void { }
		public function onRollOver():void { }
		public function onRollOut():void { }
		
		override protected function onAddedToStage():void
		{
			
		}
		
		override protected function onRemovedFromStage():void
		{
			
		}
		
		private function clickHandler(e:MouseEvent):void
		{
			onClick();
		}
		
		private function doubleClickHandler(e:MouseEvent):void
		{
			onDoubleClick();
		}
		
		private function mouseDownHandler(e:MouseEvent):void
		{
			_isMouseDown = true;
			onMouseDown();
		}
		
		private function mouseUpHandler(e:MouseEvent):void
		{
			_isMouseDown = false;
			onMouseUp();
		}
		
		private function mouseMoveHandler(e:MouseEvent):void
		{
			_isMouseOver = true;
			onMouseMove();
		}
		
		private function mouseOverHandler(e:MouseEvent):void
		{
			_isMouseOver = false;
			onMouseOver();
		}
		
		private function mouseOutHandler(e:MouseEvent):void
		{
			onMouseOut();
		}
		
		private function rollOverHandler(e:MouseEvent):void
		{
			_isRollOver = true;
			onRollOver();
		}
		
		private function rollOutHandler(e:MouseEvent):void
		{
			_isRollOver = false;
			onRollOut();
		}
		
		private function addMouseEvent():void
		{
			addEventListener (MouseEvent.CLICK, clickHandler, false, 0, false);
			addEventListener (MouseEvent.DOUBLE_CLICK, doubleClickHandler, false, 0, false);
			addEventListener (MouseEvent.MOUSE_DOWN, mouseDownHandler, false, 0, false);
			addEventListener (MouseEvent.MOUSE_UP, mouseUpHandler, false, 0, false);
			addEventListener (MouseEvent.MOUSE_MOVE, mouseMoveHandler, false, 0, false);
			addEventListener (MouseEvent.MOUSE_OVER, mouseOverHandler, false, 0, false);
			addEventListener (MouseEvent.MOUSE_OUT, mouseOutHandler, false, 0, false);
			addEventListener (MouseEvent.ROLL_OVER, rollOverHandler, false, 0, false);
			addEventListener (MouseEvent.ROLL_OUT, rollOutHandler, false, 0, false);
			mouseEnabled = mouseChildren = buttonMode = true;
			
			onEnable();
		}
		
		private function removeMouseEvent():void
		{
			removeEventListener (MouseEvent.CLICK, clickHandler);
			removeEventListener (MouseEvent.DOUBLE_CLICK, doubleClickHandler);
			removeEventListener (MouseEvent.MOUSE_DOWN, mouseDownHandler);
			removeEventListener (MouseEvent.MOUSE_UP, mouseUpHandler);
			removeEventListener (MouseEvent.MOUSE_MOVE, mouseMoveHandler);
			removeEventListener (MouseEvent.MOUSE_OVER, mouseOverHandler);
			removeEventListener (MouseEvent.MOUSE_OUT, mouseOutHandler);
			removeEventListener (MouseEvent.ROLL_OVER, rollOverHandler);
			removeEventListener (MouseEvent.ROLL_OUT, rollOutHandler);
			mouseEnabled = mouseChildren = buttonMode = false;
			
			onDisable();
		}
		
		protected function onEnable():void 
		{
			
		}
		
		protected function onDisable():void 
		{
			
		}
		
		public function get enable():Boolean
		{
			return _enable;
		}
		
		public function set enable(value:Boolean):void 
		{
			try 
			{
				if (_enable != value || value == false)
				{
					_enable = value;
					_enable ? addMouseEvent() : removeMouseEvent();
				}
			}catch (err:Error)
			{
				
			}
		}
		
		public function get type():String 
		{
			return _type;
		}
		
		public function set type(value:String):void 
		{
			_type = value;
		}
		
		public function get isMouseDrag():Boolean 
		{
			return _isMouseDrag;
		}
		
		public function get isMouseOver():Boolean 
		{
			return _isMouseOver;
		}
		
		public function get isRollOver():Boolean 
		{
			return _isRollOver;
		}
		
		public function get isMouseDown():Boolean 
		{
			return _isMouseDown;
		}
		
		public function get notificationManager():NotificationManager 
		{
			return _notificationManager;
		}
	}
}