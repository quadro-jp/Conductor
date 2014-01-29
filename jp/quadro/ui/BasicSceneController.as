package jp.quadro.ui 
{
	import flash.display.DisplayObjectContainer;
	import jp.quadro.data.SceneId;
	import jp.quadro.managers.SceneManager;
	
	/**
	 * ...
	 * @author aso
	 */
	public class BasicSceneController extends BasicController
	{
		private var _sceneId:SceneId;
		
		public function BasicSceneController(container:DisplayObjectContainer = null, group:String = "", key:String = "", id:uint = 0)
		{
			super(container, group, key, id);
			enable = true;
		}
		
		override public function onClick():void
		{
			SceneManager.getInstance().gotoSceneByName(sceneId);
		}
		
		override protected function onDisable():void
		{
			alpha = 0.5;
		}
		
		override protected function onEnable():void
		{
			alpha = 1.0;
		}
		
		public function get sceneId():SceneId 
		{
			return _sceneId;
		}
		
		public function set sceneId(value:SceneId):void 
		{
			_sceneId = value;
		}
	}
}