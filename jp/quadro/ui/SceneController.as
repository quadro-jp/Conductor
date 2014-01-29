package jp.quadro.ui
{
	import flash.display.Sprite;
	import flash.events.EventDispatcher;
	import flash.events.MouseEvent;
	import jp.quadro.data.SceneId;
	import jp.quadro.managers.SceneManager;
	
	public class SceneController extends EventDispatcher
	{
		private var _button:Sprite;
		private var _sceneId:SceneId;
		
		public function SceneController (button:Sprite, sceneId:SceneId) 
		{
			_button = button;
			_button.addEventListener(MouseEvent.CLICK, clickHnadler);
			_button.buttonMode = true;
			_sceneId = sceneId;
		}
		
		private function clickHnadler(e:MouseEvent):void 
		{
			SceneManager.getInstance().gotoSceneByName(_sceneId);
		}
		
		public function destroy ():void
		{
			_button.removeEventListener(MouseEvent.CLICK, clickHnadler);
			_button.buttonMode = false;
			_button = null;
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
