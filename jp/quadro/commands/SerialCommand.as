﻿package jp.quadro.commands
{
	import flash.events.Event;
	
	/**
	 * 「全ての子コマンドを１つづつ実行・終了する」コマンド.
	 * 
	 * <p>登録された複数のコマンドを１つづつ順番に実行、終了させていきます。
	 * 最後のコマンドの終了時にEvent.COMPLETEを発行します。</p>
	 * 
	 * <p>SerialCommandインスタンスは1回だけの使用を前提とし、再利用は考慮されていません。
	 * 同じ処理を繰り返して行いたい場合には、処理の度に新しいSerialCommandインスタンスを作成してください。</p>
	 * 
	 * @bdff 以下のコードは、hello と表示し、1秒後に world と表示します。
	 * <listing version="3.0">
	 * var ar : Array = [
	 * 		new Command("hello"),
	 * 		new WaitCommand(1000),
	 * 		new Command("world")];
	 * 
	 * var sCom : SerialCommand = new SerialCommand( ar );
	 * sCom.addEventListener(Event.COMPLETE, _commandExecuteHandler);
	 * 
	 * //ガベージコレクトされないよう、CommandContainerを用いて実行する。
	 * CommandContainer.execute(sCom);
	 * </listing>
	 * 
	 * @see commands.CommandContainer
	 */
	public class SerialCommand extends BatchCommand
	{
		/**
		 * @param comamndArray ICommandインターフェースを実装したコマンドの配列。
		 */
		public function SerialCommand( commandArray:Array = null)
		{
			super(commandArray);
		}
		
		
		override public function execute():void
		{
			_index == _commands.length ? dispatchComplete() : doNext();
		}
		
		
		//内部的に次のコマンドを実行
		protected function doNext():void
		{
			var c:ICommand = _commands[ _index ];
			c.addEventListener(Event.COMPLETE, doNextCompleteHandler);
			c.execute();
		}
		
		
		//子コマンドが終了したときのハンドラ
		protected function doNextCompleteHandler( e:Event ):void
		{
			e.target.removeEventListener(e.type, arguments.callee);
			
			_index++;
			
			if(_index == _commands.length ){
				this.dispatchComplete();
			}else{
				doNext();
			}		
		}
	}
}