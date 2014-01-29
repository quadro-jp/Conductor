package jp.quadro.component 
{
	import flash.events.*;
	import flash.text.*;
	
	/**
	 * 幅固定で高さを自動調整するテキストフィールド
	 * @author aso
	 * @version 0.1
	 */
	public class EasyTextField extends TextField
	{
		private var _monospace:Number;
		private var _autoSelect:Boolean;
		
		public function EasyTextField(width:Number, autoSelect:Boolean = false, type:String = "dynamic") 
		{
			_monospace = width;
			this.width = _monospace;
			this.autoSelect = autoSelect;
			this.type = type;
			autoSize = TextFieldAutoSize.LEFT;
		}
		
		private function select(e:Event):void
		{
			if (selectedText != "" || !selectable) return;
			setSelection(0, text.length);
		}
		
		override public function set text(value:String):void
		{
			multiline = true;
			wordWrap = true;
			width = _monospace;
			replaceText(0, maxChars, value);
			multiline= wordWrap = ( maxScrollV > 1);
		}
		
		override public function set htmlText(value:String):void
		{
			throw(new Error("htmlTextは未対応です。"));
		}
		
		public function get monospace():Number { return _monospace; }
		
		public function set monospace(value:Number):void 
		{
			_monospace = value;
			width = _monospace;
		}
		
		public function get autoSelect():Boolean { return _autoSelect; }
		
		public function set autoSelect(value:Boolean):void 
		{
			_autoSelect = value;
			if(_autoSelect) addEventListener(MouseEvent.MOUSE_UP, select);
		}
	}
}