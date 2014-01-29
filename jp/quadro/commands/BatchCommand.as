package jp.quadro.commands
{
	import flash.events.EventDispatcher;
	
	/**
	 * ParallelCommand と SerialCommand のベースとなる抽象クラス.
	 * 
	 * <p>このクラスが実際にインスタンス化されることはありません。</p>
	 * 
	 * @see commands.ParallelCommand
	 * @see commands.SerialCommamd
	 */
	public class BatchCommand extends CommandBase
	{
		protected var _commands:Array
		protected var _index:Number
		
		public function BatchCommand( commandArray:Array = null )
		{
			super();
			
			_index = 0;
			_commands = (commandArray == null)? [] : commandArray.concat();
		}
		
		
		/**
		 * ICommandインターフェースを実装したコマンドを処理に追加します。
		 * @param com ICommandインターフェースを実装したコマンド。
		 */
		public function push(com:ICommand):BatchCommand
		{
			_commands.push(com);
			return this;
		}
		
		
		/**
		 * Commandインスタンスを作成し処理に追加するショートカット関数。
		 */
		public function pushCommand(func:Function, params:Array = null, thisObject:Object = null):BatchCommand
		{
			push(new Command(func, params, thisObject));
			
			return this;
		}
		
		
		/**
		 * WaitCommandインスタンスを作成し処理に追加するショートカット関数。
		 */
		public function pushWait( delay:Number ):BatchCommand
		{
			push(new WaitCommand(delay));
			return this;
		}
		
		
		/**
		 * SerialCommandインスタンスを作成し処理に追加するショートカット関数。
		 */
		public function pushSerial( commands:Array = null ):BatchCommand
		{
			push(new SerialCommand(commands));
			return this;
		}
		
		
		/**
		 * ParallelCommandインスタンスを作成し処理に追加するショートカット関数。
		 */
		public function pushParallel( commands:Array = null ):BatchCommand
		{
			push(new ParallelCommand(commands));
			return this
		}
		
		public function pushAsync(func:Function, params:Array, eventDispatcher:EventDispatcher, eventType:String):BatchCommand
		{
			push(new AsyncCommand(func, params, eventType, eventDispatcher));
			return this;
		}
		
		/**
		 * FrameWaitCommandインスタンスを作成し処理に追加するショートカット。
		 */
		public function pushFrameWait(frameNum:int):BatchCommand
		{
			push(new FrameWaitCommand(frameNum));
			return this;
		}
		
		public function get numCommand():uint { return _commands.length; }
	}
}