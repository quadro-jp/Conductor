package jp.quadro.commands
{
	import flash.utils.Timer;
	import flash.events.TimerEvent;
	
	/**
	 * 「指定したミリ秒待機する」コマンド.
	 * 
	 * <p>SerialCommandやParallelCommand等のバッチ処理系のコマンドにインターバルを挟む為に用います。</p>
	 * 
	  * @bdff 以下はWaitCommandクラスの基本的な使い方です。この例では関数executeを実行して1秒後に、Event.COMPLETEが発行されます。
	 * <listing version="3.0">
	 * var command:ICommand = new WaitCommand(1000);
	 * command.addEventListener(Event.COMPLETE, function():void{
	 * 		trace("Command Completed");
	 * });
	 * CommandContainer.execute( command );</listing>
	 * 
	 * @bdff この例ではSerialCommandを用いて１秒待った後に文字列を表示しています。
	 * <listing version="3.0">
	 * var serial:SerialCommand = new SerialCommand();
	 * serial.push( new WaitCommand( 1000 ));
	 * serial.push( new Command( null, trace, "Hello World" );
	 * 
	 * CommandContainer.execute( serial );</listing>
	 * 
	 * @see commands.SerialCommand
	 * @see commands.ParallelCommand
	 * @see commands.CommandContainer
	 */
	public class WaitCommand extends CommandBase
	{
		protected var _timer:Timer
		protected var _delay:Number
		
		/**
		 * 「指定したミリ秒だけ待つ」コマンド。
		 * 
		 * @param 待ち時間のミリ秒。
		 */
		public function WaitCommand( delay:Number = 1000)
		{
			super();
			_delay = delay
		}
		
		
		override public function execute():void
		{
			_timer = new Timer(_delay, 1);
			_timer.addEventListener(TimerEvent.TIMER_COMPLETE, executeCompleteHandler);
			_timer.start();
		}
		
		
		protected function executeCompleteHandler(e:TimerEvent):void
		{
			_timer.removeEventListener(TimerEvent.TIMER_COMPLETE, executeCompleteHandler );
			_timer.stop();
			_timer = null;
			dispatchComplete();
		}
	}
}