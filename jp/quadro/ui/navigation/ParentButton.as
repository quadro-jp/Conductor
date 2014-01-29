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
	public class ParentButton extends SimpleButton
	{
		
		public function ParentButton() 
		{
			addEventListener(MouseEvent.CLICK, clickHandler);
		}
		
		private function clickHandler(e:MouseEvent):void 
		{
			var sceneManager:SceneManager = SceneManager.getInstance();
			sceneManager.gotoSceneByName(sceneManager.sceneData.parent.sceneId);
		}
	}
}