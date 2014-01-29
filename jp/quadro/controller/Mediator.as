package jp.quadro.controller
{
	import flash.display.DisplayObject;
	import flash.events.MouseEvent;
	import jp.quadro.core.IMediator;
	
	public class Mediator implements IMediator
	{
		protected var _colleague:DisplayObject;
		
		public function Mediator():void
		{
			_colleague = new NullButton();
		}
		
		public function colleagueChanged(colleague:DisplayObject, type:String = ""):void
		{
			switch(type)
			{
				case MouseEvent.CLICK :
					
				break;
				
				case MouseEvent.MOUSE_OVER :
					
				break;
				
				case MouseEvent.MOUSE_OUT :
					
				break;
			}
		}
	}
}
