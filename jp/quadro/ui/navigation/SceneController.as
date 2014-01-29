package jp.quadro.ui.navigation 
{
	import flash.display.DisplayObjectContainer;
	
	import jp.quadro.controller.AbstractController;
	import jp.quadro.data.SceneId;
	import jp.quadro.managers.SceneManager;
	
	/**
	 * ...
	 * @author aso
	 */
	public class SceneController extends AbstractController
	{
		private var _sceneId:SceneId;
		
		public function SceneController(container:DisplayObjectContainer, sceneId:SceneId)
		{
			super(container);
			
			_sceneId = sceneId;
			
			enable = true;
		}
		
		override public function _onClick():void
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