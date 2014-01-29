package jp.quadro.layout 
{
	import flash.geom.Point;
	import flash.geom.Rectangle;
	/**
	 * ...
	 * @author ...
	 */
	public class LayoutPolicy 
	{
		public static const AUTO_GRID_LAYOUT:String = "auto_grid_layout";
		public static const GRID_LAYOUT:String = "grid_layout";
		
		protected var _bounds:Rectangle;
		protected var _maxH:int;
		protected var _maxV:int;
		protected var _spanH:int;
		protected var _spanV:int;
		protected var _pixelSnap:Boolean;
		protected var _property:LayoutProperty;
		
		public function LayoutPolicy(bounds:Rectangle, property:LayoutProperty, pixelSnap:Boolean = true) 
		{
			_bounds = bounds;
			_property = property;
			_pixelSnap = pixelSnap;
		}
		
		public function getPositon(index:uint):Point 
		{
			return new Point();
		}
	}
}