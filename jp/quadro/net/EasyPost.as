package jp.quadro.net
{
	import flash.display.*;
	import flash.events.*;
	import flash.net.*;
	
	public class EasyPost extends EventDispatcher
	{
		public function EasyPost(url:String, variables:Object)
		{
			var request:URLRequest = new URLRequest( url );
			var urlVariables:URLVariables = new URLVariables();
			var loader:URLLoader = new URLLoader();
			
			for (var i:String in variables)
			{
				urlVariables[i] = variables[i];
			}
			
			request.method = URLRequestMethod.GET;
			
			request.data = urlVariables;
			
			loader.dataFormat = URLLoaderDataFormat.VARIABLES;
			loader.addEventListener(Event.COMPLETE, onComplete);
			loader.addEventListener(IOErrorEvent.IO_ERROR, errorHandler);
			
			loader.load(request);
		}
		
		private function onComplete(e:Event):void
		{
			var vars:URLVariables = new URLVariables( e.target.data );
			dispatchEvent(new Event(Event.COMPLETE));
		}
		
		private function errorHandler(e:IOErrorEvent):void
		{
			throw new Error("post error");
		}
	}
}