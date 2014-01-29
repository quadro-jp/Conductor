package jp.quadro.data
{
	import flash.display.DisplayObjectContainer;
	import flash.events.EventDispatcher;
	import jp.quadro.collection.Collection;
	import jp.quadro.core.ISceneData;
	
	/**
	 * ...
	 * @author aso
	 */
	public class SceneData extends EventDispatcher implements ISceneData
	{
		private var _title:String;
		private var _className:String;
		private var _container:String;
		
		private var _collection:Collection;
		private var _sceneId:SceneId;
		private var _parent:ISceneData;
		private var _type:String;
		
		public function SceneData(sceneId:SceneId, title:String, className:String, container:String, parent:ISceneData = null)
		{
			_sceneId = sceneId;
			_title = title;
			_className = className;
			_container = container;
			_collection = new Collection();
			_parent = parent ? parent : new NullSceneData();
		}
		
		public function add(data:ISceneData):void
		{
			_collection.add(data);
		}
		
		public function getChildAt(index:uint):ISceneData
		{
			return _collection.iterator().key(index) as ISceneData;
		}
		
		public function getChildByName(name:String):ISceneData
		{
			var n:uint = _collection.length;
			var sceneData:ISceneData;
			
			for (var i:int = 0; i < n; i++)
			{
				sceneData = _collection.iterator().key(i) as ISceneData;
				if (sceneData.shortPath == name)
					break;
			}
			return sceneData;
		}
		
		public function getSceneNameList():Array
		{
			var n:uint = _collection.length;
			var sceneData:ISceneData;
			var list:Array = [];
			
			for (var i:int = 0; i < n; i++)
			{
				sceneData = _collection.iterator().key(i) as SceneData;
				list.push(sceneData.shortPath)
			}
			return list;
		}
		
		public function get fullPath():String
		{
			return _sceneId.fullPath;
		}
		
		public function get shortPath():String
		{
			return _sceneId.shortPath;
		}
		
		public function get root():String
		{
			return _sceneId.root;
		}
		
		public function get sceneId():SceneId
		{
			return _sceneId
		}
		
		public function get title():String 
		{
			return _title;
		}
		public function get hasChildren():Boolean
		{
			return _collection.length > 0;
		}
		
		public function get className():String
		{
			return _className;
		}
		public function get container():String 
		{
			return _container;
		}
		
		public function get parent():ISceneData
		{
			return _parent;
		}
		
		public function get numScenes():uint
		{
			return _collection.length;
		}
		
		public function get hasParent():Boolean
		{
			return _parent is NullSceneData ? false : true;
		}
		
		public function get type():String 
		{
			return _type;
		}
	}
}