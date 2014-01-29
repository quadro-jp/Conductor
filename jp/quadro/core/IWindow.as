package jp.quadro.core 
{
	import flash.events.Event;
	
	public interface IWindow 
	{
		function addEventListener(type:String, listener:Function, useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = false):void;
		function removeEventListener(type:String, listener:Function, useCapture:Boolean = false):void
		function dispatchEvent (event:Event):Boolean;
		function close():void;
		function open():void;
		function destroy():void;
		function setConstraints(align:String, scale:String):void;
		function get state():String;
		function get key():String;
	}
}