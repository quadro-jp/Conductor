package jp.quadro.core
{
	import flash.display.LoaderInfo;
	
	public interface IConnectable
	{
		function connect(loaderInfo:LoaderInfo):void;
		function addEventListener (type:String, listener:Function, useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = false):void
	}
}