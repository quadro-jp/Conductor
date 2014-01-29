package jp.quadro.utils
{
	import flash.geom.Point;
	
	public class MathUtil
	{
		private static const _PI:Number = Math.PI;
		private static var previousNumber:int = 0;
			
		/**
		 * @private
		 */
		public function MathUtil():void
		{
			throw new Error("MathUtil クラスは静的クラスのためインスタンス化できません.");
		}
		
		public static function zero(number:Number, min:Number, max:Number):Number
		{
			if (min > max)
			{
				var temp:Number = min;
				min = max;
				max = temp;
			}
				
			return (number > max) ? min : (number < min) ? max : number;
		}
		
		public static function abs(number:Number):Number
		{
			number = number < 0 ? -number : number;
			return number;
		}
		
		/**
		 * 0 か 1 の数値を返します.
		 *
		 * @return 0 か 1 の数値です.
		 */
		public static function coin():int
		{
			return int(Math.random() * 2);
		}
		
		/**
		 * true か false のBool値を返します.
		 *
		 * @return true か false のBool値です.
		 */
		public static function coin2():Boolean
		{
			var r:int = Math.random() * 2;
			
			return r == 1 ? true : false ;
		}
		
		/**
		 * 1 からダイスの面数までのランダムな数値を返します.
		 *
		 * @param faces ダイスの面数です.
		 * @return 1 から指定の数値までのランダムな数値です.
		 */
		public static function dice(faces:uint):uint
		{
			return int(Math.random() * faces + 1);
		}
		
		/**
		 * 指定範囲内のランダムな整数を返します.
		 *
		 * @param min 下限値です.
		 * @param max 上限値です.
		 * @return 指定範囲内のランダムな整数です.
		 */
		public static function randomInt(min:Number, max:Number):int
		{
			if (min > max) {
				var temp:Number = min;
				min = max;
				max = temp;
			}

			return int(Math.random() * (max - min + 1) + min);
		}

		/**
		 * 数値を指定の周期内に収めます.
		 *
		 * @param number 周期内に収める数値です.
		 * @return 変換後の数値です.
		 */
		public static function cycle(number:Number, min:Number, max:Number):Number
		{
			if (min > max) {
				var temp:Number = min;
				min = max;
				max = temp;
			}

			var cycle:Number = max - min;

			return (number < max)
				? (number - max) % cycle + max
				: (number - min) % cycle + min;
		}

		/**
		 * 数値を指定の範囲内に収めます.
		 *
		 * @param number 範囲内に収める数値です.
		 * @return 変換後の数値です.
		 */
		public static function range(number:Number, min:Number, max:Number):Number
		{
			if (min > max) {
				var temp:Number = min;
				min = max;
				max = temp;
			}

			return (number > max) ? max : (number < min) ? min : number;
		}

		/**
		 * 角度をラジアンに変換します.
		 *
		 * @param degrees ラジアンに変換したい角度です.
		 * @return 変換後のラジアンです.
		 */
		public static function degreeToRadian(degrees:Number):Number
		{
			return degrees * _PI / 180;
		}

		/**
		 * ラジアンを角度に変換します.
		 *
		 * @param radians 角度に変換したいラジアンです.
		 * @return 変換後の角度です.
		 */
		public static function radianToDegree(radians:Number):Number
		{
			return radians * 180 / _PI;
		}

		/**
		 * Point オブジェクト間の直線距離を求めます.
		 *
		 * @param point1 対象となる 1 つ目の Point オブジェクトです.
		 * @param point2 対象となる 2 つ目の Point オブジェクトです.
		 * @return Point オブジェクト間の直線距離です.
		 */
		public static function distanceBetweenPoints(point1:Point, point2:Point):Number
		{
			var x:Number = point2.x - point1.x;
			var y:Number = point2.y - point1.y;

			return Math.sqrt(x * x + y * y);
		}

		/**
		 * 座標間の直線距離を求めます.
		 *
		 * @param x1 対象となる 1 つ目の x 座標です.
		 * @param y1 対象となる 1 つ目の y 座標です.
		 * @param x2 対象となる 2 つ目の x 座標です.
		 * @param y2 対象となる 2 つ目の y 座標です.
		 * @return 座標間の直線距離です.
		 */
		public static function distanceBetweenPositions(x1:Number, y1:Number, x2:Number, y2:Number):Number
		{
			var x:Number = x2 - x1;
			var y:Number = y2 - y1;

			return Math.sqrt(x * x + y * y);
		}
		
		/**
		 * 
		 *
		 * @param 
		 * @return
		 */
		public static function numArray (num:int):Array
		{
			var array:Array = [];
			var i:int;
			for (i = 0; i < num; i++)
			{
				array.push (i);
			}
			
			return array;
		}
		
		/**
		 * 0からnumまでのランダムな数値を収めた配列.
		 *
		 * @param num
		 * @return numまでのランダムな数値です.
		 */
		public static function randomArray (num:int):Array
		{
			var array:Array = [];
			var i:int;
			
			for (i = 0; i < num; i++)
			{
				array.push (i);
			}
			
			i = array.length;
			
			while (i--)
			{
				var j:int = Math.floor (Math.random () * (i + 1));
				var t:int = array[i];
				array[i] = array[j];
				array[j] = t;
			}
			
			return array;
		}
	}
}
