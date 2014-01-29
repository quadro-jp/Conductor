package jp.quadro.collection
{
	import jp.quadro.core.ICollection;
	import jp.quadro.core.IIterator;
	
	public class Collection implements ICollection
	{
		private var _array:Array;
		private var _iterator:IIterator;
		
		public function Collection()
		{
			_array = [];
		}
		
		public function add(value:Object):void
		{
			_array.push(value);
		}
		
		public function remove(value:uint):void
		{
			_array.splice(value, 1);
		}
		
		public function contains(item:*):uint
		{
			var i:int  = _array.indexOf(item, 0);
			var t:uint = 0;
			
			while (i != -1) {
				i = _array.indexOf(item, i + 1);
				t++;
			}
			
			return t;
		}
		
		public function destroy():void
		{
			_array = [];
			_iterator = null;
		}
		
		public function iterator():IIterator
		{
			if (_iterator == null) _iterator = new Iterator(_array)
			
			return _iterator;
		}
		
		public function get length():uint
		{
			return _array.length;
		}
	}
}