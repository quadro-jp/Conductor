package jp.quadro.config 
{
	import flash.utils.getQualifiedClassName;

	public class StageConfig 
	{
		protected var _align:String;
		protected var _quality:String;
		protected var _scaleMode:String;
		
		public function StageConfig()
		{
			if(getQualifiedClassName(this).indexOf("StageConfig") != -1) throw new Error("StageConfig is abstruct Class.");
		}
		
		public function get align():String 
		{
			return _align;
		}
		
		public function get scaleMode():String 
		{
			return _scaleMode;
		}
		
		public function get quality():String 
		{
			return _quality;
		}
	}
}