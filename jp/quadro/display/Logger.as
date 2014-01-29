package jp.quadro.display 
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.KeyboardEvent;
	import flash.text.TextField;
	import jp.quadro.display.DebugPanel;
	import jp.quadro.display.ResizeAlign;
	import jp.quadro.display.ResizeScaleMode;
	import jp.quadro.managers.*;
	import net.hires.debug.Stats;
	
	/**
	 * ...
	 * @author aso
	 */
	public class Logger extends BasicContainer 
	{
		private var statsHolder:Sprite;
		private var debugPanelHolder:Sprite;
		private var stats:Stats;
		private var debugPanel:DebugPanel;
		private var textField:TextField;
		
		public function Logger() 
		{
			visible = false;
		}
		
		override protected function onAddedToStage():void 
		{
			stage.addEventListener(KeyboardEvent.KEY_DOWN, KeyDownHandler);
			stage.addEventListener(Event.RESIZE, resizeHandler);
			
			statsHolder = new Sprite();
			stats = new Stats();
			stats.x = -70;
			stats.y = -100;
			addChild(statsHolder);
			statsHolder.addChild(stats);
			
			textField = new TextField();
			textField.textColor = 0xFFFFFF;
			textField.x = 20;
			textField.y = 20;
			textField.wordWrap = true;
			textField.width = 280;
			textField.height = stage.stageHeight - 40;
			textField.text = LogManager.getInstance().log;
			addChild(textField);
			
			LogManager.getInstance().addEventListener(Event.CHANGE, changeHandler);
			
			resizeHandler(null);
			
			if (!debugPanelHolder)
			{
				debugPanelHolder = new Sprite();
				addChild(debugPanelHolder);
			}
			
			ResizeManager.getInstance().add('logger::statsHolder', statsHolder, ResizeAlign.BOTTOM_RIGHT, ResizeScaleMode.NO_SCALE);
			ResizeManager.getInstance().add('logger::debugPanelHolder', debugPanelHolder, ResizeAlign.TOP_RIGHT, ResizeScaleMode.NO_SCALE);
		}
		
		private function changeHandler(e:Event):void 
		{
			textField.appendText(LogManager.getInstance().appendLog);
			textField.scrollV = textField.maxScrollV;
		}
		
		public function KeyDownHandler(event:KeyboardEvent):void
		{
			if (event.keyCode == 80) visible = !visible;
			textField.scrollV = textField.maxScrollV;
		}
		
		override protected function onRemovedFromStage():void 
		{
			stage.removeEventListener(KeyboardEvent.KEY_DOWN, KeyDownHandler);
			stage.removeEventListener(Event.RESIZE, resizeHandler);
			LogManager.getInstance().removeEventListener(Event.CHANGE, changeHandler);
			
			statsHolder = null;
			debugPanelHolder = null;
			stats = null;
			debugPanel = null;
			textField = null;
		}
		
		public function addMonitorParam(label:String, scope:Object, param:String, eventDispatcher:EventDispatcher = null, event:String = null):void
		{
			if (!debugPanel)
			{
				debugPanel = new DebugPanel();
				
				if (!debugPanelHolder)
				{
					debugPanelHolder = new Sprite();
					addChild(debugPanelHolder);
				}
				debugPanelHolder.addChild(debugPanel);
			}
			
			debugPanel.add(label, scope, param, eventDispatcher, event);
			debugPanel.x = -debugPanel.width;
		}
		
		private function resizeHandler(e:Event):void 
		{
			graphics.clear();
			graphics.beginFill(0x444444);
			graphics.drawRect(0, 0, 300, stage.stageHeight);
			textField.height = stage.stageHeight;
			textField.scrollV = textField.maxScrollV;
		}
	}
}