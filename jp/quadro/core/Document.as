package jp.quadro.core
{
	import flash.display.StageDisplayState;
	import flash.events.Event;
	import flash.system.Security;
	import jp.quadro.core.ISceneData;
	import jp.quadro.data.NullSceneData;
	import jp.quadro.data.SceneId;
	import jp.quadro.events.ProcessEvent;
	import jp.quadro.events.SceneEvent;
	import jp.quadro.managers.NotifyContainer;
	import jp.quadro.managers.ProcessCommand;
	import jp.quadro.managers.SceneManager;
	import jp.quadro.managers.Settings;

	
	/**
	 * <p> 画面遷移の際のプロセスを管理します。 </p>
	 *
	 * @author aso
	 */
	public class Document extends NotifyContainer
	{
		public static const INTERNAL_ROOT_ID:String = "internalRootId";
		private var _sceneData:ISceneData = new NullSceneData;
		private var _conductor:Conductor;
		
		public function Document(conductor:Conductor)
		{
			setReceiveEvent();
			
			_conductor = conductor;
			
			super(null, 0, INTERNAL_ROOT_ID);
		}
		
		public function initialize():void
		{
			if (_conductor) {
				_conductor.setup();
			}else {
				throw new Error ('Conductorが未定義です。');
			}
		}
		
		protected function initializedHandler(e:Event):void
		{
			sceneManager.removeEventListener(SceneManager.INIT, initializedHandler);
			
			onInitialized();
		}
		
		protected function onInitialized():void { }
		
		protected function onProcessWait():void
		{
			var command:ProcessCommand = new ProcessCommand();
			//command.pushCommand(trace, ["[ " + sceneManager.process + " ]---> ■ 待機状態です。"]);
			command.execute();
		}
		
		protected function onProcessInit():void 
		{
			var command:ProcessCommand = new ProcessCommand();
			command.pushWait(0);
			//command.pushCommand(trace, ["[ " + sceneManager.process + " ]---> ■ 秒後に画面遷移を実行します。"]);
			command.execute();
		}
		
		protected function onProcessStart():void 
		{
			var command:ProcessCommand = new ProcessCommand();
			command.pushWait(0);
			//command.pushCommand(trace, ["[ " + sceneManager.process + " ]---> ■ 画面遷移を実行中です。"]);
			command.execute();
		}
		
		protected function onProcessComplete():void 
		{
			var command:ProcessCommand = new ProcessCommand();
			command.pushWait(0);
			//command.pushCommand(trace, ["     [ " + sceneManager.process + " ]---> ■ 画面遷移が完了しました。"]);
			command.execute();
		}
		
		protected function onSceneChange():void { }
		protected function onSceneArrival():void { }
		
		override protected function setReceiveEvent():void
		{
			sceneManager.addEventListener(ProcessEvent.PROCESS_WAIT, processEventHandler);
			sceneManager.addEventListener(ProcessEvent.PROCESS_INIT, processEventHandler);
			sceneManager.addEventListener(ProcessEvent.PROCESS_START, processEventHandler);
			sceneManager.addEventListener(ProcessEvent.PROCESS_COMPLETE, processEventHandler);
			sceneManager.addEventListener(SceneEvent.CHANGE, sceneChangeHandler);
			sceneManager.addEventListener(SceneEvent.ARRIVAL, sceneArrivalHandler);
			sceneManager.addEventListener(SceneManager.INIT, initializedHandler);
		}
		
		override protected function removeReceiveEvent():void
		{
			sceneManager.removeEventListener(ProcessEvent.PROCESS_WAIT, processEventHandler);
			sceneManager.removeEventListener(ProcessEvent.PROCESS_INIT, processEventHandler);
			sceneManager.removeEventListener(ProcessEvent.PROCESS_START, processEventHandler);
			sceneManager.removeEventListener(ProcessEvent.PROCESS_COMPLETE, processEventHandler);
			sceneManager.removeEventListener(SceneEvent.CHANGE, sceneChangeHandler);
			sceneManager.removeEventListener(SceneEvent.ARRIVAL, sceneArrivalHandler);
			sceneManager.removeEventListener(SceneManager.INIT, initializedHandler);
		}
		
		
		
		/**
		 * <p> スクリーンモードを切り替えます。 </p>
		 *
		 * @param
		 */
		public function fullScreen():void
		{
			stage.displayState = stage.displayState == StageDisplayState.FULL_SCREEN ? StageDisplayState.NORMAL : StageDisplayState.FULL_SCREEN;
		}
		
		
		
		/**
		 * <p> SceneManager.processの値が更新後、ProcessEventが配信されます。 </p>
		 * <p> 画面遷移を詳細に制御する場合は、SceneTransitionを実行してください。 </p>
		 *
		 * @param
		 */
		private function processEventHandler(e:ProcessEvent):void
		{
			switch (e.type)
			{
				case ProcessEvent.PROCESS_WAIT:
					
					onProcessWait();
					
				break;
				
				case ProcessEvent.PROCESS_INIT:
					
					if (Settings.autolock) mouseChildren = mouseEnabled = false;
					
					onProcessInit();
					
				break;
				
				
				case ProcessEvent.PROCESS_START:
					
					onProcessStart();
					
				break;
				
				case ProcessEvent.PROCESS_COMPLETE:
					
					if (Settings.autolock) mouseChildren = mouseEnabled = true;
					
					onProcessComplete();
					
				break;
			}
		}
		
		private function sceneChangeHandler(e:SceneEvent):void { onSceneChange(); }
		
		private function sceneArrivalHandler(e:SceneEvent):void { onSceneArrival(); }
		
		
		
		public function get sceneData():ISceneData { return _sceneData; }
		
		protected function get domain():String
		{
			if (!Settings.domain)
			{
				var url:String = loaderInfo.loaderURL;
				Settings.domain = url.substring(0, url.lastIndexOf("/") + 1);
				Security.allowDomain(Settings.domain);
				Security.allowInsecureDomain(Settings.domain);
			}
			
			return Settings.domain;
		}
		
		public function get conductor():Conductor 
		{
			return _conductor;
		}
	}
}