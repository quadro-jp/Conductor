package jp.quadro.mashup.twitter.events
{
	import flash.events.Event;

	/**
	 * イベントクラス
	 * @author aso
	 * @version 0.1
	 */
	public class TwitterPostEvent extends Event
	{
		public static const COMPLETE:String = "complete";
		
		private var _code:int;
		private var _error:String;
		
		/**
		 * コンストラクタ
		 * @param	type
		 * @param	bubbles
		 * @param	cancelable
		 * @return
		 */
		public function TwitterPostEvent( type:String, code:int, error:String = "", bubbles:Boolean = false, cancelable:Boolean = false ):void
		{
			super( type, bubbles, cancelable );
			_code = code;
			_error = error;
		}
		
		public function getStatusMessage ():String
		{
			var message:String;
			
			switch (_code) 
			{
				case 200:
					message = "投稿が完了しました。";
				break;
				
				case 304:
					message = "新しい情報はありません。";
				break;
				
				case 400:
					message = "APIの実行回数制限に達しました。";
				break;
				
				case 401:
					message = "認証失敗に失敗しました。";
				break;
				
				case 403:
					message = "権限がないAPIを実行しようとしました。";
				break;
				
				case 500:
					message = "Twitter側で何らかの問題が発生しています。";
				break;
				
				case 502:
					message = "Twitterのサーバが停止しています。";
				break;
				
				case 503:
					message = "Twitterのサーバの混雑しています。";
				break;
			}
			
			return message;
		}
		
		public function get code():int { return _code; }
		
		public function get error():String { return _error; }
	}
}
