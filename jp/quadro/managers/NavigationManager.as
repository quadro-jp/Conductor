package jp.quadro.managers
{
	import flash.errors.IllegalOperationError;
	import flash.events.EventDispatcher;
	import jp.quadro.collection.DataBinder;
	import jp.quadro.controller.AbstractController;
	import jp.quadro.events.SceneEvent;
	import jp.quadro.controller.NavigationType;
	import jp.quadro.ui.BasicController;
	
	public class NavigationManager extends EventDispatcher
	{
		private static var _instance:NavigationManager;
		private var _sceneManager:SceneManager;
		private var _binder:DataBinder;
		
		public function NavigationManager(enforcer:SingletonEnforcer)
		{
			if (enforcer == null) throw new IllegalOperationError("NavigationManagerはインスタンスか出来ません。");
			
			_sceneManager = SceneManager.getInstance();
			_sceneManager.addEventListener(SceneEvent.CHANGE, sceneChangeHandler);
			_binder = new DataBinder();
		}
		
		public static function getInstance():NavigationManager
		{
			if (NavigationManager._instance == null)NavigationManager._instance = new NavigationManager(new SingletonEnforcer());
			
			return NavigationManager._instance;
		}
		
		public function add(controller:BasicController):void
		{
			_binder.add(controller.key, { controller:controller, group:controller.group, key:controller.key, id:controller.id } );
			update(controller.group);
		}
		
		public function remove(key:String):void
		{
			_binder.remove(key);
		}
		
		public function update(group:String):void
		{
			var controller:BasicController;
			var keys:Array = _binder.getKeys();
			var n:uint = keys.length;
			
			for (var i:int = 0; i < n; i++)
			{
				controller = _binder.getDataByKey(keys[i]).controller as BasicController;
				
				if (controller.group == group)
				{
					if (group == NavigationType.GLOBAL_NAVIGATION) {
						controller.enable = controller.key == _sceneManager.terminus.root ? false : true;
					} else {
						controller.enable = controller.key == _sceneManager.terminus.fullPath ? false : true;
					}
				}
			}
		}
		
		public function getSelectedId(group:String):int
		{
			var controller:BasicController;
			var keys:Array = _binder.getKeys();
			var n:uint = keys.length;
			
			for (var i:int = 0; i < n; i++)
			{
				controller = _binder.getDataByKey(keys[i]).controller as BasicController;
				
				if (controller.group == group)
				{
					if (controller.key == _sceneManager.sceneData.root)
					{
						return controller.id;
					}
				}
			}
			
			return 0;
		}
		
		private function sceneChangeHandler(e:SceneEvent):void 
		{
			update(NavigationType.GLOBAL_NAVIGATION);
		}
	}
}