package jp.quadro.component 
{
	import com.greensock.easing.Quad;
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import jp.quadro.display.BasicContainer;
	
	/**
	 * <p> 画像ビューワー。 </p>
	 * <p> アクティブな画像のID管理とナビゲーションを提供 </p>
	 * <p> ID更新時にビューポートとページャーをアップデートします。 </p>
	 * 
	 * @author quadro
	 */
	public class BasicImageViewer extends BasicContainer 
	{
		public var previousButton:SimpleButton;
		public var nextButton:SimpleButton;
		
		private var _viewPagerIndicator:BasicViewPagerIndicator;
		private var _viewPort:BasicViewPort;
		
		private var _page:int;
		private var _imageWidth:uint;
		private var _pageNum:uint;
		
		override protected function onAddedToStage():void
		{
			previousButton.addEventListener(MouseEvent.CLICK, clickHandler);
			nextButton.addEventListener(MouseEvent.CLICK, clickHandler);
			update();
		}
		
		override protected function onRemovedFromStage():void
		{
			previousButton.removeEventListener(MouseEvent.CLICK, clickHandler);
			nextButton.removeEventListener(MouseEvent.CLICK, clickHandler);
		}
		
		private function update():void 
		{
			if(viewPagerIndicator) viewPagerIndicator.update(page);
			if (viewPort) viewPort.update(page);
			
			userInterfaceUpdate();
		}
		
		protected function userInterfaceUpdate():void 
		{
			killAnimate(previousButton);
			killAnimate(nextButton);
			
			animate(0.0, { autoAlpha:0.25 }, null, previousButton);
			animate(0.0, { autoAlpha:0.25 }, null, nextButton);
			animate(0.5, { autoAlpha:_page > 0 ? 1.0 : 0.25, delay: 0.5 }, null, previousButton);
			animate(0.5, { autoAlpha:_page < (_pageNum - 1) ? 1.0 : 0.25, delay: 0.5 }, null, nextButton);
			
			previousButton.mouseEnabled = _page > 0 ? true : false;
			nextButton.mouseEnabled = _page < (_pageNum - 1) ? true : false;
		}
		
		private function clickHandler(e:MouseEvent):void 
		{
			switch (e.currentTarget.name)
			{
				case 'previousButton' : page -= 1; break;
				
				case 'nextButton' : page += 1; break;
			}
		}
		
		public function get page():int 
		{
			return _page;
		}
		
		public function set page(value:int):void 
		{
			_page = value;
			
			update();
		}
		
		public function get pageNum():uint 
		{
			return _pageNum;
		}
		
		public function set pageNum(value:uint):void 
		{
			_pageNum = value;
		}
		
		public function get viewPagerIndicator():BasicViewPagerIndicator 
		{
			return _viewPagerIndicator;
		}
		
		public function set viewPagerIndicator(value:BasicViewPagerIndicator):void 
		{
			_viewPagerIndicator = value;
		}
		
		public function get viewPort():BasicViewPort 
		{
			return _viewPort;
		}
		
		public function set viewPort(value:BasicViewPort):void 
		{
			_viewPort = value;
		}
	}
}