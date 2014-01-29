package jp.quadro.collection
{
	
	public interface ICollection 
	{
		function add(value:Object):void;
		
		function remove(value:uint):void;
		
		function contains(item:*):uint
		
		function iterator():IIterator;
		
		function get length():uint;
	}
}