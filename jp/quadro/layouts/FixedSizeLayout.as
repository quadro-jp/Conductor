package jp.quadro.layouts 
{
	import flash.display.StageAlign;
	import flash.display.StageQuality;
	import flash.display.StageScaleMode;
	
	/**
	 * ...
	 * @author ...
	 */
	public class FixedSizeLayout extends Layout
	{
		public function FixedSizeLayout() 
		{
			_align = StageAlign.TOP;
			_quality = StageQuality.HIGH;
			_scaleMode = StageScaleMode.NO_SCALE;
		}
		
	}

}