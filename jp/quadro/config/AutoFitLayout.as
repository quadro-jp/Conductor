package jp.quadro.config 
{
	import flash.display.StageAlign;
	import flash.display.StageQuality;
	import flash.display.StageScaleMode;
	
	/**
	 * ...
	 * @author ...
	 */
	public class AutoFitLayout extends StageConfig
	{
		public function AutoFitLayout() 
		{
			_align = StageAlign.TOP;
			_quality = StageQuality.HIGH;
			_scaleMode = StageScaleMode.SHOW_ALL;
		}
		
	}

}