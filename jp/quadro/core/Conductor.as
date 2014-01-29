package jp.quadro.core 
{
	import flash.display.DisplayObjectContainer;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import jp.quadro.config.StageConfig;
	import jp.quadro.data.SceneId;
	import jp.quadro.events.SceneEvent;
	import jp.quadro.managers.InstanceManager;
	import jp.quadro.managers.ResizeManager;
	import jp.quadro.managers.SceneContainer;
	import jp.quadro.managers.SceneManager;
	import jp.quadro.utils.DisplayUtil;
	
	/**
	 * ...
	 * @author quadro
	 */
	public class Conductor extends EventDispatcher
	{
		private var _instanceManager:InstanceManager;
		private var _sceneManager:SceneManager;
		private var _resizeManager:ResizeManager;
		private var _queue:Array;
		
		public function Conductor(document:Document) 
		{
			_instanceManager = InstanceManager.getInstance();
			_sceneManager = SceneManager.getInstance();
			_resizeManager = ResizeManager.getInstance();
			_sceneManager.document = document;
			_sceneManager.addEventListener(SceneManager.INIT, initializedHandler);
			_sceneManager.addEventListener(SceneEvent.CREATE, sceneCreateHandler);
		}
		
		public function destroy():void
		{
			_sceneManager = SceneManager.getInstance();
			_sceneManager.removeEventListener(SceneManager.INIT, initializedHandler);
			_sceneManager.removeEventListener(SceneEvent.CREATE, sceneCreateHandler);
		}
		
		public function setup():void { }
		
		
		
		/**
		 * <p> 設定ファイルを読み込みシーンを構築します。 </p>
		 *
		 * @param
		 */
		public function addSceneFromXML(url:String):void
		{
			trace('_sceneManager.numScenes');
			_sceneManager.numScenes > 0 ? initializedHandler() : _sceneManager.load(url);
		}
		
		protected function initializedHandler(e:Event = null):void
		{
			_sceneManager.removeEventListener(SceneManager.INIT, initializedHandler);
			
			onInitialized();
		}
		
		
		
		/**
		 * <p> シーンの階層構造の構築が完了した際に実行されます。 </p>
		 *
		 * @param
		 */
		protected function onInitialized():void { }
		
		
		
		/**
		 * <p> リサイズ処理を簡略化する為のメソッド。 </p>
		 *
		 * @param
		 */
		protected function setDefualtStageSize(stage:Stage, width:Number, height:Number):void
		{
			_resizeManager.setDefualtStageSize(stage, width, height);
		}
		
		
		
		/**
		 * <p> ステージの各設定をします。 </p>
		 *
		 * @param
		 */
		protected function setStageConfig(config:StageConfig):void
		{
			try {
				document.stage.align = config.align;
				document.stage.quality = config.quality;
				document.stage.scaleMode = config.scaleMode;
			}
			catch (err:Error){
				throw new Error("ステージを参照できませんでした。");
			}
		}
		
		
		
		/**
		 * <p> シーン生成するタイミングを通知します。 </p>
		 *
		 * @param
		 */
		private function sceneCreateHandler(e:SceneEvent):void 
		{
			create(e.sceneId);
		}
		
		
		/**
		 * <p> シーンが変更された際にシーンコンテナを生成します。 </p>
		 *
		 * @param
		 */
		private function create(sceneId:SceneId):void 
		{
			trace(sceneId.fullPath, '  生成済み？　',_sceneManager.contains(sceneId));
			
			if (_sceneManager.contains(sceneId))
			{
				dispatchEvent(new SceneEvent(SceneEvent.ENTER, sceneId));
				return;
			}
			
			if (_sceneManager.terminus.fullPath.indexOf(sceneId.fullPath) == -1)
			{
				trace('何チェック？');
				return;
			}
			
			var sceneData:ISceneData = _sceneManager.getSceneDataBySceneId(sceneId);
			var classReference:Class;
			var container:DisplayObjectContainer;
			var sceneContainer:SceneContainer;
			
			if (sceneData.className != '' && sceneData.type != 'same_scene')
			{
				try {
					classReference = DisplayUtil.getClassByName(sceneData.className);
					sceneContainer = new classReference();
					sceneContainer.addEventListener(SceneEvent.ENTER, sceneEnterHnadler);
					sceneContainer.addEventListener(SceneEvent.LEAVE, sceneLeaveHnadler);
					container = _instanceManager.getInstanceByKey(sceneData.container) as DisplayObjectContainer;
					container.addChildAt(sceneContainer, 0);
					trace('[ scene contents title ] ', sceneData.title);
					trace('[ scene generate className ] ', sceneData.className);
					trace('[ scene add container ] ', sceneData.container);
				}
				catch (err:Error) { trace('[create]', err); }
			} else {
				dispatchEvent(new SceneEvent(SceneEvent.ENTER, sceneId));
			}
		}
		
		private function sceneEnterHnadler(e:SceneEvent):void 
		{
			e.target.removeEventListener(SceneEvent.ENTER, sceneEnterHnadler);
			dispatchEvent(new SceneEvent(SceneEvent.ENTER, e.sceneId));
		}
		
		private function sceneLeaveHnadler(e:SceneEvent):void 
		{
			e.target.removeEventListener(SceneEvent.LEAVE, sceneLeaveHnadler);
		}
		
		
		
		/**
		 * <p> 各設定 </p>
		 *
		 * @param
		 */
		private static var _domain:String;
		private static var _lang:String = "jp";
		private static var _width:Number;
		private static var _height:Number;
		private static var _autolock:Boolean = true;
		private static var _deeplink:Boolean = true;
		private static var _debug:Boolean = false;
		
		public static function get domain():String { return _domain; }		
		public static function set domain(value:String):void { _domain = value; }		
		public static function get lang():String { return _lang; }		
		public static function set lang(value:String):void { _lang = value; }		
		public static function get autolock():Boolean { return _autolock; }		
		public static function set autolock(value:Boolean):void { _autolock = value; }		
		public static function get deeplink():Boolean { return _deeplink; }		
		public static function set deeplink(value:Boolean):void { _deeplink = value; }		
		public static function get debug():Boolean { return _debug; }		
		public static function set debug(value:Boolean):void { _debug = value; }		
		public static function get width():Number { return _width; }		
		public static function set width(value:Number):void { _width = value; }		
		public static function get height():Number { return _height; }		
		public static function set height(value:Number):void { _height = value; }		
		
		public function get document():Document 
		{
			return _sceneManager.document;
		}
		
		public function set document(value:Document):void 
		{
			_sceneManager.document = value;
		}
		
	}
}