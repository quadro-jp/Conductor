package jp.quadro.events
{
	import flash.events.Event;
	import jp.quadro.core.ISceneData;
	import jp.quadro.data.SceneId;

	/**
	 * イベントクラス
	 * @author aso
	 * @version 0.1
	 */
	public class SceneEvent extends Event
	{
		public static const DEPARTURE:String = "scene_departure";
		public static const CHANGE:String = "scene_change";
		public static const ARRIVAL:String = "scene_arrival";
		public static const ASCEND:String = "scene_ascend";
		public static const DESCEND:String = "scene_descend";
		public static const XML_LOAD_COMPLETE:String = "xml_load_complete";
		public static const ENTER:String = "scene_enter";
		public static const LEAVE:String = "scene_leave";
		public static const CREATE:String = "scene_create";
		
		private var _sceneId:SceneId;
		
		
		
		/**
		 * コンストラクタ
		 * @param	type
		 * @param	bubbles
		 * @param	cancelable
		 * @return
		 */
		public function SceneEvent( type:String, sceneId:SceneId = null, bubbles:Boolean = false, cancelable:Boolean = false ):void
		{
			super( type, bubbles, cancelable );
			
			_sceneId = sceneId;
		}
		
		
		
		/**
			@return A string containing all the properties of the event.
		*/
		override public function toString():String
		{
			return formatToString('SceneEvent', 'type', 'sceneId', 'path',  'bubbles', 'cancelable');
		}
		
		public function get sceneId():SceneId 
		{
			return _sceneId;
		}
		
		public function get path():String 
		{
			return _sceneId.fullPath;
		}
	}
}
