package jp.quadro.commands.ext
{
	import com.greensock.easing.*;
	import com.greensock.TweenMax;
	import jp.quadro.commands.CommandBase;
	
	/**
	 * Command implementation for Tweener addTween.
	 * 
	 * This command internally uses Tweener's onComplete and dispaches Event.COMPLETE after animation.
	 */
	public class TweenerCommand extends CommandBase
	{
		protected var _target : Object
		protected var _duration : Number
		protected var _paramObj : Object
		protected var _waitComplete : Boolean
		
		/**
		 * @param target:Object target for tween, same as Tweener
		 * @param paramObj:Object parameters for tween, same as Tweener
		 */
		public function TweenerCommand(target:Object, duration:Number, paramObj:Object, waitComplete:Boolean = true)
		{
			super();
			_target = target;
			_duration = duration
			_paramObj = paramObj;
			_waitComplete = waitComplete;
			
			if (waitComplete == true) _paramObj.onComplete = _onCompleteCallback;
		}
		
		override public function execute():void
		{
			TweenMax.to(_target, _duration, _paramObj);
			
			if (_waitComplete == false) _onCompleteCallback();
		}
		
		protected function _onCompleteCallback():void
		{
			_target = null;
			_paramObj = null;
			
			dispatchComplete();
		}
	}
}