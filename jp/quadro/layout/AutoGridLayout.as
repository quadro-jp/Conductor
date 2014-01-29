package jp.quadro.layout 
{
	import flash.geom.Point;
	import flash.geom.Rectangle;
	/**
	 * ...
	 * @author ...
	 */
	public class AutoGridLayout extends LayoutPolicy
	{
		public function AutoGridLayout(bounds:Rectangle, property:LayoutProperty, pixelSnap:Boolean = true) 
		{
			super(bounds, property, pixelSnap);
			
			_maxH = (bounds.width / _property.width);
			_maxV = (bounds.height / _property.height);
			_spanH = (bounds.width - _property.width * _maxH) / (_maxH - 1);
			_spanV = (bounds.height - _property.height * _maxV) / (_maxV - 1);
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