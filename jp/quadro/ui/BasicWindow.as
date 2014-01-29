package jp.quadro.ui 
{
	import flash.display.DisplayObjectContainer;
	import flash.events.MouseEvent;
	import jp.quadro.core.IWindow;
	import jp.quadro.events.WindowEvent;
	import jp.quadro.managers.SceneManager;
	import jp.quadro.managers.WindowManager;
	import jp.quadro.events.ProcessEvent;
	
	/**
	 * ...
	 * @author aso
	 */
	public class BasicWindow extends BasicContainer implements IWindow 
	{
		private var _windowManager:WindowManager;
		private var _sceneManager:SceneManager;
		private var _drag:Boolean;
		protected var _state:String;
		
		public function BasicWindow(container:DisplayObjectContainer, key:String)
		{
			this.key = key;
			_state = WindowState.WINDOW_CLOSE;
			_drag = true;
			_windowManager = WindowManager.getInstance();
			_windowManager.add(this);
			_sceneManager = SceneManager.getInstance();
			_sceneManager.addEventListener(ProcessEvent.PROCESS_INIT, processEventHandler);
			super(container);
		}
		
		public function close():void 
		{
			if (_drag) {
				removeEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler);
				removeEventListener(MouseEvent.MOUSE_UP, mouseUpHandler);
			}
			_state = WindowState.WINDOW_CLOSE;
			onWindowClose();
		}
		
		public function open():void 
		{
			if (_drag) {
				addEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler);
				addEventListener(MouseEvent.MOUSE_UP, mouseUpHandler);
			}
			_state = WindowState.WINDOW_OPEN;
			onWindowOpen();
		}
		
		private function mouseDownHandler(e:MouseEvent):void 
		{
			parent.setChildIndex(this, parent.numChildren - 1);
			startDrag();
		}
		
		private function mouseUpHandler(e:MouseEvent):void 
		{
			stopDrag();
		}
		
		override public function destroy():void
		{
			animate(0.5, { alpha:0.0, onComplete:super.destroy } );
		}
		
		protected function onWindowClose():void { }
		protected function onWindowOpen():void { }
		
		override protected function onRemovedFromStage():void
		{
			if (_drag) {
				removeEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler);
				removeEventListener(MouseEvent.MOUSE_UP, mouseUpHandler);
			}
			
			if (_windowManager)
			{
				_windowManager.remove(this);
				_windowManager = null;
			}
		}
		
		private function processEventHandler(e:ProcessEvent):void 
		{
			_sceneManager.removeEventListener(ProcessEvent.PROCESS_INIT, processEventHandler);
			_sceneManager = null;
			_windowManager.remove(this);
			_windowManager = null;
		}
		
		public function get state():String { return _state; }
		
		public function get drag():Boolean 
		{
			return _drag;
		}
		
		public function set drag(value:Boolean):void 
		{
			_drag = value;
		}
		
		public function get windowManager():WindowManager 
		{
			return _windowManager;
		}
	}
}