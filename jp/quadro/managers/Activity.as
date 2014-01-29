package jp.quadro.managers
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
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
	 * <p> ワークフロー構築の基礎となるブロックです。 </p>
	 * <p> 関連付けられたイベントに応じてアクションを実行します。 </p>
	 *
	 * @author aso
	 */
	public class Activity extends EventDispatcher
	{
		private var _receiver:BasicContainer;
		private var _key:String;
		
		private var _logManager:LogManager;
		private var _navigationManager:NavigationManager;
		private var _notificationManager:NotificationManager;
		private var _resizeManager:ResizeManager;
		private var _sceneManager:SceneManager;
		private var _soundEffectManager:SoundEffectManager;
		private var _soundManager:SoundManager;
		private var _windowManager:WindowManager;
		
		public function Activity(receiver:BasicContainer, key:String)
		{
			_receiver = receiver;
			_key = key;
			setReceiveEvent();
		}
		
		protected function acition(e:Event):void 
		{
			throw new Error('アクションが未定義です。');
		}
		
		/**
		 * <p> 関連付けるイベントを設定します。 </p>
		 *
		 * @param
		 */
		protected function setReceiveEvent():void
		{
			throw new Error('関連付けるイベントが未定義です。');
		}
		
		protected function removeReceiveEvent():void
		{
			throw new Error('関連付けるイベントが未定義です。');
		}
		
		
		
		public function destroy():void
		{
			removeReceiveEvent();
			
			_receiver = null;
			
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
		
		public function get terminusScene():SceneId
		{
			return sceneManager.terminus;
		}
		
		public function get receiver():BasicContainer 
		{
			return _receiver;
		}
		
		public function get key():String 
		{
			return _key;
		}
	}
}