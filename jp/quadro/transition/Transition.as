package jp.quadro.transition
{
	import com.greensock.easing.Cubic;
	import com.greensock.TweenMax;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.events.Event;
	import flash.filters.BlurFilter;
	import jp.quadro.utils.DisplayUtil;
	
	public class Transition
	{
		public static const SLIDE_LEFT : String = "slideleft";
		public static const SLIDE_RIGHT : String = "slideright";
		public static const CROSS_FADE : String = "crossfade";
		public static const FADE : String = "fade";
		public static const CUT_IN : String = "cutin";
		public static const BLIND : String = "blind";
		public static const NONE : String = "none";
		
		private static var _duration:Number = 0.5;
		private static var _debug:Boolean;
		private static var _onCompleteFunction:Function;
			
		public static function start(transition:String, container:DisplayObjectContainer, src:DisplayObject, func:Function = null):void
		{
			if (!src) return;
			
			_onCompleteFunction = func;
			
			switch (transition)
			{
				case Transition.NONE : add(container, src, _onCompleteFunction); break;
				case Transition.CROSS_FADE : crossFade(container, src, _onCompleteFunction); break;
				case Transition.FADE : fade(container, src, _onCompleteFunction); break;
				case Transition.BLIND : blind(container, src, _onCompleteFunction); break;
				case Transition.CUT_IN : cutin(container, src, _onCompleteFunction); break;
				case Transition.SLIDE_LEFT : slideLeft(container, src, _onCompleteFunction); break;
				case Transition.SLIDE_RIGHT : slideRight(container, src, _onCompleteFunction); break;
				
				default :
					add(container, src, _onCompleteFunction); break;
				break;
			}
		}
		
		static private function add(container:DisplayObjectContainer, src:DisplayObject, onCompleteFunction:Function):void 
		{
			container.addChild(src);
			onCompleteFunction();
		}
		
		private static function crossFade(container:DisplayObjectContainer, src:DisplayObject, onCompleteFunction:Function = null):void
		{
			container.addChild(src);
			src.alpha = 0.0;
			
			TweenMax.to(src, _duration, { alpha:1.0, onComplete:function():void
			{
				callBack(container, onCompleteFunction);
			}});
		}
		
		private static function fade(container:DisplayObjectContainer, src:DisplayObject, onCompleteFunction:Function = null):void 
		{
			if (container.numChildren > 0)
			{
				TweenMax.to(container , _duration, { alpha:0.0, onComplete:function():void
				{
					removeAll(container, false);
					container.alpha = 1.0;
					container.addChild(src);
					src.alpha = 0.0;
					
					TweenMax.to(src , _duration, { alpha:1.0, onComplete:function():void
					{
						callBack(container, onCompleteFunction);
					}});
				}});
			}else{
				
				container.addChild(src);
				src.alpha = 0.0;
				TweenMax.to(src, _duration, { alpha:1.0 , onComplete:function():void
				{
					callBack(container, onCompleteFunction);
				}});
			}
		}
		
		private static function blind(container:DisplayObjectContainer, src:DisplayObject, onCompleteFunction:Function = null):void
		{
			var blind:SlopeBlindsEffect = new SlopeBlindsEffect(src);
			blind.addEventListener(Event.COMPLETE, function (e:Event):void
			{
				e.target.removeEventListener(Event.COMPLETE, arguments.callee);
				callBack(container, onCompleteFunction);
			});
			container.addChild(blind);
		}
		
		private static function cutin(container:DisplayObjectContainer, src:DisplayObject, onCompleteFunction:Function):void
		{
			container.addChild(src);
			callBack(container, onCompleteFunction);
		}
		
		private static function slideLeft(container:DisplayObjectContainer, src:DisplayObject, onCompleteFunction:Function = null):void
		{
			container.addChild(src);
			src.x = src.width;
			
			src.filters = [new BlurFilter(8, 0, 1)];
			
			TweenMax.to(src, _duration, { x:0, ease:Cubic.easeInOut, onComplete:function():void
			{
				src.filters = null;
				callBack(container, onCompleteFunction);
			}});
		}
		
		private static function slideRight(container:DisplayObjectContainer, src:DisplayObject, onCompleteFunction:Function = null):void
		{
			container.addChild(src);
			src.x = -src.width;
			
			src.filters = [new BlurFilter(8, 0, 1)];
			
			TweenMax.to(src, _duration, { x:0, ease:Cubic.easeInOut, onComplete:function():void
			{
				src.filters = null;
				callBack(container, onCompleteFunction);
			}});
		}
		
		private static function callBack(container:DisplayObjectContainer, onCompleteFunction:Function):void
		{
			removeAll(container, true);
			onCompleteFunction();
		}
		
		private static function removeAll(container:DisplayObjectContainer, exclude:Boolean):void
		{
			DisplayUtil.removeAll(container, exclude);
		}
		
		public static function set duration(value:Number):void { _duration = value; }
		public static function get duration():Number { return _duration; }
		
		public static function set debug(value:Boolean):void { _debug = value; }
		public static function get debug():Boolean { return _debug; }
	}
}
