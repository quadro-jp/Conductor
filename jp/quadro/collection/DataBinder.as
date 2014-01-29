package jp.quadro.collection
{
	import flash.utils.Dictionary;
	import jp.quadro.utils.ObjectUtil;
	
	/**
	 * ...
	 * @author aso
	 */
	public class DataBinder
	{
		private var _binder:Dictionary = new Dictionary();
		private var _counter:uint = 0;
		
		public function add(key:String, data:Object):void
		{
			if (contains(key)) {
				//throw new Error('キーの値が重複しています。', key);
				//return;
			}
			
			_binder[key] = data;
		}
		
		public function remove(key:String):void
		{
			if (contains(key)) delete _binder[key];
		}
		
		public function getDataByKey(key:String):Object
		{
			return _binder[key];
		}
		
		public function getKeys():Array
		{
			return ObjectUtil.getKeys(_binder);
		}
		
		public function contains(key:String):Boolean
		{
			for each (var object:Object in _binder)
			{
				if (object.key == key) return true;
			}
			return false;
		}
		
		public function destroy():void
		{
			_binder = null;
		}
	}
}