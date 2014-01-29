package jp.quadro.mashup.twitter.net
{
	import jp.quadro.mashup.twitter.events.DataIOErrorEvent;
	
	/**
	* XML読み込み用エラーイベントクラス
	* @author Hirofumi Kawakita
	* @version 0.1
	*/
	internal class InternalDataIOErrorEvent extends DataIOErrorEvent{
		
		// ----- CONST ---------------------------------------------------------------------
		// ----- MEMBER --------------------------------------------------------------------
		// ----- PUBLIC --------------------------------------------------------------------
		/**
		* コンストラクタ.
		* @param	type
		* @param	bubbles
		* @param	cancelable
		* @return
		*/
		public function InternalDataIOErrorEvent( type:String, bubbles:Boolean = false, cancelable:Boolean = false ):void{
			super( type, bubbles, cancelable );
		}
		
		// ----- PRIVATE -------------------------------------------------------------------
		// ----- PROTECTED------------------------------------------------------------------
		// ----- INTERNAL ------------------------------------------------------------------
		/** エラーコード. */
		internal function setErrorCode( code:String ):void{
			_errorCode = code;
		}
		
		/** エラーメッセージ. */
		internal function setMessageDisplay( message:String ):void{
			_MessageDisplay = message;
		}
		
		/** エラー内容. */
		internal function setErrorContent( content:String ):void{
			_errorContent = content;
		}
		
	}
	
}
