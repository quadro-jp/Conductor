package jp.quadro.mashup.twitter.view
{
	import flash.geom.Rectangle;
	import com.tngar.mycroLib.mouseZoom.controls.MouseSmoothScaleControl;
	import flash.display.*;
	import flash.events.*;
	import jp.quadro.mashup.twitter.data.Settings;
	
	public class TwitterResize
	{
		private var _mainView:MainView;
		private var _stage:Stage;
		private var settings:Settings;
		private var scaleControl:MouseSmoothScaleControl;
		
		public function TwitterResize(target:MainView, stage:Stage)
		{
			_mainView = target; 
			_stage = stage;
			
			settings = Settings.getInstance();
			
			_stage.addEventListener(Event.RESIZE, resizeHandler);
			
			resizeHandler(null);
		}
		
		private function resizeHandler(e:Event):void 
		{
			var edge:Number = int((_stage.stageWidth - 1024) / 2);
			
			_mainView.head.width = _stage.stageWidth;
			
			_mainView.ui.x = edge + 20;
			
			_mainView.twitterPanel.x = edge;
			
			_mainView.tweetHolder.x = edge + 687;
			
			_mainView.footer.width = _stage.stageWidth;
			_mainView.copyRight.x = int(_stage.stageWidth / 2);
			
			_mainView.bg.width = _stage.stageWidth;
			_mainView.bg.height = _stage.stageHeight;
			
			_mainView.setting.x = _stage.stageWidth / 2;
			_mainView.setting.y = 768 / 2;
		}
	}
}