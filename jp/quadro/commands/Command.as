package jp.quadro.commands
{
	/**
	 * 「任意の関数を実行する」コマンド.
	 * 
	 * <p>Commandクラスを用いることで、「関数の呼び出し」という行為を変数としてやりとりするが可能となります。</p>
	 * 
	 * @bdff 以下はCommandクラスの基本的な使い方です。この例では"Hello Command"という文字列を表示するCommandを作成し、実行しています。
	 * <listing version="3.0">
	 * var command:Command = new Command(null, trace, ["Hello Command"]);
	 * command.execute();
	 * 
	 * //Outputs
	 * //Hello Command</listing>
	 * 
	 */
	public class Command extends CommandBase
	{
		//このthisObjectはクロージャのthisスコープをコントロールする為に、一応のこしておく。
		protected var _thisObject : Object;
		protected var _function : Function;
		protected var _params : Array;
		
		/**
		 * 関数execute()実行時に行いたい処理を登録します。
		 * 
		 * @param thisObject Thisとして使用されるスコープです。基本的にnullで問題ありません。クロージャおよびAS2との互換性の為に存在しています。
		 * @param func:Function 登録したい関数の参照。
		 * @param params:Array 関数実行時に渡されるパラメーター
		 */
		public function Command(func:Function, params:Array = null, thisObject:Object = null)
		{
			super();
			_function = func;
			_params = params;
			_thisObject = thisObject;
		}
		
		
		
		/**
		 * コンストラクタで登録した処理を実行します。
		 * 
		 * @eventType Event.COMPLETE
		 */
		override public function execute():void
		{
			_function.apply(_thisObject, _params); 
			this.dispatchComplete();
		}
	}
}