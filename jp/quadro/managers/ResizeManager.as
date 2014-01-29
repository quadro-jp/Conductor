package jp.quadro.managers 
{
	import flash.display.DisplayObject;
	import flash.display.Stage;
	import flash.errors.IllegalOperationError;
	import flash.events.Event;
	import flash.utils.Dictionary;
	import jp.quadro.collection.DataBinder;
	import jp.quadro.display.ResizeAlign;
	import jp.quadro.display.ResizeScaleMode;
	import flash.external.ExternalInterface;
	import flash.display.StageScaleMode;
	
	/**
	 * ...
	 * @author aso
	 */
	public class ResizeManager
	{
		private static var _instance:ResizeManager;
		
		private var _binder:DataBinder;
		
		private var _stage:Stage;
		private var _defaultWidth:Number;
		private var _defaultHeight:Number;
		private var _stageWidth:Number;
		private var _stageHeight:Number;
		private var _scaleByWidth:Number;
		private var _scaleByHeight:Number;
		private var _scaleC:Number;
		private var _scaleByLongSide:Number;
		private var _scaleByShortSide:Number;
		private var _centerX:Number;
		private var _centerY:Number;
		private var _min:Number;
		private var _max:Number;
		private var _isSetDefualtSize:Boolean;
		
		public function ResizeManager(enforcer:SingletonEnforcer)
		{
			if (enforcer == null) throw new IllegalOperationError("ResizeManagerはインスタンスか出来ません。");
			_binder = new DataBinder();
			_min = 0.5;
			_max = 1.0;
		}
		
		public static function getInstance():ResizeManager
		{
			if (ResizeManager._instance == null) ResizeManager._instance = new ResizeManager(new SingletonEnforcer());
			
			return ResizeManager._instance;
		}
		
		public function setDefualtStageSize(stage:Stage, width:Number, height:Number):void
		{
			stage.addEventListener(Event.RESIZE, resizeHandler);
			_isSetDefualtSize = true;
			_stage = stage;
			_defaultWidth = Settings.width = width;
			_defaultHeight = Settings.height = height;
			calculate();
		}
		
		public function add(key:String, target:DisplayObject, align:String, scale:String):void
		{
			if (_binder.contains(key)) return;
			
			try { if (target) _binder.add(key, { target:target, align:align, scale:scale, key:key } ); }
			catch (err:Error) { throw new Error("オブジェクトがありません。"); }
			
			update();
		}
		
		public function remove(key:String):void
		{
			if (_binder.contains(key)) _binder.remove(key);
		}
		
		private function resizeHandler(e:Event):void
		{
			update();
		}
		
		private function update():void
		{
			if (!_isSetDefualtSize) throw new IllegalOperationError("[ResizeManager] 初期化（initialize）を実行してください。");
			
			calculate();
			
			var keys:Array = _binder.getKeys();
			
			for each (var key:String in keys) 
			{
				var object:Object = _binder.getDataByKey(key);
				var item:DisplayObject = object.target;
				var align:String = object.align;
				var scale:String = object.scale;
					
				switch (scale) 
				{
					case ResizeScaleMode.FIT_BY_BOTH :
						item.width = _stageWidth;
						item.height = _stageHeight;
					break;
					
					case ResizeScaleMode.FIT_BY_HEIGHT :
						item.height = _stageHeight;
					break;
					
					case ResizeScaleMode.FIT_BY_WIDTH :
						item.width = _stageWidth;
					break;
					
					case ResizeScaleMode.NO_SCALE :
						
					break;
					
					case ResizeScaleMode.LIMITED_SCALE :
						item.scaleX = item.scaleY = _scaleByShortSide > _max ? _max : _scaleByShortSide < _min ? _min : _scaleByShortSide;
					break;
					
					case ResizeScaleMode.SCALE_BY_HEIGHT :
						item.scaleX = item.scaleY = _scaleByHeight;
					break;
					
					case ResizeScaleMode.SCALE_BY_LONG_SIDE :
						item.scaleX = item.scaleY = _scaleByLongSide;
					break;
					
					case ResizeScaleMode.SCALE_BY_SHORT_SIDE :
						item.scaleX = item.scaleY = _scaleByShortSide;
					break;
					
					case ResizeScaleMode.SCALE_BY_WIDTH :
						item.scaleX = item.scaleY = _scaleByWidth;
					break;
				}
				
				switch (align) 
				{
					case ResizeAlign.BOTTOM :
						item.y = _stageHeight;
					break;
					
					case ResizeAlign.BOTTOM_CENTER :
						item.x = _centerX;
						item.y = _stageHeight;
					break;
					
					case ResizeAlign.BOTTOM_LEFT :
						item.x = 0;
						item.y = _stageHeight;
					break;
					
					case ResizeAlign.BOTTOM_RIGHT :
						item.x = _stageWidth;
						item.y = _stageHeight;
					break;
					
					case ResizeAlign.CENTER :
						item.x = centerX;
						item.y = centerY;
					break;
					
					case ResizeAlign.CENTER_LEFT :
						item.x = 0;
						item.y = centerY;
					break;
					
					case ResizeAlign.CENTER_RIGHT :
						item.x = _stageWidth;
						item.y = centerY;
					break;
					
					case ResizeAlign.CENTER_HORIZONTAL :
						item.x = centerX;
					break;
					
					
					case ResizeAlign.CENTER_VERTICAL :
						item.y = centerY;
					break;
					
					case ResizeAlign.LEFT :
						item.x = 0;
					break;
					
					case ResizeAlign.RIGHT :
						item.x = _stageWidth;
					break;
					
					case ResizeAlign.SMART_CENTER :
						item.x = int((_stageWidth - _defaultWidth * item.scaleX) / 2);
						item.y = int((_stageHeight - _defaultHeight * item.scaleY) / 2);
					break;
					
					case ResizeAlign.TOP :
						item.y = 0;
					break;
					
					case ResizeAlign.TOP_CENTER :
						item.x = _centerX;
						item.y = 0;
					break;
					
					case ResizeAlign.TOP_LEFT :
						item.x = 0;
						item.y = 0;
					break;
					
					case ResizeAlign.TOP_RIGHT :
						item.x = _stageWidth;
						item.y = 0;
					break;
				}
			}
		}
		
		private function calculate():void
		{
			if (_stageWidth == _stage.stageWidth && _stageHeight == _stage.stageHeight) return;
			
			_stageWidth = _stage.stageWidth;
			_stageHeight = _stage.stageHeight;
			
			_scaleByWidth = _stageWidth / _defaultWidth;
			_scaleByHeight = _stageHeight / _defaultHeight;
			_scaleByLongSide = _scaleByWidth > _scaleByHeight ? _scaleByWidth : _scaleByHeight;
			_scaleByShortSide = _scaleByWidth < _scaleByHeight ? _scaleByWidth : _scaleByHeight;
			_centerX = int(_stageWidth / 2);
			_centerY = int(_stageHeight / 2);
		}
		
		
		
		
		
		public function get byWidth():Number { return _scaleByWidth; }
		
		public function get byHeight():Number { return _scaleByHeight; }
		
		public function get byLongSide():Number { return _scaleByLongSide; }
		
		public function get byShortSide():Number { return _scaleByShortSide; }
		
		public function get centerX():Number { return _centerX; }
		
		public function get centerY():Number { return _centerY; }
		
		public function get stageWidth():Number { return _stageWidth; }
		
		public function get stageHeight():Number { return _stageHeight; }
		
		public function get max():Number 
		{
			return _max;
		}
		
		public function set max(value:Number):void 
		{
			_max = value;
		}
		
		public function get min():Number 
		{
			return _min;
		}
		
		public function set min(value:Number):void 
		{
			_min = value;
		}
		
		public function get defaultWidth():Number 
		{
			return _defaultWidth;
		}
		
		public function get defaultHeight():Number 
		{
			return _defaultHeight;
		}
	}
}