package jp.quadro.utils
{
	import flash.display.Stage;
	import flash.utils.Dictionary;
	import jp.quadro.utils.ObjectUtil;
	
	public class StageReference
	{
		public static const STAGE_DEFAULT:String = 'stageDefault';
		protected static var _stageMap:Dictionary;
		
		public static function getStage(id:String = StageReference.STAGE_DEFAULT):Stage
		{
			if (!(id in StageReference._getMap())) throw new Error('Cannot get Stage ("' + id + '") before it has been set.');
			
			return StageReference._getMap()[id];
		}
		
		public static function setStage(stage:Stage, id:String = StageReference.STAGE_DEFAULT):void
		{
			StageReference._getMap()[id] = stage;
		}
		
		public static function removeStage(id:String = StageReference.STAGE_DEFAULT):Boolean
		{
			if (!(id in StageReference._getMap()))
				return false;
			
			StageReference.setStage(null, id);
			
			return true;
		}
		
		public static function getIds():Array
		{
			return ObjectUtil.getKeys(StageReference._getMap());
		}
		
		public static function getStageId(stage:Stage):String
		{
			var map:Dictionary = StageReference._getMap();
			
			for (var i:String in map)
				if (map[i] == stage)
					return i;
				
			return null;
		}
		
		protected static function _getMap():Dictionary
		{
			if (StageReference._stageMap == null)
				StageReference._stageMap = new Dictionary();
			
			return StageReference._stageMap;
		}
	}
}