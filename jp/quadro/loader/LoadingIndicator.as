package jp.quadro.loader 
{
	import flash.display.DisplayObjectContainer;
	import flash.events.Event;
	import jp.quadro.loader.BasicLoadingIndicator;
	import jp.quadro.loader.LoadingCircle;
	
	/**
	 * ...
	 * @author quadro
	 */
	public class LoadingIndicator extends LoadingCircle
	{
		public function LoadingIndicator(container:DisplayObjectContainer, lockCenter:Boolean, x:Number = 0, y:Number = 0) 
		{
			super(container, lockCenter, x, y);
		}
		
		override protected function onLoadComplete():void
		{
			animate(0.25, { alpha:0, delay:0, onComplete:function():void {
				dispatchEvent(new Event(Event.COMPLETE));
				destroy();
			} } );
		}
	}
}