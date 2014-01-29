package jp.quadro.loader
{
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.net.LocalConnection;
	import flash.net.URLRequest;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
	import flash.system.SecurityDomain;
	import flash.utils.Dictionary;
	import jp.quadro.events.EasyLoadEvent;
	import jp.quadro.events.EasyLoadIOErrorEvent;
	import jp.quadro.transition.Transition;
	
	public class EasyLoader extends EventDispatcher
	{
		private var _data:Dictionary;
		
		public function EasyLoader()
		{
			_data = new Dictionary();
		}
		
		public function load (url:String, option:Object):void
		{
			var loader:Loader = new Loader();
			var domain:String = new LocalConnection( ).domain;
			var request:URLRequest = new URLRequest();
			var context :LoaderContext = new LoaderContext();
			var data:Object = { };
			var key:String = getDataKey(url);
			
			request.url = encodeURI(url);
			context.applicationDomain = ApplicationDomain.currentDomain;
			
			if (domain != "localhost") context.securityDomain = SecurityDomain.currentDomain;
			
			if (option)
			{
				if (option.key) key = option.key;
				if (option.progress)
				{
					option.progress.connect(loader.contentLoaderInfo);
					option.progress.addEventListener(Event.COMPLETE, onLoadComplete(key));
				}else {
					loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onLoadComplete(key));
				}
			}
			
			data.url = url;
			data.container = option.container;
			data.callback = option.callback;
			data.transition = option.transition;
			data.smoothing = option.smoothing;
			data.loader = loader;
			
			if (_data[key] == undefined)
			{
				_data[key] = data;
				loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, onIOErrorHandler);
				loader.load(request, context);
				dispatchEvent(new EasyLoadEvent(EasyLoadEvent.START));
			}else {
				Transition.start(_data[key].transition, _data[key].container, _data[key].content, transitionComplete);
			}
		}
		
		public function getResourceByKey(key:String):DisplayObject
		{
			return _data ? _data[key].content : null;
		}
		
		public function close():void
		{
			for each (var item:Object in _data) 
			{
				var loader:Loader = item.loader;
				try{
					loader.unload();
					loader.close();
				}catch(e:Error){
					
				}
			}
		}
		
		public function destroy ():void
		{
			_data = null;
		}
		
		private function onLoadComplete(key:String):Function
		{
			return function(e:Event):void
			{
				try 
				{
					e.target.removeEventListener(IOErrorEvent.IO_ERROR, onIOErrorHandler);
					e.target.removeEventListener(Event.COMPLETE, arguments.callee);
				}
				catch (err:Error)
				{
					
				}
				
				if (_data == null) return;
				
				var data:Object = _data[key];
				
				data.content = e.target.content;
				
				if (data.callback) data.callback();
				if (data.content is Bitmap) data.content.smoothing = data.smoothing;
				if (data.container) Transition.start(data.transition, data.container, data.content, transitionComplete);
				
				dispatchEvent(new EasyLoadEvent(EasyLoadEvent.LOAD_COMPLETE, data.content));
			}
		}
		
		private function onIOErrorHandler(e:IOErrorEvent):void
		{
			if (_data == null) return;
			dispatchEvent(new EasyLoadIOErrorEvent(EasyLoadIOErrorEvent.IO_ERROR));
		}
		
		private function transitionComplete ():void
		{
			if (_data == null) return;
			dispatchEvent(new EasyLoadEvent(EasyLoadEvent.TRANSITION_COMPLETE));
		}
		
		private function getDataKey(str:String):String 
		{
			var split:Array = String(str).split("/");
			var key:String = split[split.length - 1];
			return key;
		}

	}
}
