package jp.quadro.mashup.twitter.events
{
	import flash.events.Event;
	import jp.quadro.mashup.twitter.data.TweetData;

	/**
	 * イベントクラス
	 * @author aso
	 * @version 0.1
	 */
	public class TwitterEvent extends Event
	{
		public static const CHANGE:String = "nextTweetData";
		
		private var _tweet:TweetData;
		
		/**
		 * コンストラクタ
		 * @param	type
		 * @param	bubbles
		 * @param	cancelable
		 * @return
		 */
		public function TwitterEvent( type:String, tweet:TweetData, bubbles:Boolean = false, cancelable:Boolean = false ):void
		{
			super( type, bubbles, cancelable );
			_tweet = tweet;
		}
		
		/**
		 * タイムラインデータの取得
		 * @return
		 */
		public function get tweetData():TweetData
		{
			return _tweet;
		}
	}
}
