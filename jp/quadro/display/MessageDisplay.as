package jp.quadro.display 
{
	import com.greensock.TweenMax;
	import flash.display.DisplayObjectContainer;
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import jp.quadro.display.ResizeAlign;
	import jp.quadro.display.ResizeScaleMode;
	import jp.quadro.managers.Settings;
	
	/**
	 * ...
	 * @author aso
	 */
	public class MessageDisplay extends BasicContainer
	{
		private var _internalSprite:Sprite;
		
		public function MessageDisplay(container:DisplayObjectContainer, message:String, delay:Number = 1.5) 
		{
			_internalSprite = new Sprite();
			addChild(_internalSprite);
			
			var shape:Sprite = new Sprite();
			_internalSprite.addChild(shape);
			
			var g:Graphics = shape.graphics;
			var textField:TextField = new TextField();
			var textFormat:TextFormat = new TextFormat();
			
			textFormat.font = "arial";
			textFormat.size = 12;
			
			textField.mouseEnabled = false;
			textField.defaultTextFormat = textFormat;
			textField.autoSize = TextFieldAutoSize.LEFT;
			textField.text = message;
			textField.textColor = 0x000000;
			textField.x = 10 -2;
			textField.y = 5 - 2;
			shape.addChild(textField);
			
			g.beginFill(0xFFFFFF);
			g.drawRoundRect(0, 0, textField.textWidth + 20 , textField.textHeight + 10, 4, 4);
			g.endFill();
			shape.x = Settings.width / 2 - shape.width / 2;
			shape.y = Settings.height / 2 - shape.height / 2;
			
			TweenMax.to(this, 0.5, { alpha:0.0, onComplete:destroy, delay:delay } );
			
			for (var i:int = 0; i < container.numChildren; i++) 
			{
				if (container.getChildAt(i) is BasicContainer) {
					if (BasicContainer(container.getChildAt(i)).className == 'jp.quadro.display::MessageDisplay') {
						_internalSprite.y += _internalSprite.height + 10;
					}
				}
			}
			
			super(container, -1, 'MessageDisplay_' + name);
		}
		
		override protected function onAddedToStage():void
		{
			setConstraints(ResizeAlign.SMART_CENTER, ResizeScaleMode.NO_SCALE);
		}
		
		override protected function onRemovedFromStage():void
		{
			removeConstraints();
		}
	}
}