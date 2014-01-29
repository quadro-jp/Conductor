package jp.quadro.display
{
	import flash.display.DisplayObject;
	
	/**
	 * <p> 表示リストに追加すると自動的にリサイズされます。 </p>
	 *
	 * @author aso
	 */
	public class AutoFitContainer extends BasicContainer
	{
		private var _autoFitWidth:Number = 256;
		private var _autoFitHeight:Number = 256;
		
		public function AutoFitContainer() {
			super(null, 0, 'AutoFitContainer_' + name);
		}
		
		override public function addChild (child:DisplayObject):DisplayObject
		{
			var scale:Number = Math.max(_autoFitWidth / child.width, _autoFitHeight / child.height);
			child.scaleX = child.scaleY = scale;
			child.x = (_autoFitWidth - child.width) / 2;
			child.y = (_autoFitHeight - child.height) / 2;
			
			return super.addChild(child);
		}
		
		public function get autoFitHeight():Number 
		{
			return _autoFitHeight;
		}
		
		public function set autoFitHeight(value:Number):void 
		{
			_autoFitHeight = value;
		}
		
		public function get autoFitWidth():Number 
		{
			return _autoFitWidth;
		}
		
		public function set autoFitWidth(value:Number):void 
		{
			_autoFitWidth = value;
		}
	}
}