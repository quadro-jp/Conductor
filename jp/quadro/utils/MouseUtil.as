package jp.quadro.utils
{
    public class MouseUtil extends Object
	{
		private static var rot:Number;
		private static var oldX:Number;
		private static var oldY:Number;
		
		public function MouseUtil()
		{
			throw new Error("MouseUtil クラスは静的クラスのためインスタンス化できません.");
		}
		
		public static function direction (x:Number, y:Number, rotation:Number = 0):Object
		{
			if (oldX && oldY)
			{
				var nx:Number;
				var ny:Number;
				var nr:Number;
				var dX:Number = x - oldX;
				var dY:Number = y - oldY;
				var d:Number = Math.sqrt(dX * dX + dY * dY);
				var r:Number = Math.atan(dY / dX) + (dX >= 0 ? 0 : Math.PI);
				
				// 軌跡の位置／長さ／傾き設定
				nx = oldX;
				ny = oldY;
				nr = r * 180 / Math.PI;
			}
			oldX = x;
			oldY = y;
			
			var o:Object = { x:nx, y:ny, rotation:nr, d:d };
			
			return o;
		}
    }
}