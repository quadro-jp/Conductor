package jp.quadro.ui
{
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.MouseEvent;

	public class ScrollPane extends Sprite
	{
		//スクロールするインスタンス
		private var STAGE:Stage;
		private var holder:Sprite;
		private var target:Sprite;
		
		//マスク
		private var rectangle:Sprite;
		
		//イージング
		private var ease:Number = 0.15;
		
		//上限
		private var scrollW:int;
		private var scrollH:int;
		private var edgeX:int;
		private var edgeY:int;
		private var ratioX:Number;
		private var ratioY:Number;
		
		
		//スクロールする目標座標
		private var vx:Number;
		private var vy:Number;
		private var tx:Number;
		private var ty:Number;
		
		private var isForcus:Boolean;
			
		//初期化
		public function ScrollPane (_stage:Stage, _src:*, w:int, h:int, _rectangle:Sprite = null):void
		{
			STAGE = _stage;
			
			target = new Sprite ();
			addChild(target);
			target.addChild(_src);
			
			if (_rectangle != null)
			{
				rectangle = _rectangle;
			}
			else
			{
				rectangle = new Sprite ();
				rectangle.graphics.beginFill (0xFFFFFF, 1.0);
				rectangle.graphics.drawRect  ( 0, 0 , w , h);
				addChildAt(rectangle, 0);
				target.mask = rectangle;
			}
				
			edgeX = w - target.width;
			edgeY = h - target.height;
			scrollW = w;
			scrollH = h;
				
			isForcus = false;
				
			ratioX = (target.width - w) / scrollW;
			ratioY = (target.height - h) / scrollH;
				
			vx = 0;
			vy = 0;
			tx = 0;
			ty = 0;
			
			target.x = 0;
			target.y = 0;
				
			if (target.height >= scrollH)
			{
				setMouseEvent();
				//setEnterFrame();
			}
		}
		
		public function remove():void
		{
			removeMouseEvent();
			removeEnterFrame();
		}
		
		private function scrollenterframe(e:Event):void 
		{
			//目標座標
			if (isForcus)
			{
				vx = mouseX * ratioX;
				vy = mouseY * ratioY;
			}
			
			//イージング
			tx +=  ( -vx - tx) * ease;
			ty +=  ( -vy - ty) * ease;
			
			//現在の座標
			target.x = tx;
			target.y = ty;
			
			if (target.x >= 0)target.x = 0;
			if (target.x <= edgeX) target.x = edgeX;			
			if (target.y >= 0) target.y = 0;
			if (target.y <= edgeY) target.y = edgeY;
			
			var disX:Number = -vx - target.x;
			var disY:Number = -vy - target.y;
			var absoluteX:Number = disX < 0 ? -disX : disX;
			var absoluteY:Number = disY < 0 ? -disY : disY;
			
			if ( absoluteX < 1 && absoluteY < 1)
			{
				removeEnterFrame();
			}
		}
		
		private function setMouseEvent ():void
		{
			if (!target.hasEventListener(MouseEvent.MOUSE_MOVE)) target.addEventListener(MouseEvent.MOUSE_MOVE, mouseMove);
			if (!target.hasEventListener(MouseEvent.MOUSE_OVER)) target.addEventListener(MouseEvent.MOUSE_OVER, mouseOverHandler);
			if (!target.hasEventListener(MouseEvent.MOUSE_OUT)) target.addEventListener(MouseEvent.MOUSE_OUT, mouseOutHandler);
		}
			
		private function removeMouseEvent ():void
		{
			if (target.hasEventListener(MouseEvent.MOUSE_MOVE)) target.removeEventListener(MouseEvent.MOUSE_MOVE, mouseMove);
			if (target.hasEventListener(MouseEvent.MOUSE_OVER)) target.removeEventListener(MouseEvent.MOUSE_OVER, mouseOverHandler);
			if (target.hasEventListener(MouseEvent.MOUSE_OUT)) target.removeEventListener(MouseEvent.MOUSE_OUT, mouseOutHandler);
		}
			
		private function mouseMove(e:MouseEvent):void { if (isForcus) setEnterFrame(); }
			
		private function setEnterFrame(e:MouseEvent = null):void { if (!target.hasEventListener(Event.ENTER_FRAME)) target.addEventListener (Event.ENTER_FRAME, scrollenterframe); }
			
		private function removeEnterFrame():void { if (target.hasEventListener(Event.ENTER_FRAME)) target.removeEventListener (Event.ENTER_FRAME, scrollenterframe);}
			
		private function mouseOverHandler(e:MouseEvent):void { isForcus = true; }
			
		private function mouseOutHandler(e:MouseEvent):void { isForcus = false; }
		
		
		
		//========================================================================
		// setter
		//========================================================================
		
		public function set setEasing(value:Number):void { ease = value; }
	}
}
