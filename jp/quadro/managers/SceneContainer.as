package jp.quadro.managers
{
	import flash.display.BlendMode;
	import flash.display.DisplayObjectContainer;
	import flash.events.Event;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import jp.quadro.commands.SerialCommand;
	import jp.quadro.core.Document;
	import jp.quadro.core.ISceneData;
	import jp.quadro.data.SceneId;
	import jp.quadro.events.EasyLoadEvent;
	import jp.quadro.events.SceneEvent;
	import jp.quadro.loader.LoadingIndicator;
	import jp.quadro.utils.DisplayUtil;
	
	/**
	 * <p> シーン遷移時にサイトに生成されるコンテナ。 </p>
	 *
	 * @author aso
	 */
	public class SceneContainer extends NotifyContainer
	{
		private const NO_REQUEST:String = 'no_request';
		private var _sceneId:SceneId;
		private var _uid:String;
		private var _type:String;
		private var _sceneXML:XML;
		private var _sceneData:ISceneData;
		private var _sceneEenterAction:SerialCommand;
		private var _sceneLeaveAction:SerialCommand;
		
		private var _assetsXML:String;
		private var _assetsSWF:String;
		private var _requestLoadAssets:Number;
		
		private var _isSceneAscend:Boolean;
		private var _isSceneDescend:Boolean;
		private var _isDestroyScene:Boolean;
		private var _useLoadAssetsOption:Boolean;
		private var _loadAssetsOption:Object;
		private var _document:Document;
		
		
		
		/**
		 * <p> シーン遷移時にサイトに生成されるコンテナ。 </p>
		 * <p> シーン生成時にXMLを読み込む場合は assetsXML でURLを指定してください。 </p>
		 * <p> シーン生成時にSWFを読み込む場合は assetsSWF でURLを指定してください。 </p>
		 * <p> assetsが指定されている場合、SceneEvent.ENTER の配信が遅延されます。 </p>
		 *
		 * @param
		 */
		public function SceneContainer(sceneId:SceneId, type:String, container:DisplayObjectContainer = null, index:uint = 0, key:String = '')
		{
			_sceneData = sceneManager.sceneData;
			_sceneId = sceneId;
			_type = type;
			_requestLoadAssets = 0;
			_useLoadAssetsOption = true;
			_assetsXML = _assetsSWF = NO_REQUEST;
			_uid = 'SceneContainer_' + sceneId.fullPath;
			
			super(container, index, _uid);
		}
		
		
		
		/**
		 * <p> XMLを読み込みシーンを初期化します。初期化が完了するとonSceneInitializeが </p>
		 * <p> 呼び出されます。 </p>
		 * <p> 読み込み完了までSceneEvent.ENTERの配信が遅延されます。 </p>
		 *
		 * @param
		 */
		private function loadSceneXML():void 
		{
			if (_assetsXML == NO_REQUEST) return;
			
			_requestLoadAssets++;
			
			var urlLoader:URLLoader = new URLLoader();
			urlLoader.load(new URLRequest(_assetsXML));
			urlLoader.addEventListener(Event.COMPLETE, sceneXMLLoadCompleteHandler);
		}
		
		
		
		/**
		 * <p> シーンに外部SWFを読み込みます。 </p>
		 * <p> 読み込み完了までSceneEvent.ENTERの配信が遅延されます。 </p>
		 *
		 * @param
		 */
		private function loadSceneSWF():void
		{
			if (_assetsSWF == NO_REQUEST) return;
			
			_requestLoadAssets++;
			
			_useLoadAssetsOption ? load(_assetsSWF, _loadAssetsOption ) : load(_assetsSWF); 
		}
		
		private function loadSceneSWFCompleteHandler(e:EasyLoadEvent):void 
		{
			_requestLoadAssets--;
			checkLoadAssets();
		}
		
		private function sceneXMLLoadCompleteHandler(e:Event):void
		{
			e.target.removeEventListener(Event.COMPLETE, sceneXMLLoadCompleteHandler);
			_sceneXML = XML(e.target.data);
			_requestLoadAssets--;
			
			if (_sceneXML.actions.action.length() > 0)
			{
				var n:uint = _sceneXML.actions.action.length();
				var type:String = _sceneXML.actions.action[i].@type;
				var container:DisplayObjectContainer;
				var loadingIndicatorClass:Class;
				var option:Object = { };
				
				for (var i:int = 0; i < n; i++) 
				{
					type = _sceneXML.actions.action[i].@type;
					
					switch (type) 
					{
						case "audio" :
							
							soundManager.play(_sceneXML.actions.action[i].@url, true);
							
						break;
						
						case "load" :
							
							container = instanceManager.getInstanceByKey(sceneManager[sceneId.shortPath].@container) as DisplayObjectContainer;
							
							if(_sceneXML.actions.action[i].@progress.toString() != "") loadingIndicatorClass = DisplayUtil.getClassByName(_sceneXML.actions.action[i].@progress.toString());
							
							option = {
								container:this,
								key:_sceneXML.actions.action[i].@key,
								transition:_sceneXML.actions.action[i].@transition,
								smoothing:Boolean(_sceneXML.actions.action[i].@smoothing)
							}
							
							if (loadingIndicatorClass) option.progress = new loadingIndicatorClass(this, true);
							
							load(_sceneXML.actions.action[i].@url, option);
							
						break;
					}
				}
			}
			
			onSceneXML();
			checkLoadAssets();
		}
		
		
		
		/**
		 * <p> シーン遷移アニメーションが終了した瞬間に実行されます。 </p>
		 *
		 * @param
		 */
		private function sceneEenterActionCompleteHandler(e:Event):void
		{
			_sceneEenterAction.removeEventListener(Event.COMPLETE, sceneEenterActionCompleteHandler);
			
			if (isDestroyScene) return;
			
			dispatchEvent(new SceneEvent(SceneEvent.ENTER, sceneId));
			onSceneEnter();
		}
		
		
		
		/**
		 * <p> シーン遷移アニメーションが終了した瞬間に実行されます。 </p>
		 *
		 * @param
		 */
		private function sceneLeaveActionCompleteHandler(e:Event):void 
		{
			_sceneLeaveAction.removeEventListener(Event.COMPLETE, sceneLeaveActionCompleteHandler);
			dispatchEvent(new SceneEvent(SceneEvent.LEAVE, sceneId));
			destroy();
			onSceneLeave();
		}
		
		
		
		/**
		 * <p> シーン遷移アニメーションが終了した瞬間に実行されます。 </p>
		 *
		 * @param
		 */
		private function sceneChangeHandler(e:SceneEvent):void 
		{
			checkSceneId();
			onSceneChange();
		}
		
		private function sceneDepartureHandler(e:SceneEvent):void 
		{
			if(sceneId.fullPath == sceneManager.departure.fullPath) onSceneDeparture();
		}
		
		private function sceneArrivalHandler(e:SceneEvent):void
		{
			if(sceneId.fullPath == sceneManager.terminus.fullPath) onSceneArrival();
		}
		
		private function sceneAscendHandler(e:SceneEvent):void 
		{
			if(sceneId.root == currentScene.root && sceneId.fullPath == sceneManager.getSceneDataBySceneId(sceneManager.previousScene).parent.sceneId.fullPath) onSceneAscend();
		}
		
		private function sceneDescendHandler(e:SceneEvent):void 
		{
			if (sceneId.root == currentScene.root && sceneId.fullPath == e.sceneId.fullPath) onSceneDescend();
		}
		
		
		
		/*======================================================================*//**
		 * <p> 生存期間に基づいて自身を破壊するか判定します。 </p>
		 * 
		 * @param
		 */
		private function checkSceneId():void 
		{
			switch (_type) 
			{
				case SceneType.EVERY_CONTENTS:
					
				break;
				
				case SceneType.EVERY_SCENE:
					
				break;
				
				/*======================================================================*//**
				 * <p> 同一シーン内かつ遷移元が自身だった場合、自身を破壊します。 </p>
				 * 
				 * @param
				 */
				case SceneType.SAME_CONTENS:
					if (_type, sceneManager.terminus.fullPath != sceneId.fullPath)
					{
						//trace("▲ SceneType.SAME_CONTENS : 同一シーン内かつ遷移元が自身だった場合、自身を破壊します。", sceneManager.terminus.fullPath , sceneId.fullPath)
						destroyScene();
					}
				break;
				
				/*======================================================================*//**
				 * <p> 同一シーン内から遷移した場合、自身を破壊します。 </p>
				 * 
				 * @param
				 */
				case SceneType.SAME_SCENE:
					if (sceneManager.terminus.root != sceneId.root)
					{
						//trace("▲ SceneType.SAME_SCENE : 同一シーン内から遷移した場合、自身を破壊します。", sceneManager.terminus.root, sceneId.root)
						destroyScene();
					}
				break;
			}
		}
		
		
		private function checkLoadAssets():void 
		{
			if (_requestLoadAssets == 0) executeEnterCommand();
		}
		
		private function executeEnterCommand():void 
		{
			sceneEenterAction.addEventListener(Event.COMPLETE, sceneEenterActionCompleteHandler);
			sceneEenterAction.pushWait(100);
			sceneEenterAction.execute();
		}
		
		
		
		/**
		 * <p> 表示リストへ追加された瞬間に実行されます。 </p>
		 *
		 * @param
		 */
		override protected function addedToStageHandler(e:Event = null):void
		{
			if (type == SceneType.SAME_CONTENS)
			{
				if (sceneManager.terminus.fullPath != sceneId.fullPath)
				{
					dispatchEvent(new SceneEvent(SceneEvent.ENTER, sceneId));
					destroyScene();
					return;
				}
			}
			
			_document = sceneManager.document;
			
			if (_assetsXML == NO_REQUEST && _assetsSWF == NO_REQUEST) executeEnterCommand();
			if (_assetsXML) loadSceneXML();
			if (_assetsSWF) loadSceneSWF();
			
			super.addedToStageHandler();
		}
		
		protected function onSceneXML():void { }
		
		override protected function setReceiveEvent():void
		{
			sceneManager.addEventListener(SceneEvent.CHANGE, sceneChangeHandler);
			sceneManager.addEventListener(SceneEvent.DEPARTURE, sceneDepartureHandler);
			sceneManager.addEventListener(SceneEvent.ARRIVAL, sceneArrivalHandler);
			sceneManager.addEventListener(SceneEvent.ASCEND, sceneAscendHandler);
			sceneManager.addEventListener(SceneEvent.DESCEND, sceneDescendHandler);
			loader.addEventListener(EasyLoadEvent.LOAD_COMPLETE, loadSceneSWFCompleteHandler);
		}
		
		override protected function removeReceiveEvent():void
		{
			sceneManager.removeEventListener(SceneEvent.CHANGE, sceneChangeHandler);
			sceneManager.removeEventListener(SceneEvent.DEPARTURE, sceneDepartureHandler);
			sceneManager.removeEventListener(SceneEvent.ARRIVAL, sceneArrivalHandler);
			sceneManager.removeEventListener(SceneEvent.ASCEND, sceneAscendHandler);
			sceneManager.removeEventListener(SceneEvent.DESCEND, sceneDescendHandler);
			loader.removeEventListener(EasyLoadEvent.LOAD_COMPLETE, loadSceneSWFCompleteHandler);
		}
		
		
		
		protected function destroyScene():void
		{
			if (!_isDestroyScene)
			{
				_isDestroyScene = true;
				
				bitmapCollection.close();
				loader.close();
				killAnimate(this);
				
				//trace("□ onSceneLeave", className, name);
				
				blendMode = BlendMode.LAYER;
				sceneLeaveAction.addEventListener(Event.COMPLETE, sceneLeaveActionCompleteHandler);
				sceneLeaveAction.execute();
				
				instanceManager.remove(key);
			}
		}
		
		
		
		/**
		 * <p> 自シーンが生成された際、sceneEenterAction完了後に実行されます。 </p>
		 * 
		 * @param
		 */
		protected function onSceneEnter():void { }
		
		/**
		 * <p> 自シーンが破棄された際、sceneLeaveAction完了後に実行されます。 </p>
		 * 
		 * @param
		 */
		protected function onSceneLeave():void { }
		
		/**
		 * <p> シーンルートが変更された際に実行されます。 </p>
		 * 
		 * @param
		 */
		protected function onSceneChange():void { }
		
		/**
		 * <p> シーンが変更が開始された際に実行されます。 </p>
		 * 
		 * @param
		 */
		protected function onSceneDeparture():void { }
		
		/**
		 * <p> シーンが変更が完了した際に実行されます。 </p>
		 * 
		 * @param
		 */
		protected function onSceneArrival():void { }
		
		/**
		 * <p> 自シーンから１階層上に移動した際に実行されます。 </p>
		 * 
		 * @param
		 */
		protected function onSceneAscend():void { }
		
		/**
		 * <p> 自シーンから１階層下に移動した際に実行されます。 </p>
		 * 
		 * @param
		 */
		protected function onSceneDescend():void { }
		
		
		
		public function get sceneId():SceneId
		{
			return _sceneId;
		}
		
		public function get fullPath():String
		{
			return _sceneId.fullPath;
		}
		
		public function get shortPath():String
		{
			return _sceneId.shortPath;
		}
		
		public function get sceneData():ISceneData
		{
			return _sceneData;
		}
		
		public function get sceneXML():XML 
		{
			return _sceneXML;
		}
		
		public function get isSceneAscend():Boolean 
		{
			return _isSceneAscend;
		}
		
		public function get type():String 
		{
			return _type;
		}
		
		public function get isSceneDescend():Boolean 
		{
			return _isSceneDescend;
		}
		
		public function get isDestroyScene():Boolean 
		{
			return _isDestroyScene;
		}
		
		public function get sceneEenterAction():SerialCommand 
		{
			if(!_sceneEenterAction) _sceneEenterAction = new SerialCommand();
			return _sceneEenterAction;
		}
		
		public function set sceneEenterAction(value:SerialCommand):void 
		{
			_sceneEenterAction = value;
		}
		
		public function get sceneLeaveAction():SerialCommand 
		{
			if(!_sceneLeaveAction) _sceneLeaveAction = new SerialCommand();
			return _sceneLeaveAction;
		}
		
		public function set sceneLeaveAction(value:SerialCommand):void 
		{
			_sceneLeaveAction = value;
		}
		
		public function get assetsXML():String 
		{
			return _assetsXML;
		}
		
		public function set assetsXML(value:String):void 
		{
			_assetsXML = value;
		}
		
		public function get assetsSWF():String 
		{
			return _assetsSWF;
		}
		
		public function set assetsSWF(value:String):void 
		{
			_assetsSWF = value;
		}
		
		public function get document():Document 
		{
			return _document;
		}
		
		public function get loadAssetsOption():Object 
		{
			return _loadAssetsOption;
		}
		
		public function set loadAssetsOption(value:Object):void 
		{
			_loadAssetsOption = value;
		}
		
		public function get useLoadAssetsOption():Boolean 
		{
			return _useLoadAssetsOption;
		}
		
		public function set useLoadAssetsOption(value:Boolean):void 
		{
			_useLoadAssetsOption = value;
		}
	}
}