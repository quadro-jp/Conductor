package jp.quadro.collection
{
	import jp.quadro.core.IIterator;
	import jp.quadro.utils.MathUtil;
	
	public class Iterator implements IIterator
	{
		private var _collection:Array;
		private var _index:uint;
		
		public function Iterator(collection:Array)
		{
			_collection = collection;
			_index = 0;
		}
		
		public function hasNext():Boolean
		{
			return _index < _collection.length;
		}
		
		public function first():Object
		{
			reset();
			
			return _collection[_index++];
		}
		
		public function last():Object
		{
			reset();
			
			return _collection[length - 1];
		}
		
		public function next():Object
		{
			return _collection[_index++];
		}
		
		public function key(value:uint):Object
		{
			value = MathUtil.range(value, 0, _collection.length - 1);
			_index = value;
			return _collection[ _index ];
		}
		
		public function current():Object
		{
			return _collection[_index];
		}
		
		public function overwrite(value:Object):Object
		{
			return _collection[_index] = value;
		}
		
		public function reset():void
		{
			_index = 0;
		}
		
		public function get length():uint
		{
			return _collection.length;
		}
	}
}