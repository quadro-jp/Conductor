package jp.quadro.component
{
	import flash.display.DisplayObjectContainer;
	import flash.display.Shape;
	
	public class EasyRectangle extends Shape
	{	
		public function EasyRectangle(container:DisplayObjectContainer, width:Number, height:Number, color:uint, alpha:Number = 1.0)
		{
			container.addChild(this);
			graphics.clear();
			graphics.beginFill (color, alpha);
			graphics.drawRect(0, 0, width, height);
            graphics.endFill();
		}
	}
}
