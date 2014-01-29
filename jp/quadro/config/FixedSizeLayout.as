package jp.quadro.config 
{
	import flash.display.StageAlign;
	import flash.display.StageQuality;
	import flash.display.StageScaleMode;
	
	/**
	 * ...
	 * @author ...
	 */
	public class FixedSizeLayout extends StageConfig
	{
		public function FixedSizeLayout() 
		{
			_align = StageAlign.TOP;
			_quality = StageQuality.MEDIUM;
			_scaleMode = StageScaleMode.NO_SCALE;
		}
		
	}

}