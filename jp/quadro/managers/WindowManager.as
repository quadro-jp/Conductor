package jp.quadro.managers 
{
	import flash.errors.IllegalOperationError;
	import flash.events.EventDispatcher;
	import flash.utils.Dictionary;
	import jp.quadro.collection.DataBinder;
	import jp.quadro.core.IWindow;
	import jp.quadro.ui.WindowState;
	import jp.quadro.events.WindowEvent;
	
	/**
	 * ...
	 * @author aso
	 */
	public class WindowManager extends EventDispatcher
	{
		private static var _instance:WindowManager;
		private var _binder:DataBinder;
		
		public function WindowManager(enforcer:SingletonEnforcer)
		{
			if (enforcer == null) throw new IllegalOperationError("WindowManagerはインスタンスか出来ません。");
			_binder = new DataBinder();
		}
		
		public static function getInstance():WindowManager
		{
			if (WindowManager._instance == null) WindowManager._instance = new WindowManager(new SingletonEnforcer());
			
			return WindowManager._instance;
		}
		
		public function bind(key:String, window:Class):void
		{
			if (_binder.contains(key)) return;
			
			try { if (window) _binder.add(key, { classReference:window, key:key }); }
			catch (err:Error) { throw new Error("インスタンスの型が不正な為、WindowManagerに登録できませんでした。"); }
		}
		
		public function add(window:IWindow):void
		{
			var key:String = window.key;
			
			try { if (window) _binder.add(key, { window:window, key:key } ); }
			catch (err:Error) { throw new Error("インスタンスの型が不正な為、WindowManagerに登録できませんでした。"); }
		}
		
		public function open(key:String):void
		{
			if (_binder.contains(key))
			{
				var window:IWindow = getWindowByKey(key);
				window.open();
				dispatchEvent(new WindowEvent(window, WindowEvent.WINDOW_OPEN));
			}
		}
		
		public function close(key:String):void
		{
			if (_binder.contains(key))
			{
				var window:IWindow = getWindowByKey(key);
				window.close();
				dispatchEvent(new WindowEvent(window, WindowEvent.WINDOW_CLOSE));
			}
		}
		
		public function closeAll():void
		{
			var window:IWindow;
			var keys:Array = _binder.getKeys();
			var n:uint = keys.length;
			
			for (var i:int = 0; i < n; i++) 
			{
				window = getWindowByKey(keys[i]);
				window.close();
			}
		}
		
		public function toggle(key:String):void
		{
			getWindowState(key) == WindowState.WINDOW_OPEN ? close(key) : open(key);
		}
		
		public function contains(key:String):Boolean
		{
			return _binder.contains(key);
		}
		
		public function getWindowByKey(key:String):IWindow
		{
			if (_binder.contains(key))
			{
				var window:IWindow = _binder.getDataByKey(key).window as IWindow;
				return window;
			}else {
				return null;
			}
		}
		
		public function getWindowState(key:String):String
		{
			if (_binder.contains(key))
			{
				var window:IWindow = _binder.getDataByKey(key).window as IWindow;
				return window.state;
			}else {
				return null;
			}
		}
		
		public function remove(window:IWindow):void
		{
			var key:String = window.key;
			if (_binder.contains(key)) _binder.remove(key);
		}
		
		public function removeAll():void
		{
			var window:IWindow;
			var keys:Array = _binder.getKeys();
			var n:uint = keys.length;
			
			for (var i:int = 0; i < n; i++) 
			{
				_binder.remove(keys[i]);
			}
		}
	}
}