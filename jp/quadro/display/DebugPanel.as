package jp.quadro.display 
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	
	/**
	 * ...
	 * @author aso
	 */
	public class DebugPanel extends Sprite 
	{
		private var _data:Array;
		private var _color:uint = 0x999999;
		private var _posX:Number = 0;
		
		public function DebugPanel() 
		{
			_data = [];
		}
		
		private function initilize(e:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, initilize);
			
		}
		
		public function add(label:String, scope:Object, param:String, eventDispatcher:EventDispatcher = null, event:String = null):void 
		{
			var labelText:TextField = new TextField();
			var dataText:TextField = new TextField();
			
			labelText.width = 10;
			labelText.height = 18;
			labelText.x = 10;
			labelText.y = 20 * _data.length + 10;
			labelText.selectable = false;
			labelText.autoSize = TextFieldAutoSize.LEFT;
			labelText.text = label;
			
			if (labelText.width > _posX) _posX = labelText.width + 20;
			addChild(labelText);
			
			dataText.selectable = false;
			dataText.autoSize = TextFieldAutoSize.LEFT;
			dataText.width = 10;
			dataText.height = 18;
			dataText.x = _posX;
			dataText.y = labelText.y;
			dataText.selectable = false;
			dataText.text = String(scope[param]);
			addChild(dataText);
			
			_data.push( { label:labelText, dataText:dataText, scope:scope, param:param, eventDispatcher:eventDispatcher } );
			
			for (var i:int = 0; i < _data.length; i++) 
			{
				_data[i].dataText.x = _posX;
			}
			
			graphics.clear();
			graphics.beginFill(_color);
			graphics.drawRoundRect(0, 0, width + 20, height + 18, 6);
			graphics.endFill();
			
			if (eventDispatcher) eventDispatcher.addEventListener(event, update);
		}
		
		private function update(e:Event):void
		{
			for (var i:int = 0; i < _data.length; i++) 
			{
				_data[i].dataText.text = _data[i].scope[_data[i].param];
			}
			
			graphics.clear();
			graphics.beginFill(_color);
			graphics.drawRoundRect(0, 0, width + 20, height + 18, 6);
		}
		
		public function get color():uint 
		{
			return _color;
		}
		
		public function set color(value:uint):void 
		{
			_color = value;
		}
	}
}