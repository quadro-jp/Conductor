package jp.quadro.managers 
{
	import flash.errors.IllegalOperationError;
	import flash.events.EventDispatcher;
	import jp.quadro.events.NotifyEvent;
	import jp.quadro.notify.Intent;
	
	/**
	 * ...
	 * @author aso
	 */
	public class NotificationManager extends EventDispatcher
	{
		private static var _instance:NotificationManager;
		
		public function NotificationManager(enforcer:SingletonEnforcer)
		{
			if (enforcer == null) throw new IllegalOperationError("NotificationManagerはインスタンスか出来ません。");
		}
		
		public static function getInstance():NotificationManager
		{
			if (NotificationManager._instance == null)
			{
				NotificationManager._instance = new NotificationManager(new SingletonEnforcer());
			}
			
			return NotificationManager._instance;
		}
		
		public function invoke(intent:Intent):void
		{
			dispatchEvent(new NotifyEvent(NotifyEvent.INVOKE, intent));
		}
	}
}