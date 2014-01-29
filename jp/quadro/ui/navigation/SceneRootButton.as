package jp.quadro.ui.navigation 
{
	import flash.display.SimpleButton;
	import flash.events.MouseEvent;
	import jp.quadro.data.SceneId;
	import jp.quadro.managers.SceneManager;
	
	/**
	 * ...
	 * @author aso
	 */
	public class SceneRootButton extends SimpleButton
	{
		
		public function SceneRootButton() 
		{
			addEventListener(MouseEvent.CLICK, clickHandler);
		}
		
		private function clickHandler(e:MouseEvent):void 
		{
			var sceneId:SceneId = new SceneId(SceneManager.getInstance().sceneData.root);
			SceneManager.getInstance().gotoSceneByName(sceneId);
		}
	}
}