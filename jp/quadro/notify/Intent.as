package jp.quadro.notify 
{
	
	/**
	 * ...
	 * @author quadro
	 */
	public class Intent 
	{
		private var _message:String;
		
		public function Intent(message:String) 
		{
			_message = message;
		}
		
		public function getIntent():Object
		{
			return { message:_message };
		}
		
		public function get message():String 
		{
			return _message;
		}
		
		public function set message(value:String):void 
		{
			_message = value;
		}
	}
}