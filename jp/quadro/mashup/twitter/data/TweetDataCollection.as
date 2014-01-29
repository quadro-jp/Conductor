package jp.quadro.mashup.twitter.data
{
	/**
	 * つぶやきデータコレクションクラス
	 * @author aso
	 * @version 0.1
	 */
	public class TweetDataCollection implements ICollection
	{
		// つぶやきデータを保持する配列
		private var _data:Array;
		
		/**
		 * コンストラクタ
		 * @param
		 */
		public function TweetDataCollection()
		{
			_data = [];
		}
		
		/**
		 * コレクションを操作するイテレーターを取得する
		 * @param
		 * @return
		 */
		public function iterator():IIterator
		{
			_data.reverse();
			
			return new Iterator(_data);
		}
		
		/**
		 * コレクションにエレメントを追加する
		 * @param
		 * @return
		 */
		public function addElement(value:TweetData):void
		{
			_data.push(value);
		}
	}
}
