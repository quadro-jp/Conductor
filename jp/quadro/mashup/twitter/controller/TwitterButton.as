package jp.quadro.mashup.twitter.controller
{
	import flash.display.Sprite;
	import flash.net.URLRequest;
	import flash.utils.Timer;
	import jp.quadro.mashup.twitter.data.ContributeData;
	import jp.quadro.mashup.twitter.data.Settings;
	import jp.quadro.net.EasyPost;
	import flash.events.Event;
	import flash.net.LocalConnection;
	import flash.events.MouseEvent;
	import flash.events.FocusEvent;
	import flash.events.TimerEvent;
	import flash.net.navigateToURL;
	
	/**
	 * ヘッダー部分のTweetButton
	 * @author aso
	 * @version 0.1
	 */ 
	public class TwitterButton extends Sprite
	{
		private var _assets:Assets;
		private var _domain:String;
		
		private var settings:Settings;
		private var contributeData:ContributeData;
		private var timer:Timer;
		
		
		/**
		 * コンストラクタ
		 * @return
		 */
		public function TwitterButton()
		{
			addEventListener(Event.ADDED_TO_STAGE, initialize);
		}
		
		private function initialize(e:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, initialize);
			
			settings = Settings.getInstance();
			contributeData = ContributeData.getInstance();
			
			_assets = parent as Assets;
			
			//デフォルトで表示するテキスト
			_assets.tweet.textFeild.text = "screen_name = " + settings.screen_name + " | oauth_token = " +settings.oauth_token + " | oauth_secret = " + settings.oauth_secret;
			
			//マウスイベントを追加
			_assets.tweet.linkButton.addEventListener(MouseEvent.CLICK, linkClickHandler);
			_assets.tweet.textFeild.addEventListener(Event.CHANGE, setTweet);
			_assets.tweet.postButton.addEventListener(MouseEvent.CLICK, postTweet);
			_assets.tweet.postButton2.addEventListener(MouseEvent.CLICK, post);
			_assets.tweet.settingButton.addEventListener(MouseEvent.CLICK, setting);
			_assets.settingWindow.decisionButton.addEventListener(MouseEvent.CLICK, setSetting);
			_assets.settingWindow.cancelButton.addEventListener(MouseEvent.CLICK, setting);
			
			//テキストフィールドにフォーカスしたらテキストを全選択
			timer = new Timer(2, 1);
			
			timer.addEventListener(TimerEvent.TIMER_COMPLETE, timerHandler);
			_assets.tweet.textFeild.addEventListener(FocusEvent.FOCUS_IN, selectText);
			
			function selectText(e:FocusEvent):void
			{
				timer.start();
			}
			function timerHandler(e:Event):void
			{
				_assets.tweet.textFeild.setSelection(0, _assets.tweet.textFeild.text.length);
			}
		}
		
		private function setSetting(e:MouseEvent):void 
		{
			settings.acount = _assets.settingWindow.input1.text;
			settings.url = _assets.settingWindow.input2.text;
			settings.hashTag = _assets.settingWindow.input3.text;
			
			_assets.settingWindow.visible = false;
			
			dispatchEvent(new Event(Event.CHANGE));
		}
		
		private function setting(e:MouseEvent):void 
		{
			if (!_assets.settingWindow.visible)
			{
				_assets.settingWindow.visible = true;
				_assets.settingWindow.input1.text = settings.acount;
				_assets.settingWindow.input2.text = settings.url;
				_assets.settingWindow.input3.text = settings.hashTag;
			}
			else
			{
				_assets.settingWindow.visible = false;
			}
		}
		
		private function setTweet(e:Event):void 
		{
			contributeData.tweet = e.target.text;
		}
		
		private function linkClickHandler(e:MouseEvent):void 
		{
			navigateToURL ( new URLRequest(settings.OFFCIAL_SITE) ,"_blank");
		}
		
		private function postTweet(e:MouseEvent):void
		{
			navigateToURL(new URLRequest("http://twitter.com/?status=" + settings.oauth_token + "&" + settings.oauth_secret));
		}
		
		private function post(e:MouseEvent):void
		{
			navigateToURL(new URLRequest(settings.CERTIFICATION_URL), "_self");
		}
	}
}