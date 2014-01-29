package jp.quadro.display
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Shape;
	import flash.events.Event;
	import flash.geom.Point;
	import jp.quadro.collection.BitmapCollection;
	import jp.quadro.collection.DataBinder;
	import jp.quadro.display.MessageDisplay;
	import jp.quadro.events.EasyLoadEvent;
	import jp.quadro.events.EasyLoadIOErrorEvent;
	import jp.quadro.layout.LayoutPolicy;
	import jp.quadro.loader.EasyLoader;
	import jp.quadro.managers.Activity;
	import jp.quadro.managers.ResizeManager;
	import jp.quadro.net.NavigateURL;
	import jp.quadro.utils.DisplayUtil;
	
	/**
	 * <p> 基本機能を実装したディスプレイオブジェクト。 </p>
	 *
	 * @author aso
	 */
	public class BasicContainer extends AbstractSprite
	{
		public static const FILE_NOT_FOUND:String = "There was not a file. I come back to the top page.";
		
		private var _bitmapCollection:BitmapCollection;
		private var _loader:EasyLoader;
		private var _activities:DataBinder;
		
		public function BasicContainer(container:DisplayObjectContainer = null, index:int = 0, key:String = '')
		{
			try { var uid:String = key == '' ? 'BasicContainer_' + name : key; }
			catch (err:Error) { };
			super(container, index, uid);
		}
		
		
		
		/**
		 * <p> アクティビティを追加します。</p>
		 * 
		 * @param
		 */
		public function addActivity(activity:Activity):void
		{
			activities.add(activity.key, activity);
		}
		
		
		
		/**
		 * <p> 自身を拘束します。</p>
		 * 
		 * @param
		 */
		public function setConstraints(align:String = ResizeAlign.SMART_CENTER, scale:String = ResizeScaleMode.LIMITED_SCALE):void
		{
			ResizeManager.getInstance().add(className + '::' + name, this, align, scale);
		}
		
		public function removeConstraints():void
		{
			ResizeManager.getInstance().remove(className + '::' + name);
		}
		
		
		
		/**
		 * <p> スクリーンにフィットします。</p>
		 * 
		 * @param
		 */
		public function fit():void
		{
			ResizeManager.getInstance().add(className + '::' + name, this, ResizeAlign.TOP_LEFT, ResizeScaleMode.SCALE_BY_LONG_SIDE);
		}
		
		public function smartFit():void
		{
			ResizeManager.getInstance().add(className + '::' + name, this, ResizeAlign.SMART_CENTER, ResizeScaleMode.SCALE_BY_LONG_SIDE);
		}
		
		/**
		 * <p> センターに配置します。</p>
		 * 
		 * @param
		 */
		public function center():void
		{
			ResizeManager.getInstance().add(className + '::' + name, this, ResizeAlign.SMART_CENTER, ResizeScaleMode.NO_SCALE);
		}
		
		
		
		/**
		 * <p> ディスプレイオブジェクトをコンテナに追加します。 </p>
		 *
		 * @param
		 */
		public function appendChild(displayObject:DisplayObject):void
		{
			addChild(displayObject);
		}
		
		public function appendChildren(displayObjects:Array):void
		{
			var n:uint = displayObjects.length;
			
			for (var i:int = 0; i < n; i++) 
			{
				addChild(displayObjects[i]);
			}
		}
		
		
		
		/**
		 * <p> レイアウトポリシーに基づいてディスプレイオブジェクトを整列します。 </p>
		 *
		 * @param
		 */
		public function layout(displayObjects:Array, layout:LayoutPolicy):void
		{
			var n:int = displayObjects.length;
			
			for (var i:int = 0; i < n; i++) 
			{
				var position:Point = layout.getPositon(i);
				displayObjects[i].x = position.x;
				displayObjects[i].y = position.y;
			}
		}
		
		
		
		/**
		 * <p> Loaderまわりの処理を簡略化する為のメソッドです。 </p>
		 * <p> EasyLoadEventを拾ってごにょごにょしてください。 </p>
		 *
		 * @param
		 */
		public function load(url:String, option:Object = null):void
		{
			option = option ? option : { };
			option.container = option.container ? option.container : this;
			loader.load(url, option);
			loader.addEventListener(EasyLoadEvent.START, easyLoadStartHandler);
			loader.addEventListener(EasyLoadIOErrorEvent.IO_ERROR, ioErrorEventHandler);
			loader.addEventListener(EasyLoadEvent.LOAD_COMPLETE, easyLoadCompleteHandler);
			loader.addEventListener(EasyLoadEvent.TRANSITION_COMPLETE, easyLoadTransitionCompleteHandler);
		}
		
		
		
		/**
		 * <p> 読み込み済みのデータを取得。 </p>
		 *
		 * @param
		 */
		public function getResourceByKey(key:String):DisplayObject { return loader.getResourceByKey(key); }
		
		
		
		/**
		 * <p> 自身の持つプロパティを列挙します。 </p>
		 *
		 * @param
		 */
		public function getElementListByClass(obj:*):Array
		{
			var elements:Array = DisplayUtil.getElementListByClass(obj);
			
			return elements;
		}
		
		
		
		/**
		 * <p> containerの表示リスト内のディスプレイオブジェクトを一括リムーブ。 </p>
		 * <p> 第2引数をtrueにすると最前面のディスプレイオブジェクトをリムーブ対象から除外します。 </p>
		 *
		 * @param
		 */
		public function removeAll(container:DisplayObjectContainer = null, exclude:Boolean = false):void
		{
			container = container ? container : this;
			if (container.numChildren == 0) return;
			DisplayUtil.removeAll(container, exclude);
		}
		
		
		
		/**
		 * <p> マスクをセットします。 </p>
		 *
		 * @param
		 */
		public function setRectangleMask(x:Number, y:Number, width:Number, height:Number):void
		{
			var mask:Shape = new Shape();
			addChildAt(mask, 0);
			mask.graphics.beginFill(0x000000);
			mask.graphics.drawRect(x, y, width, height);
			mask.graphics.endFill();
			this.mask = mask;
		}
		
		
		
		/**
		 * <p> EasyLoader EventHandler </p>
		 *
		 * @param
		 */
		private function easyLoadStartHandler(e:EasyLoadEvent):void
		{
			if (_loader == null) return;
			e.target.removeEventListener(EasyLoadEvent.START, easyLoadStartHandler);
			onEasyLoadStart();
		}
		
		private function ioErrorEventHandler(e:EasyLoadIOErrorEvent):void
		{
			if (_loader == null) return;
			var messageDisplay:MessageDisplay = new MessageDisplay(stage, FILE_NOT_FOUND);
			onEasyLoadError();
		}
		
		private function easyLoadCompleteHandler(e:EasyLoadEvent):void
		{
			if (_loader == null) return;
			
			e.target.removeEventListener(EasyLoadEvent.START, easyLoadStartHandler);
			e.target.removeEventListener(EasyLoadIOErrorEvent.IO_ERROR, ioErrorEventHandler);
			e.target.removeEventListener(EasyLoadEvent.LOAD_COMPLETE, easyLoadCompleteHandler);
			
			try { onEasyLoadComplete(); }
			catch (err:Error) { trace(err); };
		}
		
		private function easyLoadTransitionCompleteHandler(e:EasyLoadEvent):void
		{
			if (_loader == null) return;
			e.target.removeEventListener(EasyLoadEvent.TRANSITION_COMPLETE, easyLoadTransitionCompleteHandler);
			onEasyTransitionComplete();
		}
		
		/**
		 * <p> 指定のurlへ移動します。 </p>
		 *
		 * @param
		 */
		private function getURL(url:String, window:String = "_blank"):void
		{
			NavigateURL.to(url, window);
		}
		
		
		
		protected function onEasyLoadStart():void { }
		protected function onEasyLoadError():void { }
		protected function onEasyLoadComplete():void { }
		protected function onEasyTransitionComplete():void { }
		
		
		
		/**
		 * <p> 表示リストへ追加された瞬間に実行されます。 </p>
		 *
		 * @param
		 */
		override protected function addedToStageHandler(e:Event = null):void
		{
			super.addedToStageHandler();
		}
		
		/**
		 * <p> 表示リストから除外された瞬間に実行されます。 </p>
		 *
		 * @param
		 */
		override protected function removedFromStageHandler(e:Event):void
		{
			super.removedFromStageHandler(e);
			
			removeConstraints();
			
			if (_activities != null)
			{
				var key:Array = _activities.getKeys();
				var n:int = key.length;
				var activity:Activity;
				
				for (var i:int = 0; i < n; i++) 
				{
					activity = _activities.getDataByKey(key[i]) as Activity;
					activity.destroy();
				}
				_activities.destroy();
				_activities = null;
			}
			
			if (_bitmapCollection != null)
			{
				_bitmapCollection.destroy();
				_bitmapCollection = null;
			}
			
			if (_loader != null)
			{
				_loader.close();
				_loader.destroy();
				_loader = null;
			}
		}
		
		
		
		
		
		
		
		
		
		
		/**
		 * <p> setter getter </p>
		 *
		 * @param
		 */
		
		protected function get bitmapCollection():BitmapCollection
		{
			if (_bitmapCollection == null) _bitmapCollection = new BitmapCollection();
			return _bitmapCollection;
		}
		
		protected function get loader():EasyLoader
		{
			if (_loader == null) _loader = new EasyLoader();
			return _loader;
		}
		
		public function get activities():DataBinder 
		{
			if (_activities == null) _activities = new DataBinder();
			return _activities;
		}
	}
}