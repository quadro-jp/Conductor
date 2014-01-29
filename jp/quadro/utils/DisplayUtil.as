package jp.quadro.utils
{
	import flash.display.DisplayObject;
	import flash.utils.getDefinitionByName;
	import flash.utils.describeType;
	import flash.display.DisplayObjectContainer;
	import flash.events.EventDispatcher;

	public class DisplayUtil
	{
		private static var _classNameCache:Array = [];
		
		/**
		 * <p> 指定のインデックス境界以下ののディスプレイオブジェクトを表示リストから除去します。 </p>
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 9.0.45.0
		 * 
		 * @param container ディスプレイオブジェクトコンテナ
		 * @param exclude 最前面ディスプレイオブジェクトを表示リストから除外しない場合はtrue
		 * <p></p>
		 * <p></p>
		 */
		public static function removeChildElse(container:DisplayObjectContainer, index:uint):void
		{
			var i:uint = index;
			
			while (i--)
			{
				container.removeChildAt(0);
			}
		}
		
		/**
		 * <p> 全てのディスプレイオブジェクトを表示リストから除去します。 </p>
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 9.0.45.0
		 * 
		 * @param container ディスプレイオブジェクトコンテナ
		 * @param exclude 最前面ディスプレイオブジェクトを表示リストから除外しない場合はtrue
		 * <p></p>
		 * <p></p>
		 */
		public static function removeAll(container:DisplayObjectContainer,  exclude:Boolean = false ):void
		{
			if (container.numChildren == 0) return;
			
			var n:uint = exclude ? container.numChildren - 1 : container.numChildren;
			
			for (var i:uint = 0; i < n; i++) 
			{
				container.removeChildAt(0);
			}
		}
		
		public static function getElementListByClass(obj:*):Array
		{
			var typeInfo:XML = describeType(obj);
			var list:XMLList = typeInfo.accessor;
			var tmp:Array = [];
			
			for (var i:uint; i < list.length(); i++ )
			{
				tmp.push( { type:list[i].@type, name:list[i].@name } );
			}
			
			return tmp;
		}
		
		public static function forIn(obj:*, callback:Function):void
		{
			var typeInfo:XML = describeType(obj);
			var key:String;
			
			if (typeInfo.children().length() == 0 || typeInfo.@name == 'Array')
			{
				for (key in obj) callback(key);
			}
			else
			{
				for each (key in typeInfo..variable.@name) callback(key);
			}
		}
		
		public static function getClassByName(name:String):Class
		{
			if (_classNameCache[name] == undefined) _classNameCache[name] = getDefinitionByName(name);
			return Class( _classNameCache[name] );
		}
	}
}
