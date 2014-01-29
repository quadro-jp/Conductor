package jp.quadro.mashup.twitter.net
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLVariables;
	import jp.quadro.mashup.twitter.data.*;
	import jp.quadro.mashup.twitter.events.*;
	
	/**
	 * API接続クラス
	 * @author aso
	 * @version 0.1
	 */ 
	public class API extends EventDispatcher
	{
		// WEBサービスURL
		private static const API_URL:String = "http://search.twitter.com";
		
		// 検索URL
		private static const SEARCH_URL:String = "/search.atom?q=";
		
		// アクセスキー
		private var _email:String;
		
		// WEBサービスのバージョン
		private var _password:String;
		
		/**
		 * コンストラクタ
		 * @param	email メールアドレス
		 * @param	password パスワード
		 */ 
		public function API( email:String, password:String)
		{
			setEmailAdress( email );
			setPassword(password);
		}
		
		/**
		 * メールアドレスを設定
		 * @param	email　メールアドレス
		 * @return	
		 */ 
		public function setEmailAdress( email:String ):void
		{
			_email = email;
		}
		
		/**
		 * メールアドレスを取得
		 * @return	String
		 */ 
		public function getEmailAdress():String
		{
			return _email;
		}
		
		/**
		 * パスワードを設定
		 * @param	version パスワード
		 * @return	
		 */ 
		public function setPassword( password:String ):void
		{
			_password = password;
		}
		
		/**
		 * パスワードを取得
		 * @return	String
		 */ 
		public function getPassword():String
		{
			return _password;
		}
		
		/**
		 * ユーザーを検索する
		 * @param	param
		 * @return	
		 */ 
		public function getTimeLine ():void
		{
			// URLRequest を作成
			var str:String = Settings.getInstance().word + '&lang=' + Settings.getInstance().lang;
			var request:URLRequest = new URLRequest( encodeURI(API_URL + SEARCH_URL + str));
			
			// 検索の開始
			load( request , timeLineLoadComplete );
		}
		
		/**
		 * URLLoaderを発行し、読み込み処理を行う
		 * @param	e
		 * @return
		 */ 
		private function timeLineLoadComplete(e:Event):void
		{
			dispatchEvent( new TimeLineLoadEvent( TimeLineLoadEvent.COMPLETE, XML( e.target.data )) );
		}
		
		/**
		 * URLLoaderを発行し、読み込み処理を行う
		 * @param	url
		 * @param	completeFunction
		 * @return
		 */ 
		private function load( url:URLRequest, onCompleteHandler:Function ):void
		{
			var loader:URLLoader = new URLLoader();
			loader.addEventListener( Event.COMPLETE, onCompleteHandler );
            loader.addEventListener( IOErrorEvent.IO_ERROR  , onIOError );
            loader.addEventListener( SecurityErrorEvent.SECURITY_ERROR , onSecurityError );
			loader.load( url );
		}
		
		/**
		 * IOエラー発生時の処理
		 * @param	e
		 */ 
		private function onIOError( e:IOErrorEvent ):void
		{
			var errorCode:String = "100";
			var dataIOErrorEvent:DataIOErrorEvent = new DataIOErrorEvent( DataIOErrorEvent.IO_ERROR );
			dataIOErrorEvent.errorCode = errorCode;
			dataIOErrorEvent.MessageDisplay = _getMessageDisplay( errorCode );
			dataIOErrorEvent.errorContent = getErrorContent( errorCode );
			dispatchEvent( dataIOErrorEvent );
		}
		
		/**
		 * セキュリティエラー発生時の処理
		 * @param	e
		 */ 
		private function onSecurityError( e:SecurityErrorEvent ):void
		{
			var errorCode:String = "200";
			var dataIOErrorEvent:DataIOErrorEvent = new DataIOErrorEvent( SecurityErrorEvent.SECURITY_ERROR );
			dataIOErrorEvent.errorCode = errorCode;
			dataIOErrorEvent.MessageDisplay = _getMessageDisplay( errorCode );
			dataIOErrorEvent.errorContent = getErrorContent( errorCode );
			dispatchEvent( dataIOErrorEvent );
		}
		
		/* ---------------------------------------------------------------------------  */ 
		
		/**
		 * IOエラーイベントを dispatch する
		 * @param	errorCode
		 * @param	errorEventType
		 * @return
		 */ 
		private function dispatchErrorEvent( errorCode:String, errorEventType:String ):void
		{
			var dataIOErrorEvent:InternalDataIOErrorEvent = new InternalDataIOErrorEvent( errorEventType );
			dataIOErrorEvent.setErrorCode( errorCode );
			dataIOErrorEvent.setMessageDisplay( _getMessageDisplay( errorCode ) );
			dataIOErrorEvent.setErrorContent( getErrorContent( errorCode ) );
			dispatchEvent( dataIOErrorEvent );
		}
		
		/* ---------------------------------------------------------------------------  */ 
		/**
		 * エラーコードであるかを判定する.
		 * @param	code
		 * @return
		 */ 
		private function isErrorCode( code:String ):Boolean
		{
			return ( 200 <= Number( code ) ) ? true : false;
		}
		
		/**
		 * エラーコードを元にエラーメッセージを取得する.
		 * @param	code
		 * @return
		 */ 
		private function _getMessageDisplay( code:String ):String
		{
			switch( code ){
				case "100" :
					return "IOErrorEvent.IO_ERROR";
				case "200" :
					return "SecurityErrorEvent.SECURITY_ERROR";
				default :
					return "";
			}
		}
		
		/**
		 * エラーコードを元にエラー内容を取得する.
		 * @param	code
		 * @return
		 */ 
		private function getErrorContent( code:String ):String
		{
			switch( code )
			{
				case "100" :
					return "XMLの取得に失敗しました.";
				case "200" :
					return "セキュリティ上の問題により通信に失敗しました.";
				default :
					return ""
			}
		}
	}
}