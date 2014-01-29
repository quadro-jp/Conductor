package jp.quadro.commands.ext
{
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.URLRequest;
	import jp.quadro.commands.CommandBase;
	import jp.quadro.managers.SceneManager;
	
	/*
	LoaderクラスをCommand化したもの。
	引数に渡すparamObjで多様な使い方を指定できる。
	
	url:String
	request:URLRequest
	urlScope:Object, urlProp:String
	
	bytes:ByteArray バイトコードからロードする場合
	
	alternativeURL:String 代替イメージのURL
	
	loader:Loader
	loaderScope:Object, loaderProp:String
	*/
	public class LoaderCommand extends CommandBase
	{
		private var loader:Loader
		private var _paramObj:Object;
		
		public function LoaderCommand(paramObj:Object)
		{
			_paramObj = paramObj;
		}
		
		override public function execute():void
		{
			loader = new Loader();
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, _completeHandler);
			loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, _ioErrorHandler);
			loader.load(new URLRequest(_paramObj.url));
		}
		
		
		//eventHandler for Loader
		protected function _completeHandler(e:Event):void
		{
			loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, _completeHandler);
			loader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, _ioErrorHandler);
			
			if(loader.content != null) _paramObj.scope[_paramObj.target].addChild(loader.content);
			_paramObj = null;
			loader = null;
			this.dispatchComplete();	
		}
		
		protected function _ioErrorHandler(e:Event):void
		{
			_completeHandler(e);
		}
	}
}