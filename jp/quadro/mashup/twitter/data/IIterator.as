package jp.quadro.mashup.twitter.data
{
	
	public interface IIterator
	{
		function hasNext():Boolean;
		
		function first():TweetData;
		
		function next():TweetData;
		
		function key(value:uint):TweetData;
		
		function current():TweetData;
		
		function overwrite (value:TweetData):TweetData;
		
		function reset():void;
		
		function get length():uint;
	}
}