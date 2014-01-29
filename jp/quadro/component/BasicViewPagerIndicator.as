package jp.quadro.component 
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	
	/**
	 * <p> ビューページャー。 </p>
	 * <p> createをオーバーライドし、ビューページャーの外観を定義。 </p>
	 * <p> updateをオーバーライドし、更新時の動作を定義。 </p>
	 * 
	 * @author quadro
	 */
	public class BasicViewPagerIndicator extends Sprite 
	{
		public function BasicViewPagerIndicator(num:uint)
		{
			create(num);
		}
		
		public function create(num:uint):void
		{
			var indicator:Sprite;
			var n:uint = num;
			
			for (var i:int = 0; i < n; i++) 
			{
				indicator = new Sprite();
				indicator.graphics.beginFill(0x000000);
				indicator.graphics.drawRect(20 * i, 483, 10, 10);
				indicator.graphics.endFill();
				addChild(indicator);
			}
		}
		
		public function update(id:int):void 
		{
			var indicator:DisplayObject;
			var n:uint = numChildren;
			
			for (var i:int = 0; i < n; i++) 
			{
				indicator = getChildAt(i);
				id == i ? indicator.alpha = 1.0 : indicator.alpha = 0.5;
			}
		}
	}
}