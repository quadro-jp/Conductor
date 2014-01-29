package jp.quadro.managers
{
	import flash.display.DisplayObjectContainer;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.utils.Dictionary;
	import flash.utils.flash_proxy;
	import flash.utils.Proxy;
	import jp.quadro.core.Document;
	import jp.quadro.core.ISceneData;
	import jp.quadro.data.NullSceneData;
	import jp.quadro.data.SceneData;
	import jp.quadro.data.SceneId;
	import jp.quadro.display.Logger;
	import jp.quadro.display.MessageDisplay;
	import jp.quadro.events.ProcessEvent;
	import jp.quadro.events.SceneEvent;
	import jp.quadro.managers.InstanceManager;
	import jp.quadro.managers.Settings;
	
	dynamic public class SceneManager extends Proxy implements IEventDispatcher
	{
		public static const INIT:String = "init";
		
		private static var _instance:SceneManager;
		private var _eventDispatcher:EventDispatcher;
		private var _xml:XML;
		
		private var _rootSceneId:SceneId;
		private var _previousScene:SceneId;
		
		private var _document:Document;
		private var _sceneData:ISceneData;
		private var _dictionary:Dictionary;
		private var _sceneNameList:Array;
		
		private var _queue:Array;
		private var _departure:SceneId;
		private var _terminus:SceneId;
		private var _current:String;
		private var _hierarchy:int;
		private var _externalReceive:Boolean;
		
		private var _numScenes:uint;
		private var _process:String;
		private var _obj:*;
		
		private var _logManager:LogManager;
		private var _logger:Logger;
		
		/**
		 * <p> シーン情報を管理する為のクラスです。 </p>
		 * 
		 * @param　enforcer　
		 */
		public function SceneManager(enforcer:SingletonEnforcer)
		{
			_eventDispatcher = new EventDispatcher(this);
			_dictionary = new Dictionary();
			_sceneNameList = [];
			_queue = [];
			_sceneData = new NullSceneData();
			_previousScene = new SceneId('NullScene');
			_departure = new SceneId('NullScene');
			_terminus = new SceneId('NullScene');
			_logManager = LogManager.getInstance();
		}
		
		/**
		 * <p> SceneManagerのインスタンスを取得するメソッドです。 </p>
		 * 
		 * @param
		 */
		public static function getInstance():SceneManager
		{
			if (SceneManager._instance == null) SceneManager._instance = new SceneManager(new SingletonEnforcer());
			
			return SceneManager._instance;
		}
		
		/**
		 * <p> XMLを読み込んでシーン情報をパースします。 </p>
		 * 
		 * @param
		 */
		public function load(url:String):void
		{
			_logManager.add('XMLを読み込んでシーン情報をパースします。');
			
			if (_xml)
			{
				dispatchEvent(new Event(SceneManager.INIT));
			}
			else
			{
				var urlLoader:URLLoader = new URLLoader();
				urlLoader.load(new URLRequest(url));
				urlLoader.addEventListener(Event.COMPLETE, xmlLoadCompleteHandler);
			}
		}
		
		
		
		/**
		 * <p> Documentを構築し、SceneManagerを初期化します。 </p>
		 * <p> XMLからシーン構造を構築します。 </p>
		 * 
		 * @param
		 */
		internal function initialize():void
		{
			_numScenes = _xml.scenes.child("scene").length();
			_rootSceneId = new SceneId(_xml.scenes.scene[0].@name);
			
			_logManager.add("■ SceneManagerを初期化します。");
			_logManager.add("■ " + _numScenes + "個のシーンノードが見つかりました。\n");
			
			addSceneFromXML(_xml.scenes.child("scene"));
			
			Settings.lang = _xml.settings.setting.@lang;
			Settings.autolock = _xml.settings.setting.(@name=='autolock').@value == 'true' ? true : false;
			Settings.debug = _xml.settings.setting.(@name=='debug').@value == 'true' ? true : false;
			Settings.deeplink = _xml.settings.setting.(@name=='deeplink').@value == 'true' ? true : false;
			
			if (Settings.debug)
			{
				_logger = new Logger();
				_logger.addMonitorParam("scene:", this, "currentSceneName", _eventDispatcher, SceneEvent.CHANGE);
				_document.stage.addChild(_logger);
			}
			
			if (!Settings.deeplink)
			{
				gotoSceneByName(getRootSceneId());
			}
			else
			{
				SWFAddress.addEventListener(SWFAddressEvent.INIT, addressInitializeHandler);
				SWFAddress.addEventListener(SWFAddressEvent.EXTERNAL_CHANGE, externalAddressChangeHandler);
				SWFAddress.addEventListener(SWFAddressEvent.INTERNAL_CHANGE, internalAddressChangeHandler);
				SWFAddress.addEventListener(SWFAddressEvent.CHANGE, addressChangeHandler);
			}
			
			dispatchEvent(new Event(SceneManager.INIT));
		}
		
		
		
		/**
		 * <p> 子ノードがある場合は、再帰処理します。 </p>
		 * 
		 * @param
		 */
		public function addSceneFromXML(xmllist:XMLList, parent:ISceneData = null):void
		{
			var sceneData:ISceneData;
			var name:String;
			var title:String;
			var className:String;
			var container:String;
			var id:SceneId;
			var i:int;
			var n:uint = xmllist.length();
			
			if (n == 0) return;
			
			for (i = 0; i < n; i++) 
			{
				if (parent) {
					name = parent.fullPath + "/" + xmllist[i].@name;
				}else {
					name = xmllist[i].@name;
					_sceneNameList.push(name);
				}
				
				title = xmllist[i].@title;
				className = xmllist[i].@className;
				container = xmllist[i].@container;
				id = new SceneId(name);
				sceneData = new SceneData(id, title, className, container, parent);
				_dictionary[id.fullPath] = sceneData;
				if (sceneData.hasParent) parent.add(sceneData);
				addSceneFromXML(xmllist[i].child("scene"), sceneData);
			}
		}
		
		
		public function getSceneDataBySceneId(sceneId:SceneId):SceneData
		{
			var sceneData:SceneData;
			
			try { sceneData = _dictionary[sceneId.fullPath]; }
			catch (err:Error) { sceneData = new SceneData(new SceneId('NullScene'), '', '', null, new NullSceneData()); }
			return sceneData;
		}
		public function getRootSceneId():SceneId { return _rootSceneId; }
		public function getRootSceneName():String { return _rootSceneId.fullPath; }
		public function getSceneNameList():Array { return _sceneNameList.concat(); }
		
		public function contains(sceneId:SceneId):Boolean
		{
			return InstanceManager.getInstance().contains('SceneContainer_' + sceneId.fullPath);
		}
		
		public function next():void 
		{
			//trace('---------------------->', _process);
			
			switch (_process) 
			{
				case ProcessEvent.PROCESS_WAIT : _process = ProcessEvent.PROCESS_INIT; break;
				case ProcessEvent.PROCESS_INIT : _process = ProcessEvent.PROCESS_START; break;
				case ProcessEvent.PROCESS_START : _process = ProcessEvent.PROCESS_COMPLETE; break;
				case ProcessEvent.PROCESS_COMPLETE : 
					change(new SceneId(_current));
					return;
				break;
			}
			dispatchEvent(new ProcessEvent(_process));
		}
		
		public function gotoSceneByName(sceneId:SceneId):void 
		{
			trace('gotoSceneByName:',sceneId);
			if (_sceneData.fullPath == sceneId.fullPath) return;
			
			Settings.deeplink ? SWFAddress.setValue(sceneId.fullPath) : gotoNextScene(sceneId);
		}
		
		private function gotoNextScene(sceneId:SceneId):void
		{
			trace('シーン遷移リクエスト', _sceneData.sceneId.fullPath + ' から ' + sceneId.fullPath);
			//trace('シーンを開始：', _sceneData.sceneId.fullPath + ' から ' + sceneId.fullPath);
			
			if (!getSceneDataBySceneId(sceneId))
			{
				gotoSceneByName(getRootSceneId());
				return;
			}
			
			document.conductor.addEventListener(SceneEvent.ENTER, sceneEnterHandler);
			document.conductor.addEventListener(SceneEvent.LEAVE, sceneLeaveHandler);
			
			_queue = [];
			_terminus = sceneId;
			_departure = _sceneData.sceneId;
			_queue = getPathNames(sceneId.fullPath);
			_current = _queue.shift();
			_hierarchy = 1;
			
			dispatchEvent(new SceneEvent(SceneEvent.CHANGE, _terminus));
			dispatchEvent(new SceneEvent(SceneEvent.DEPARTURE, _departure));
			
			processInitialize();
		}
		
		private function change(sceneId:SceneId):void 
		{
			trace('シーン遷移を実行：', _sceneData.sceneId.fullPath + ' から ' + sceneId.fullPath);
			
			_previousScene = _sceneData.sceneId;
			_sceneData = getSceneDataBySceneId(sceneId);
			dispatchEvent(new SceneEvent(SceneEvent.CREATE, _sceneData.sceneId));
			
			try {
				if (getSceneDataBySceneId(new SceneId(_previousScene.fullPath)).parent.fullPath == _sceneData.sceneId.fullPath) {
					dispatchEvent(new SceneEvent(SceneEvent.ASCEND, _sceneData.sceneId));
				}
			}
			catch (err:Error) { trace('シーンデータが無効です。'); }
			
			
			if (_terminus.fullPath == sceneId.fullPath)
			{
				trace('URL変更完了：', _sceneData.fullPath);
				document.conductor.removeEventListener(SceneEvent.ENTER, sceneEnterHandler);
				document.conductor.removeEventListener(SceneEvent.LEAVE, sceneLeaveHandler);
				dispatchEvent(new SceneEvent(SceneEvent.ARRIVAL, _sceneData.sceneId));
				if (Settings.deeplink) SWFAddress.setTitle(_sceneData.title);
				return;
			}
		}
		
		private function sceneEnterHandler(e:SceneEvent):void 
		{
			if (_queue.length > 0)
			{
				//trace('シーンを通過：', _current);
				dispatchEvent(new SceneEvent(SceneEvent.DESCEND, new SceneId(_current)));
				
				_current += '/' + _queue.shift();
				_hierarchy++;
				change(new SceneId(_current));
			} else {
				
			}
		}
		
		private function processInitialize():void
		{
			_process = ProcessEvent.PROCESS_WAIT;
			next();
		}
		
		private function sceneLeaveHandler(e:SceneEvent):void 
		{
			
		}
		
		private function xmlLoadCompleteHandler(e:Event):void
		{
			e.target.removeEventListener(Event.COMPLETE, xmlLoadCompleteHandler);
			_xml = XML(e.target.data);
			initialize();
		}
		
		public function get sceneData():ISceneData { return _sceneData; }
		public function get previousScene():SceneId { return _previousScene; }
		public function get currentSceneName():String { return _sceneData.shortPath; }
		public function get currentSceneRoot():String { return _sceneData.root; }
		public function get document():Document { return _document; }
		public function set document(value:Document):void { if (_document == null) _document = value; }
		public function get numScenes():uint { return _numScenes; }
		public function get process():String { return _process; }
		public function get externalReceive():Boolean { return _externalReceive; }
		internal function get xml():XML { return _xml; }
		
		public function get terminus():SceneId { return _terminus; }
		public function get departure():SceneId { return _departure; }
		
		private function onAddressInitialize():void 
		{
			
		}
		
		protected function onAddressChange():void
		{
			//gotoNextScene(new SceneId('scene1/photo1'));
			//gotoNextScene(new SceneId('scene1/photo1/car1'));
			gotoNextScene(new SceneId(SWFAddress.getPath()));
			//gotoSceneByName(new SceneId(SWFAddress.getPath()));
		}
		
		private function onExternalAddressChange():void 
		{
			_externalReceive = true;
		}
		
		private function onInternalAddressChange():void 
		{
			_externalReceive = false;
		}
		
		private function getPathNames(path:String):Array
		{
            var names:Array = path.split('/');
            if (path.substr(0, 1) == '/' || path.length == 0) names.splice(0, 1);
            if (path.substr(path.length - 1, 1) == '/') names.splice(names.length - 1, 1);
            return names;
		}
		
		
		private function addressInitializeHandler(e:SWFAddressEvent):void 
		{
			onAddressInitialize();
			if(Settings.debug) new MessageDisplay(document, 'addressInitializeHandler:externalReceive --->' + externalReceive);
		}
		
		private function addressChangeHandler(e:SWFAddressEvent):void 
		{
			onAddressChange();
			if(Settings.debug) new MessageDisplay(document, 'addressChangeHandler:externalReceive --->' + externalReceive);
		}
		
		private function externalAddressChangeHandler(e:SWFAddressEvent):void 
		{
			onExternalAddressChange();
			if(Settings.debug) new MessageDisplay(document, 'externalAddressChangeHandler:externalReceive --->' + externalReceive);
		}
		
		private function internalAddressChangeHandler(e:SWFAddressEvent):void 
		{
			onInternalAddressChange();
			if(Settings.debug) new MessageDisplay(document, 'internalAddressChangeHandler:externalReceive --->' + externalReceive);
		}
		
		
		
		/**
		 * <p> EventListener </p>
		 * 
		 * @param
		 */
		public function addEventListener(type:String, listener:Function, useCapture:Boolean = false, priority:int = 0, weakRef:Boolean = false):void {
			_eventDispatcher.addEventListener(type, listener, useCapture, priority, weakRef);
		}
		
		public function dispatchEvent(event:Event):Boolean {
			return _eventDispatcher.dispatchEvent(event);
		}
		
		public function hasEventListener(type:String):Boolean {
			return _eventDispatcher.hasEventListener(type);
		}
		
		public function removeEventListener(type:String, listener:Function, useCapture:Boolean = false):void {
			_eventDispatcher.removeEventListener(type, listener, useCapture);
		}
		
		public function willTrigger(type:String):Boolean {
			return _eventDispatcher.willTrigger(type);
		}
		
		/**
		 * <p> flash_proxy </p>
		 * 
		 * @param
		 */
		override flash_proxy function getProperty(name:*):* {
			var str:String = String(name);
			return _xml..scene.(@name == str);
		}
		
		override flash_proxy function callProperty (name:*, ...rest) : * {
			return _xml.scenes.scene.(@name == str).rest;
		}
		
		override flash_proxy function setProperty(name:*, value:*):void {
			_obj[name] = value;
		}
		
		override flash_proxy function deleteProperty(name:*):Boolean {
		  return delete _obj[name];
		}
		
		override flash_proxy function hasProperty(name:*):Boolean {
		  return name in _obj;
		}
	}
}