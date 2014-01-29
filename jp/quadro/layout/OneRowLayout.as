package jp.quadro.layout 
{
	import flash.geom.Point;
	import flash.geom.Rectangle;
	/**
	 * ...
	 * @author ...
	 */
	public class OneRowLayout extends LayoutPolicy
	{
		public function OneRowLayout(bounds:Rectangle, property:LayoutProperty, pixelSnap:Boolean = true) 
		{
			super(bounds, property, pixelSnap);
			
			_maxH = (bounds.width / _property.width);
			_maxV = 1;
			_spanH = _property.marginRight;
			_spanV = 0;
		}
		
		override public function getPositon(index:uint):Point 
		{
			var row:int = index / _maxH;
			var column:int = index % _maxH;
			return new Point(
				_property.marginLeft + (_property.width + _spanH) * index + _bounds.left,
				_bounds.top
			);
		}
	}
}