package jp.quadro.core
{
	public interface ILinkable
	{
		function addEventListener(type:String, listener:Function, useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = false):void;
		function removeEventListener(type:String, listener:Function, useCapture:Boolean = false):void
		
		function get group():String;
		function set group(value:String):void;
		
		function get id():uint;
		function set id(value:uint):void;
		
		function get linkSceneName():String;
		function set linkSceneName(value:String):void;
		
		function get linkPageNumber():uint;
		function set linkPageNumber(value:uint):void;
	}
}