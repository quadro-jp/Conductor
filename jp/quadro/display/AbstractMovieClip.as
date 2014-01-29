package jp.quadro.display
{
	import com.greensock.TweenMax;
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.utils.getQualifiedClassName;
	import jp.quadro.managers.InstanceManager;
	import jp.quadro.managers.ListenerManager;
	
	/**
	 * ...
	 * @author aso
	 */
	public class AbstractMovieClip extends MovieClip
	{
		private var _listenerManager:ListenerManager;
		private var _instanceManager:InstanceManager;
		private var _className:String;
		private var _id:uint;
		private var _group:String;
		private var _isDestroyed:Boolean;
		private var _stageReference:Stage;
		private var _key:String;
		
		public function AbstractMovieClip(container:DisplayObjectContainer = null, index:int = -1, key:String = '', group:String = '', id:uint = 0)
		{
			if (className.indexOf("Abstract") != -1) throw new Error(className + " is abstruct Class.");
			
			_listenerManager = ListenerManager.getManager(this);
			
			stage ? addedToStageHandler() : addEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
			
			if (container) index == -1 ? container.addChild(this) : container.addChildAt(this, index);
			
			_key = key == '' ? className + '_' + name : key;
			_group = group;
			_id = id;
			
			try { instanceManager.add(key, this); }
			catch (err:Error) { instanceManager.add(name, this); }
		}
		
		
		
		/**
		 * <p> Tweenアニメーションを実行します。 </p>
		 *
		 * @param
		 */
		public function animate(time:Number, to:Object, from:Object = null, target:Object = null ):void
		{
			target = target == null ? this : target;
			if (from) TweenMax.to(target, 0, from);
			TweenMax.to(target, time, to);
		}
		
		public function killAnimate(target:Object = null ):void
		{
			target = target == null ? this : target;
			TweenMax.killDelayedCallsTo(target);
			TweenMax.killTweensOf(target);
		}
		
		
		
		/**
		 * <p> 関数を遅延実行します </p>
		 *
		 * @param
		 */
		public function delayedCall(delay:Number, delayedCallFunction:Function):void
		{
			TweenMax.to(this, 0.0, { delay:delay, onComplete:delayedCallFunction } );
		}
		
		
		
		/**
		 * <p> 四角形を描画します。 </p>
		 *
		 * @param
		 */
		public function drawRectangle(color:uint, x:Number, y:Number, width:Number, height:Number):void
		{
			var shape:Shape = new Shape();
			addChild(shape);
			shape.graphics.beginFill(color);
			shape.graphics.drawRect(x, y, width, height);
			shape.graphics.endFill();
		}
		
		
		
		/**
		 * <p> 自身を削除する場合は、destroyを実行します。</p>
		 * 
		 * @param
		 */
		public function destroy():void
		{
			_isDestroyed = true;
			
			if (parent != null) parent.removeChild(this);
		}
		
		
		/**
		 * <p> スケールを一括で設定します。</p>
		 * 
		 * @param
		 */
		public function setScale(scale:Number):void
		{
			scaleX = scaleY = scale;
		}
		
		
		/**
		 * <p> 位置を一括で設定します。</p>
		 * 
		 * @param
		 */
		public function setPosition(x:Number, y:Number, z:Number = 0):void
		{
			this.x = x;
			this.y = y;
			if(z) this.z = z
		}
		
		
		/**
		 * <p> 回転を一括で設定します。</p>
		 * 
		 * @param
		 */
		public function setRotation(rotationX:Number, rotationY:Number, rotationZ:Number = 0):void
		{
			this.rotationX = rotationX;
			this.rotationY = rotationY;
			if(rotationZ) this.rotationZ = rotationZ
		}
		
		
		/**
		 * <p> サイズを一括で設定します。</p>
		 * 
		 * @param
		 */
		public function setDimention(width:Number, height:Number):void
		{
			this.width = width;
			this.height = height;
		}
		
		
		
		/**
		 * <p> イベントリスナー周りをごにょごにょしてます。 </p>
		 * <p> _listenerManagerに委譲してます。 </p>
		 *
		 * @param
		 */
		override public function addEventListener(type:String, listener:Function, useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = false):void
		{
			if (!_listenerManager) throw new Error ('コンストラクタ内でaddEventListenerは使用できません。');
			super.addEventListener(type, listener, useCapture, priority, useWeakReference);
			_listenerManager.addEventListener(type, listener, useCapture, priority, useWeakReference);
		}
		
		override public function removeEventListener(type:String, listener:Function, useCapture:Boolean = false):void
		{
			try { if (!_listenerManager) throw new Error ('コンストラクタ内でremoveEventListenerは使用できません。' + name + ', ' + key); }
			catch (err:Error) { trace('removeEventListenerは使用できませんでした。'); }
			super.removeEventListener(type, listener, useCapture);
			ListenerManager.getManager(this).removeEventListener(type, listener, useCapture);
		}
		
		public function removeEventsForType(type:String):void
		{
			if (!_listenerManager) throw new Error ('コンストラクタ内でremoveEventsForTypeは使用できません。');
			_listenerManager.removeEventsForType(type);
		}
		
		public function removeEventsForListener(listener:Function):void
		{
			if (!_listenerManager) throw new Error ('コンストラクタ内でremoveEventsForListenerは使用できません。');
			_listenerManager.removeEventsForListener(listener);
		}
		
		public function removeEventListeners():void
		{
			if (!_listenerManager) throw new Error ('コンストラクタ内でremoveEventListenersは使用できません。');
			_listenerManager.removeEventListeners();
		}
		
		public function getTotalEventListeners(type:String = null):uint
		{
			if (!_listenerManager) throw new Error ('コンストラクタ内でgetTotalEventListenersは使用できません。');
			return _listenerManager.getTotalEventListeners(type);
		}
		
		
		
		/**
		 * <p> 表示リストへ追加された直後に、実行したい処理がある場合は、 </p>
		 * <p> onAddedToStageをオーバーライドしてください。 </p>
		 * 
		 * @param
		 */
		protected function onAddedToStage():void { }
		
		
		
		/**
		 * <p> 表示リストから除外された直後に、実行したい処理がある場合は、 </p>
		 * <p> onRemovedFromStageをオーバーライドしてください。 </p>
		 * 
		 * @param
		 */
		protected function onRemovedFromStage():void {  }
		
		
		/**
		 * <p> 表示リストへ追加された瞬間に実行されます。 </p>
		 * 
		 * @param
		 */
		protected function addedToStageHandler(e:Event = null):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
			addEventListener(Event.REMOVED_FROM_STAGE, removedFromStageHandler);
			_stageReference = stage;
			
			onAddedToStage();
		}
		
		
		/**
		 * <p> 表示リストから除外された瞬間に実行されます。 </p>
		 * 
		 * @param
		 */
		protected function removedFromStageHandler(e:Event):void 
		{
			removeEventListener(Event.REMOVED_FROM_STAGE, removedFromStageHandler);
			
			killAnimate(this);
			
			onRemovedFromStage();
			
			_stageReference = null;
			
			_listenerManager.destroy();
			_listenerManager = null;
			
			_instanceManager.remove(key);
			_instanceManager = null;
		}
		
		
		
		public function get group():String 
		{
			return _group;
		}
		
		public function set group(value:String):void 
		{
			_group = value;
		}
		
		public function get id():uint 
		{
			return _id;
		}
		
		public function get key():String 
		{
			return _key;
		}
		
		protected function get isDestroyed():Boolean
		{
			return _isDestroyed;
		}
		
		protected function set isDestroyed(value:Boolean):void 
		{
			_isDestroyed = value;
		}
		
		public function get className():String
		{
			if (_className == null) _className = getQualifiedClassName(this);
			return _className;
		}
		
		public function get instanceManager():InstanceManager 
		{
			if (_instanceManager == null) _instanceManager = InstanceManager.getInstance();
			return _instanceManager;
		}
		
		public function get stageReference():Stage 
		{
			return _stageReference;
		}
		
		public function set stageReference(value:Stage):void 
		{
			_stageReference = value;
		}
	}
}
