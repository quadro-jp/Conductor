package jp.quadro.managers
{
	import flash.errors.IllegalOperationError;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import jp.quadro.managers.Settings;
	
	/**
	 * ...
	 * @author aso
	 */
	public class LogManager extends EventDispatcher
	{
		private var _appendLog:String = "";
		private var _log:String = "";
		private static var _instance:LogManager;
		
		public function LogManager(enforcer:SingletonEnforcer)
		{
			if (enforcer == null) throw new IllegalOperationError("LogManagerはインスタンスか出来ません。");
		}
		
		public static function getInstance():LogManager
		{
			if (LogManager._instance == null)
			{
				LogManager._instance = new LogManager(new SingletonEnforcer());
			}
			
			return LogManager._instance;
		}
		
		public function add(...rest):void
		{
			if (Settings.debug)
			{
				var tmp:String = "";
				var str:String;
				
				for each (str in rest) 
				{
					tmp += str;
				}
				_log += tmp + "\n";
				_appendLog = tmp + "\n";
				
				trace(_appendLog);
				dispatchEvent(new Event(Event.CHANGE));
			}
		}
		
		public function get log():String { return _log; }
		public function get appendLog():String { return _appendLog; }
	}
}