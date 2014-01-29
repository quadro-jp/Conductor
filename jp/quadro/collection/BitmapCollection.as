package jp.quadro.collection
{
	import flash.display.Bitmap;
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.net.LocalConnection;
	import flash.net.URLRequest;
	import flash.system.LoaderContext;
	import flash.system.SecurityDomain;
	
	public class BitmapCollection extends EventDispatcher
	{	
		private var _loadList:Collection;
		private var _collection:Collection;
		private var _loaded:int;
		private var _close:Boolean;
		private var loader:Loader;
		
		/**
		 * コンストラクタ
		 * @bdff
		 * @param
		 * @see 
		 */
		public function BitmapCollection()
		{
			_loadList = new Collection();
			_collection = new Collection();
		}
		
		/**
		 * XMLListに記述されているファイル名を一括でロードリストに追加します。
		 * 
		 * @bdff
		 * @param
		 * @see 
		 */
		public function addRequestFromXMLList (xml:XMLList):void
		{
			for (var i:int = 0; i < xml.length(); i++) 
			{
				_loadList.add( { url:xml[i], key:xml[i] } );
			}
		}
		
		public function addRequest (url:String, key:String = null):void
		{
			var n:uint = _loadList.length;
			
			for (var i:int = 0; i < n; i++) 
			{
				if (_loadList.iterator().key(i).key == key) throw new Error("ビットマップの登録キー " + key + " は、登録済みです。");
			}
			_loadList.add( { url:url, key:key == null ? url : key } );
		}
		
		/**
		 * リクエストを消去
		 * @bdff
		 * @param
		 * @see 
		 */
		public function clearRequest ():void
		{
			_loadList.destroy();
			_loaded = 0;
		}
		
		/**
		 * 一括読み込み開始
		 * @bdff
		 * @param
		 * @see 
		 */
		public function load():void 
		{
			if (_loadList.length == 0) return;
			
			_loaded = 0;
			_close = false;
			
			var domain:String = new LocalConnection().domain;
			var context:LoaderContext = new LoaderContext();
			
			for (var i:int = 0; i < _loadList.length; i++) 
			{
				loader = new Loader();
				loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onLoadComplete);
				loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, errorHandler);
				loader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, onProgressHandler);
				_collection.add( { data:loader, key:_loadList.iterator().key(i).key } );
				
				if (domain != "localhost") context.securityDomain = SecurityDomain.currentDomain;  
				
				loader.load(new URLRequest(encodeURI(_loadList.iterator().key(i).url)), context);
			}
		}
		
		/**
		 * 読み込み済みのビットマップデータを取得
		 * @bdff
		 * @param
		 * @see 
		 */
		public function getBitmapByKey(key:String, smoothing:Boolean = false):Bitmap
		{
			var n:uint = _collection.length;
			var bitmap:Bitmap;
			
			for (var i:int = 0; i < n; i++) 
			{
				if (_collection.iterator().key(i).key == key)
				{
					bitmap = new Bitmap(_collection.iterator().key(i).data.content.bitmapData.clone());
					bitmap.smoothing = smoothing;
					break;
				}
			}
			return bitmap;
		}
		
		public function getBitmapById(id:uint, smoothing:Boolean = false):Bitmap
		{
			var bitmap:Bitmap;
			
			if (id >= _collection.length) {
				throw new Error("out of index.");
			}else {
				bitmap = new Bitmap(_collection.iterator().key(id).data.content.bitmapData.clone());
				bitmap.smoothing = smoothing;
			}
			
			return bitmap;
		}
		
		public function getArray(smoothing:Boolean = false):Array
		{
			var array:Array = [];
			var n:uint = getBitmapLength();
			
			for (var i:int = 0; i < n; i++) 
			{
				array[i] = getBitmapById(i);
			}
			
			return array;
		}
		
		/**
		 * 読み込み済みのビットマップデータの総数を取得
		 * @bdff
		 * @param
		 * @see 
		 */
		public function getBitmapLength():uint
		{
			return _collection.length;
		}
		
		public function close():void
		{
			_close = true;
		}
		
		private function onLoadComplete(e:Event):void
		{
			e.target.removeEventListener(Event.COMPLETE, onLoadComplete);
			e.target.removeEventListener(ProgressEvent.PROGRESS, onProgressHandler);
			e.target.removeEventListener(IOErrorEvent.IO_ERROR, errorHandler);
			
			_loaded++;
			
			if (_loaded < _loadList.length) return;
			
			try { dispatchEvent(e); }
			catch (err:Error) { }
		}
		
		private function onProgressHandler(e:ProgressEvent):void
		{
			dispatchEvent(e);
			
			if (!_close) return;
			
			//trace("[ notify ] loader was closed.");
			
			loader.unload();
			loader.close();
			e.target.removeEventListener(Event.COMPLETE, onLoadComplete);
			e.target.removeEventListener(IOErrorEvent.IO_ERROR, errorHandler);
			e.target.removeEventListener(ProgressEvent.PROGRESS, onProgressHandler);
		}
		
		private function errorHandler(e:IOErrorEvent):void
		{
			//trace("errorHandler", e.text);
		}
		
		public function destroy():void
		{
			close();
			clearRequest();
			_loadList.destroy();
			_collection.destroy();
		}
		
		public function clone():BitmapCollection
		{
			var bitmapCollection:BitmapCollection = new BitmapCollection();
			bitmapCollection._collection = _collection;
			return bitmapCollection;
		}
		
		public function get loaded():int { return _loaded; }
	}
}
