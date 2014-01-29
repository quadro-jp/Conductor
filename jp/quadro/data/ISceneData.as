package jp.quadro.data 
{
	import flash.display.DisplayObjectContainer;
	import flash.events.Event;
	
	/**
	 * ...
	 * @author aso
	 */
	public interface ISceneData
	{
		function add(data:ISceneData):void;
		function getChildAt(index:uint):ISceneData;
		function getChildByName(name:String):ISceneData;
		
		function get type():String;
		function get fullPath():String;
		function get shortPath():String;
		function get root():String;
		function get sceneId():SceneId;
		function get parent():ISceneData;
		function get numScenes():uint;
		function get hasParent():Boolean;
		function get hasChildren():Boolean;
		function get title():String;
		function get className():String;
		function get container():String;
		
		function addEventListener (type:String, listener:Function, useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = false) : void;
		function dispatchEvent (event:Event) : Boolean;
		function hasEventListener (type:String) : Boolean;
		function removeEventListener (type:String, listener:Function, useCapture:Boolean = false) : void;
		function willTrigger (type:String) : Boolean;
		
		function getSceneNameList():Array;
	}
}