package jp.quadro.mashup.twitter.data
{
		
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
		
		public function first():TweetData
		{
			reset();
			
			return _collection[_index++];
		}
		
		public function next():TweetData
		{
			return _collection[_index++];
		}
		
		public function key(value:uint):TweetData
		{
			return _collection[_index = value];
		}
		
		public function current():TweetData
		{
			return _collection[_index];
		}
		
		public function overwrite(value:TweetData):TweetData
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