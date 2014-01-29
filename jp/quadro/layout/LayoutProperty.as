package jp.quadro.layout 
{
	/**
	 * ...
	 * @author ...
	 */
	public class LayoutProperty 
	{
		private var _width:int;
		private var _height:int;
		private var _marginTop:Number;
		private var _marginBottom:Number;
		private var _marginLeft:Number;
		private var _marginRight:Number;
		
		public function LayoutProperty(width:Number, height:Number, bottom:Number = 0, right:Number = 0, top:Number = 0, left:Number = 0) 
		{
			_width = width;
			_height = height;
			_marginTop = top;
			_marginBottom = bottom;
			_marginLeft = left;
			_marginRight = right;
		}
		
		public function get width():int 
		{
			return _width;
		}
		
		public function get height():int 
		{
			return _height;
		}
		
		public function get marginTop():Number 
		{
			return _marginTop;
		}
		
		public function get marginBottom():Number 
		{
			return _marginBottom;
		}
		
		public function get marginLeft():Number 
		{
			return _marginLeft;
		}
		
		public function get marginRight():Number 
		{
			return _marginRight;
		}
	}
}