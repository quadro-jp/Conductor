package jp.quadro.mashup.twitter.net
{
	import flash.display.*;
	import flash.events.*;
	import flash.net.*;
	import flash.text.*;
	import flash.utils.*;
	import jp.quadro.display.*;
	import jp.quadro.mashup.twitter.data.*;
	import jp.quadro.mashup.twitter.events.*;
	import jp.quadro.mashup.twitter.net.*;
	
	/**
	 * API接続クラス
	 * @author aso
	 * @version 0.1
	 */
	public class TwitterWebService extends EventDispatcher
	{
		private static var _instance:TwitterWebService;
		private var _api:API;
		private var _tweetDataCollection:TweetDataCollection;
		private var _isStarted:Boolean = false;
		private var _myTweet:TweetData;
		private var timer:Timer;
		private var iterator:Iterator;
		
		private var settings:Settings;
		private var _count:uint;
		
		/**
		 * コンストラクタ
		 * @param	email メールアドレス
		 * @param	password パスワード
		 */ 
		public function TwitterWebService(enforcer:SingletonEnforcer)
		{
			trace('■　TwitterWebServiceのインスタンスを生成しました。');
			
			settings = Settings.getInstance();
			_api = new API('', '');
			_count = 0
		}
		
		public static function getInstance():TwitterWebService
		{
			if (TwitterWebService._instance == null)
			{
				TwitterWebService._instance = new TwitterWebService(new SingletonEnforcer());
			}
			
			return TwitterWebService._instance;	
		}
		
		/**
		 * TwitterWebServiceを開始します。
		 * @return
		 */
		public function start():void
		{ 
			if (!_isStarted)
			{
				trace('■　TwitterWebServiceを開始します。');
				trace('■　タイムラインを取得中です。');
				
				_isStarted = true;
				
				getTimeLine();
				
			}else {
				trace('■　TwitterWebServiceは開始済みです。');
			}
		}
		
		/**
		 * TwitterWebServiceを停止します。
		 * @return
		 */
		public function stop():void
		{
			try 
			{
				if (timer)
				{
					trace('■　TwitterWebServiceを停止します。');
					_isStarted = false;
					timer.stop();
				}
			}catch (err:Error) { }
		}
		
		public function insert(data:TweetData):void
		{
			trace('■　ユーザーのつぶやきを挿入しました。');
			_myTweet = data;
		}
		
		/**
		 * タイムラインを更新します。
		 * @return
		 */
		public function update(e:Event):void
		{
			trace('□　タイムラインを更新中です。');
			timer.stop();
			_api.getTimeLine();
			_api.addEventListener(TimeLineLoadEvent.COMPLETE, timeLineLoadCompleteHandler);
		}
		
		private function getTimeLine():void
		{
			_api.getTimeLine();
			_api.addEventListener(TimeLineLoadEvent.COMPLETE, timeLineLoadCompleteHandler);
		}
		
		private function timeLineLoadCompleteHandler(e:TimeLineLoadEvent):void 
		{
			trace('■　タイムラインを正常に取得しました。');
			_count = 0;
			_api.removeEventListener(TimeLineLoadEvent.COMPLETE, timeLineLoadCompleteHandler);
			_tweetDataCollection = new TweetDataCollection();
			
			var xml:XML = e.xml;
			default xml namespace = settings.NAME_SPACE;
			
			var entries:XMLList = xml.entry;
			var i:uint;
			var n:uint = entries.length();
			
			for ( i = 0; i < n; i++ )
			{
				_tweetDataCollection.addElement( new TweetData(
					entries[i].author.name,
					entries[i].author.uri,
					entries[i].link.(@type=='image/png').@href,
					entries[i].link.(@type=='text/html').@href,
					entries[i].content
				));
			}
			
			iterator = _tweetDataCollection.iterator() as Iterator;
			
			trace('■　つぶやきデータをコレクションに追加しました。');
			
			trace('■　つぶやきデータの配信を開始します。');
			
			if (timer == null) timer = new Timer(settings.duration);
			
			timer.start();
			timer.addEventListener(TimerEvent.TIMER, next);
			
			dispatchEvent(new TimeLineLoadEvent(TimeLineLoadEvent.COMPLETE, null));
			next(null);
		}
		
		private function next(e:TimerEvent):void 
		{
			var tweetData:TweetData;
				
			if (_myTweet != null)
			{
				trace('■　ユーザーのつぶやきがあります。');
				tweetData = _myTweet;
				_myTweet = null;
			}
			else
			{
				if (iterator.hasNext())
				{
					tweetData = iterator.next() as TweetData;
					dispatchEvent(new TwitterEvent(TwitterEvent.CHANGE, tweetData));
				}
				else
				{
					if (++_count < Settings.getInstance().retry)
					{
						trace('■　タイムラインを再取得中です。', _count, '回目');
						
						if (timer)
						{
							timer.stop();
							iterator.reset();
							getTimeLine();
						}
					} else {
						trace('■　タイムラインの取得を中止しました。');
						timer.stop();
						iterator.reset();
					}
				}
			}
		}
		
		public function get myTween():TweetData { return _myTweet; }
		public function set myTween(value:TweetData):void { _myTweet = value; }
	}
}

class SingletonEnforcer {}