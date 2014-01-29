package jp.quadro.managers
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.events.Event;
	import jp.quadro.core.ISceneData;
	import jp.quadro.data.SceneId;
	import jp.quadro.display.BasicContainer;
	import jp.quadro.managers.LogManager;
	import jp.quadro.managers.NavigationManager;
	import jp.quadro.managers.NotificationManager;
	import jp.quadro.managers.ResizeManager;
	import jp.quadro.managers.SceneManager;
	import jp.quadro.managers.SoundEffectManager;
	import jp.quadro.managers.SoundManager;
	import jp.quadro.managers.WindowManager;
	
	/**
	 * <p> 画面遷移の際のプロセスを管理します。 </p>
	 *
	 * @author aso
	 */
	public class NotifyContainer extends BasicContainer
	{
		private var _addResizeObjects:Array;
		private var _logManager:LogManager;
		private var _navigationManager:NavigationManager;
		private var _notificationManager:NotificationManager;
		private var _resizeManager:ResizeManager;
		private var _sceneManager:SceneManager;
		private var _soundEffectManager:SoundEffectManager;
		private var _soundManager:SoundManager;
		private var _windowManager:WindowManager;
		
		public function NotifyContainer(container:DisplayObjectContainer = null, index:int = 0, key:String = '')
		{
			super(container, index, key);
			
			if (className.indexOf("NotifyContainer") != -1) throw new Error(className + " is NotifyContainer Class.");
			
			_addResizeObjects = [];
			
			setReceiveEvent();
		}
		
		public function addResizeObject(target:DisplayObject, align:String, scale:String):void
		{
			var key:String;
			
			try {
				key = className + "::" + target.name;
			}
			catch (err:Error) { throw new Error(" [ WARNING ] target was not found."); }
			
			try {
				_addResizeObjects.push(key);
				resizeManager.add(key, target, align, scale);
			}
			catch (err:Error) { throw new Error(" [ WARNING ] _addResizeObjects was not founf. Is own destroyed ?"); }
		}
		
		public function removeResizeObject(key:String):void
		{
			resizeManager.remove(key);
		}
		
		
		
		/**
		 * <p> シーンを遷移します。 </p>
		 *
		 * @param
		 */
		public function gotoSceneByName(sceneId:SceneId):void
		{
			sceneManager.gotoSceneByName(sceneId);
		}		
		
		
		
		/**
		 * <p> 関連付けるイベントを設定します。 </p>
		 *
		 * @param
		 */
		protected function setReceiveEvent():void {}
		protected function removeReceiveEvent():void { }
		
		
		
		override protected function removedFromStageHandler(e:Event):void
		{
			var n:uint = _addResizeObjects.length;
				
			for (var i:int = 0; i < n; i++)
			{
				removeResizeObject(_addResizeObjects[i]);
			}
			
			removeReceiveEvent();
			
			super.removedFromStageHandler(e);
			
			_addResizeObjects = null;
			
			_logManager = null;
			_navigationManager = null;
			_notificationManager = null;
			_resizeManager = null;
			_sceneManager = null;
			_soundEffectManager = null;
			_soundManager = null;
			_windowManager = null;
		}
		
		/**
		 * <p> setter getter </p>
		 *
		 * @param
		 */
		protected function get logManager():LogManager
		{
			if (_logManager == null) _logManager = LogManager.getInstance();
			return _logManager;
		}		
		
		protected function get navigationManager():NavigationManager
		{
			if (_navigationManager == null) _navigationManager = NavigationManager.getInstance();
			return _navigationManager;
		}
		
		public function get notificationManager():NotificationManager 
		{
			if (_notificationManager == null) _notificationManager = NotificationManager.getInstance();
			return _notificationManager;
		}
		
		protected function get resizeManager():ResizeManager
		{
			if (_resizeManager == null) _resizeManager = ResizeManager.getInstance();
			return _resizeManager;
		}
		
		protected function get sceneManager():SceneManager
		{
			if (_sceneManager == null) _sceneManager = SceneManager.getInstance();
			return _sceneManager;
		}
		
		protected function get soundEffectManager():SoundEffectManager
		{
			if (_soundEffectManager == null) _soundEffectManager = SoundEffectManager.getInstance();
			return _soundEffectManager;
		}
		
		protected function get soundManager():SoundManager
		{
			if (_soundManager == null) _soundManager = SoundManager.getInstance();
			return _soundManager;
		}
		
		protected function get windowManager():WindowManager
		{
			if (_windowManager == null) _windowManager = WindowManager.getInstance();
			return _windowManager;
		}
		
		public function get currentScene():SceneId
		{
			return sceneManager.sceneData.sceneId;
		}
		
		public function get departureScene():SceneId
		{
			return sceneManager.departure;
		}
		
		public function get terminusScene():SceneId
		{
			return sceneManager.terminus;
		}
	}
}