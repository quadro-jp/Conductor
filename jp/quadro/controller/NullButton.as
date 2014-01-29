package jp.quadro.controller
{
	import flash.display.Sprite;
	import jp.quadro.core.IDestroyable;
	import jp.quadro.core.ILinkable;
	
	/**
	 * ...
	 * @author aso
	 */
	public class NullButton extends Sprite implements ILinkable, IDestroyable
	{
		public function lock():void{ }
		
		public function unlock():void{ }
		
		public function destroy():void{ }
		
		public function get enable():Boolean { return null; }
		public function set enable(value:Boolean):void { }
		
		public function get linkSceneName():int { return ""; }
		
		public function set linkSceneName(value:int):void { }
		
		public function get linkPageNumber():String { return 0; }
		
		public function set linkPageNumber(value:String):void { }
	}
}