package jp.quadro.ui 
{
	import flash.display.SimpleButton;
	import flash.events.MouseEvent;
	import jp.quadro.data.SceneId;
	import jp.quadro.managers.SceneManager;
	
	/**
	 * ...
	 * @author aso
	 */
	public class RootButton extends SimpleButton
	{
		
		public function RootButton() 
		{
			addEventListener(MouseEvent.CLICK, clickHandler);
		}
		
		private function clickHandler(e:MouseEvent):void 
		{
			var sceneId:SceneId = SceneManager.getInstance().getRootSceneId();
			SceneManager.getInstance().gotoSceneByName(sceneId);
		}
	}
}