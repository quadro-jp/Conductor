package jp.quadro.mashup.twitter.data
{
	/**
	 * つぶやきデータクラス
	 * @author aso
	 * @version 0.1
	 */
	public class TweetData extends Object
	{
		private var _name:String;
		private var _uri:String;
		private var _icon:String;
		private var _link:String;
		private var _title:String;
		private var _message:String;
		
		/**
		 * コンストラクタ.
		 * @param	name 投稿者のスクリーンネーム
		 * @param	uri 投稿者のURI
		 * @param	icon 投稿者のアイコン
		 * @param	link リンク先
		 * @param	message 本文
		 */
		public function TweetData( name:String, uri:String, icon:String, link:String, message:String )
		{
			_name = name;
			_uri = uri;
			_icon = icon;
			_link = link;
			_message = message;
		}
		
		public function get name():String { return _name; }
		public function get uri():String { return _uri; }
		public function get icon():String { return _icon; }
		public function get link():String { return _link; }
		public function get message():String { return _message; }
	}
}
