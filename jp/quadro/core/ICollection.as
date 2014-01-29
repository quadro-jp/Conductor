package jp.quadro.core
{
	import jp.quadro.core.IIterator;
	
	public interface ICollection 
	{
		function add(value:Object):void;
		
		function remove(value:uint):void;
		
		function contains(item:*):uint
		
		function iterator():IIterator;
		
		function get length():uint;
	}
}