package jp.quadro.data 
{
	import flash.display.DisplayObjectContainer;
	import flash.events.EventDispatcher;
	import jp.quadro.core.ISceneData;

	/**
	 * ...
	 * @author aso
	 */
	public class NullSceneData extends EventDispatcher implements ISceneData
	{
		public function add(data:ISceneData):void { }
		public function getChildAt(index:uint):ISceneData { return new NullSceneData(); }
		public function getChildByName(name:String):ISceneData { return new NullSceneData(); }
		public function getSceneNameList():Array { return null }
		public function get type():String { return ""; }
		public function get fullPath():String { return "NullScene"; }
		public function get shortPath():String { return "NullScene"; }
		public function get root():String { return "NullScene"; }
		public function get sceneId():SceneId { return new SceneId("NullScene"); };
		public function get parent():ISceneData { return new NullSceneData(); }
		public function get numScenes():uint { return 0 }
		public function get hasParent():Boolean { return false }
		public function get hasChildren():Boolean { return false }
		public function get title():String { return "NullTitle"; }
		public function get className():String { return "NullClass"; }
		public function get container():String { return null; }
	}
}