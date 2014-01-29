package jp.quadro.mashup.twitter.controller
{
	import flash.display.*;
	import flash.events.*;
	import jp.quadro.mashup.twitter.data.*;
	import jp.quadro.utils.*;
	import com.greensock.TweenMax;
	import com.greensock.easing.*;
	
	/**
	 * 投稿パネル
	 * @author aso
	 * @version 0.1
	 */ 
	public class ContributePanel extends Sprite 
	{
		private var BUTTON_NUM:int = 7;
		private var _contributeData:ContributeData;
		private var colorList:Array = ["Black","Gray","LightGray","Blue","Pink","Green","Yellow"];
		
		/**
		 * コンストラクタ
		 * @return
		 */
		public function ContributePanel()
		{
			_contributeData = ContributeData.getInstance();
			
			var button:MovieClip;
			
			for (var i:int = 1; i <= BUTTON_NUM; i++) 
			{
				button = this["color" + i];
				button.contribute = colorList[i - 1];
				button.frame.visible = false;
				button.addEventListener(MouseEvent.CLICK, clickHandler);
				button.addEventListener(MouseEvent.ROLL_OVER, rollOverHandler);
				button.addEventListener(MouseEvent.ROLL_OUT, rollOutHandler);
				button.addEventListener(Event.REMOVED_FROM_STAGE, removeMouseEvent);
			}
			
			_contributeData.addEventListener(Event.CHANGE, update);
			_contributeData.contribute = colorList[0];
		}
		
		private function update(e:Event):void 
		{
			var button:MovieClip;
			
			for (var i:int = 1; i <= BUTTON_NUM; i++) 
			{
				button = this["color" + i];
				
				if (button.contribute == _contributeData.contribute)
				{
					button.removeEventListener(MouseEvent.CLICK, clickHandler);
					button.removeEventListener(MouseEvent.ROLL_OVER, rollOverHandler);
					button.removeEventListener(MouseEvent.ROLL_OUT, rollOutHandler);
					button.removeEventListener(Event.REMOVED_FROM_STAGE, removeMouseEvent);
					button.buttonMode = false;
					button.frame.visible = true;
					
				}else {
					button.addEventListener(MouseEvent.CLICK, clickHandler);
					button.addEventListener(MouseEvent.ROLL_OVER, rollOverHandler);
					button.addEventListener(MouseEvent.ROLL_OUT, rollOutHandler);
					button.addEventListener(Event.REMOVED_FROM_STAGE, removeMouseEvent);
					button.buttonMode = true;
					button.frame.visible = false;
				}
			}
		}
		
		public function clickHandler (e:MouseEvent):void
		{
			_contributeData.contribute = e.currentTarget.contribute;
			
			TweenMax.to(e.currentTarget, 0.25, {alpha:1.0});
			var d:Number = MathUtil.abs(pointer.x - e.currentTarget.x) / 30;
			TweenMax.to(pointer, 0.25 * Math.sqrt(d), { x:e.currentTarget.x, ease:Sine.easeInOut} );
		}
		
		public function rollOverHandler (e:MouseEvent):void
		{
			TweenMax.to(e.currentTarget, 0.25, {alpha:0.5});
		}
		
		public function rollOutHandler (e:MouseEvent):void
		{
			TweenMax.to(e.currentTarget, 0.25, {alpha:1.0});
		}
		
		public function removeMouseEvent(e:Event):void
		{
			trace( e.currentTarget.name + "のマウスイベントが除去されました");
			removeEventListener(Event.REMOVED_FROM_STAGE, removeMouseEvent);
			removeEventListener (MouseEvent.CLICK, clickHandler);
			removeEventListener (MouseEvent.MOUSE_OVER, rollOverHandler);
			removeEventListener (MouseEvent.MOUSE_OUT, rollOutHandler);
		}
	}
}