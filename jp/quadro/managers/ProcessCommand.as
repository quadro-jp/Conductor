package jp.quadro.managers
{
	import flash.events.Event;
	import jp.quadro.commands.BatchCommand;
	import jp.quadro.commands.ICommand;
	import jp.quadro.managers.SceneManager;
	import jp.quadro.events.SceneEvent;
	
	public class ProcessCommand extends BatchCommand
	{
		private var _isProcessStart:Boolean;
		private var _isProcessStop:Boolean;
		
		public function ProcessCommand(commandArray:Array = null)
		{
			super(commandArray);
		}
		
		override public function execute():void
		{
			SceneManager.getInstance().addEventListener(SceneEvent.CHANGE, sceneEventHandler);
			
			if (_isProcessStop) {
				cancel();
				return;
			}
			
			if (!_isProcessStart) _isProcessStart = true;
			
			if (_commands.length == 0)
			{
				SceneManager.getInstance().next();
				return;
			}
			
			_index == _commands.length ? dispatchComplete(): next();
		}
		
		override public function cancel():void
		{
			_commands = null;
			
			dispatchEvent(new Event(Event.CANCEL));
		}
		
		protected function next():void
		{
			if (_isProcessStop) {
				cancel();
				return;
			}
			
			var c:ICommand = _commands[ _index ];
			c.addEventListener(Event.COMPLETE, nextCompleteHandler);
			c.execute();
		}
		
		protected function nextCompleteHandler( e:Event ):void
		{
			if (_isProcessStop) {
				e.target.removeEventListener(e.type, arguments.callee);
				cancel();
				return;
			}
			
			e.target.removeEventListener(e.type, arguments.callee);
			_index++;
			
			if (_index == _commands.length)
			{
				//trace("     ---> ProcessCommand nextCompleteHandler end::", "終了", _index, " / ", _commands.length);
				if (!_isProcessStop) {
					SceneManager.getInstance().next();
					dispatchComplete();
				return;
			}
			}else {
				//trace("     ---> ProcessCommand nextCompleteHandler next::", "残り", _index, " / ", _commands.length);
				next();
			}
		}
		
		private function sceneEventHandler(e:SceneEvent):void 
		{
			SceneManager.getInstance().removeEventListener(SceneEvent.CHANGE, sceneEventHandler);
			_isProcessStop = true;
		}
	}
}