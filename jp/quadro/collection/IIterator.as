package jp.quadro.collection
{
	public interface IIterator
	{
		function hasNext():Boolean;
		
		function first():Object;
		
		function last():Object;
		
		function next():Object;
		
		function key(value:uint):Object;
		
		function current():Object;
		
		function overwrite (value:Object):Object;
		
		function reset():void;
		
		function get length():uint;
	}
}