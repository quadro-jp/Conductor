package jp.quadro.layout 
{
	import flash.geom.Point;
	import flash.geom.Rectangle;
	/**
	 * ...
	 * @author ...
	 */
	public class GridLayout extends LayoutPolicy
	{
		public function GridLayout(bounds:Rectangle, property:LayoutProperty, pixelSnap:Boolean = true) 
		{
			super(bounds, property, pixelSnap);
			
			_maxH = (bounds.width / _property.width);
			_maxV = (bounds.height / _property.height);
			_spanH = _property.marginRight;
			_spanV = _property.marginBottom;
		}
		
		override public function getPositon(index:uint):Point 
		{
			var row:int = index / _maxH;
			var column:int = index % _maxH;
			return new Point(
				_property.marginLeft + (_property.width + _spanH) * column + _bounds.left,
				_property.marginTop + (_property.height + _spanV) * row + _bounds.top
			);
		}
	}
}