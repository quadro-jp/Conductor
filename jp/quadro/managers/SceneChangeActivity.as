package jp.quadro.managers
{
	import jp.quadro.display.BasicContainer;
	import jp.quadro.events.SceneEvent;
	
	/**
	 * <p> ワークフロー構築の基礎となるブロックです。 </p>
	 * <p> 関連付けられたイベントに応じてアクションを実行します。 </p>
	 *
	 * @author aso
	 */
	public class SceneChangeActivity extends NotifyContainer
	{
		public function SceneChangeActivity(receiver:BasicContainer)
		{
			key = 'SceneChangeActivity_' + receiver.name;
		}
		
		public function acition():void 
		{
			
		}
		
		/**
		 * <p> _synchronizeがtrueの際に受け取るイベントを設定します。 </p>
		 *
		 * @param
		 */
		override protected function setReceiveEvent():void
		{
			sceneManager.addEventListener(SceneEvent.CHANGE, scnenChangeHandler);
		}
		
		override protected function removeReceiveEvent():void
		{
			sceneManager.removeEventListener(SceneEvent.CHANGE, scnenChangeHandler);
		}
		
		private function scnenChangeHandler(e:SceneEvent):void 
		{
			acition();
		}
	}
}