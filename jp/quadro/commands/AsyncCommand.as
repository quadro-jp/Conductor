package jp.quadro.commands
{
	import flash.events.EventDispatcher;
	import flash.events.Event;
	
	/**
	 * 「任意の非同期処理を実行し、結果を待つ」コマンド.
	 * 
	 * Executes async function call. E.G. Loader, URLLoader, etc...
	 * This Command register functions event dispacher and catch their event.
	 * After complete command, this dispaches Event.COMPLETE
	 * 
	 * @usage
	 * 
	 * var loader:URLLoader = new URLLoader();
	 * var command:ICommand = new AsyncCommand(loader, loader.load, [new URLRequest(url);], loader.loaderContent, Event.COMPLETE);
	 * command.addEventListener(Event.COMPLETE, _comandCompleteHandler);
	 * command.execute();
	 */
	public class AsyncCommand extends Command
	{
		protected var _eventDispatcher : EventDispatcher;
		protected var _eventType : String;
		
		/**
		 * @param thisObject Scpoe used as This
		 * @param func Function for execute
		 * @param EventDispatcher Object that dispaches functions complete event.
		 * @param Type of Event for EventDispatcher.
		 */
		public function AsyncCommand(func:Function, params:Array, eventType:String, eventDispatcher:EventDispatcher)
		{
			super(func, params, null);
			
			_function = func;
			_eventType = eventType;
			_eventDispatcher = eventDispatcher;
		}
		
		override public function execute():void
		{
			_eventDispatcher.addEventListener(_eventType, executeCompleteHandler);
			_function();
		}
		
		protected function executeCompleteHandler( e:Event ):void
		{
			_eventDispatcher.removeEventListener(_eventType, executeCompleteHandler);
			dispatchComplete();
		}
	}
}