package jp.quadro.config 
{
	import flash.display.StageAlign;
	import flash.display.StageQuality;
	import flash.display.StageScaleMode;
	
	/**
	 * ...
	 * @author ...
	 */
	public class LiquidLayout extends StageConfig
	{
		public function LiquidLayout() 
		{
			_align = StageAlign.TOP_LEFT;
			_quality = StageQuality.HIGH;
			_scaleMode = StageScaleMode.NO_SCALE;
		}
	}
}