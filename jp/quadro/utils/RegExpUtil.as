package jp.quadro.utils 
{
	/**
	* ハッシュタグを除去
	* @author aso
	* @version 0.1
	*/
		
	public class RegExpUtil
	{
		/**
		* コンストラクタ.
		* @param
		* @return
		*/
		public function RegExpUtil() 
		{
			throw new Error("RegExpUtil クラスは静的クラスのためインスタンス化できません.");
		}
		
		public static function deleteHasgTag(string:String):String
		{
			var str:String = string.replace(/\#.*/g, "");
			return str;
		}
		
		public static function getNumericCharacter(string:String):String
		{
			var pattern:RegExp = new RegExp(/(\d*\d)/g);
			var result:Array = pattern.exec(string);
			return result != null ? result[0] : string;
		}
	}
}