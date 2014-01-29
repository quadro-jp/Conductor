package jp.quadro.mashup.twitter.controller
{
	import flash.display.*;
	import flash.events.*;
	import flash.net.*;
	import flash.text.*;
	import flash.utils.*;
	import jp.quadro.loader.*;
	import jp.quadro.mashup.twitter.data.*;
	import jp.quadro.mashup.twitter.events.TwitterPostEvent;
	import jp.quadro.mashup.twitter.net.TwitterWebService;
	import jp.quadro.net.EasyPost;
	
	/**
	 * 投稿ボタン
	 * @author aso
	 * @version 0.1
	 */ 
	public class ContributeTweetButton extends Sprite
	{
		private var twitter:TwitterWebService;
		private var settings:Settings;
		private var contributeData:ContributeData;
		
		/**
		 * コンストラクタ
		 * @return
		 */
		public function ContributeTweetButton()
		{
			twitter = TwitterWebService.getInstance();
			settings = Settings.getInstance();
			contributeData = ContributeData.getInstance();
			
			//デフォルトで表示するテキスト
			textFeild.text = contributeData.tweet;
			
			//マウスイベントを追加
			postButton.alpha = 0.25;
			textFeild.addEventListener(Event.CHANGE, setTweet);
			
			//テキストフィールドにフォーカスしたらテキストを全選択
			var timer:Timer = new Timer(2, 1);
			
			timer.addEventListener(TimerEvent.TIMER_COMPLETE, timerHandler);
			textFeild.addEventListener(FocusEvent.FOCUS_IN, selectText);
			
			function selectText(e:FocusEvent):void
			{
				timer.start();
			}
			function timerHandler(e:Event):void
			{
				textFeild.setSelection(0, textFeild.text.length);
			}
		}
		
		private function setTweet(e:Event):void 
		{
			contributeData.tweet = e.target.text;
			
			if (contributeData.tweet == "" || contributeData.tweet == "投稿しました。")
			{
				postButton.alpha = 0.25;
				postButton.removeEventListener(MouseEvent.CLICK, postTweet);
			}
			else
			{
				postButton.alpha = 1.0;
				postButton.addEventListener(MouseEvent.CLICK, postTweet);
			}
		}
		
		private function postTweet(e:MouseEvent):void
		{
			postButton.alpha = 0.25;
			postButton.removeEventListener(MouseEvent.CLICK, postTweet);
			
			textFeild.text = "";
			
			var easyPost:EasyPost = new EasyPost(settings.PHP_URL, { tweet:createTweet(), oauth_token:settings.oauth_token, oauth_secret:settings.oauth_secret } );
			easyPost.addEventListener(TwitterPostEvent.COMPLETE, onPostComplete);
		}
		
		private function createTweet():String
		{
			var str:String = settings.acount;
			str += " " + contributeData.tweet;
			if (settings.url != "") str += " " + settings.url;
			if (contributeData.contribute != "") str += " #" + contributeData.contribute;
			if (settings.hashTag != "") str += " " + settings.hashTag;
			
			return str;
		}
		
		private function onPostComplete(e:TwitterPostEvent):void
		{
			e.target.removeEventListener(Event.COMPLETE, onPostComplete);
			
			textFeild.text = e.getStatusMessage();
			
			twitter.insert( new TweetData(
				settings.screen_name,
				"ユーザーのTwitterホーム",
				"twitter_normal.png",
				"なにかしらのリンク",
				createTweet()
			));
		}
		
		private function removeWindow(e:MouseEvent):void 
		{
			e.target.removeEventListener(MouseEvent.ROLL_OUT, removeWindow);
			parent.removeChild(e.target as DisplayObject);
		}
	}
}