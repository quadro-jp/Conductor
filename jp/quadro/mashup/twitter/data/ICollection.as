package jp.quadro.mashup.twitter.data
{
	public interface ICollection 
	{
		function iterator():IIterator;
		
		function addElement(value:TweetData):void;
	}
}