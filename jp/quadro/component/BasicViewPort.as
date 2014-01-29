package jp.quadro.component 
{
	import flash.display.DisplayObject;
	import jp.quadro.display.BasicContainer;
	
	/**
	 * <p> ビューポート。 </p>
	 * <p> updateをオーバーライドし、ビューポート更新時の動作を定義。 </p>
	 * 
	 * @author quadro
	 */
	public class BasicViewPort extends BasicContainer 
	{
		private var _assets:DisplayObject;
		
		public function BasicViewPort(assets:DisplayObject)
		{
			_assets = assets;
		}
		
		public function update(id:uint):void 
		{
			
		}
		
		public function get assets():DisplayObject 
		{
			return _assets;
		}
		
		public function set assets(value:DisplayObject):void 
		{
			_assets = value;
		}
	}
}