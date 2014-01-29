package jp.quadro.managers
{
	import flash.display.DisplayObjectContainer;
	import jp.quadro.events.SceneEvent;
	import jp.quadro.ui.BasicSceneController;
	
	/**
	 * <p> ナビゲーションを管理します。 </p>
	 *
	 * @author aso
	 */
	public class NavigationContainer extends NotifyContainer
	{
		private var _group:String;
		private var _synchronize:Boolean;
		
		/**
		 * <p> ナビゲーションコンテナに追加されたコントローラーは、シーンが更新される度にアップデートされます。 </p>
		 *
		 * @author aso
		 */
		public function NavigationContainer(group:String, synchronize:Boolean, container:DisplayObjectContainer = null)
		{
			_group = group;
			_synchronize = synchronize;
			
			super(container, -1, group);
		}
		
		/**
		 * <p> コンストラクタで指定したグループにコントローラーを登録します。 </p>
		 *
		 * @author aso
		 */
		public function addController(controller:BasicSceneController):void 
		{
			if(_synchronize) controller.group = _group;
			navigationManager.add(controller);
		}
		
		override protected function setReceiveEvent():void
		{
			sceneManager.addEventListener(SceneEvent.CHANGE, scnenChangeHandler);
		}
		
		override protected function removeReceiveEvent():void
		{
			sceneManager.removeEventListener(SceneEvent.CHANGE, scnenChangeHandler);
		}
		
		protected function onSceneChange():void { }
		
		private function scnenChangeHandler(e:SceneEvent):void 
		{
			if (!_synchronize) return;
			navigationManager.update(_group);
			onSceneChange();
		}
	}
}