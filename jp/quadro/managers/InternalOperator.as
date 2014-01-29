package jp.quadro.managers 
{
	import flash.errors.IllegalOperationError;
	import jp.quadro.core.WebSite;
	
	/**
	 * ...
	 * @author aso
	 */
	public class InternalOperator
	{
		private static var _isInitialize:Boolean;
		
		
		public function InternalOperator(scene:WebSite, xml:XML)
		{
			if (InternalOperator._isInitialize) throw new IllegalOperationError("WebSiteは構築済みです。");
			
			SceneManager.getInstance().initialize(scene, xml);
			InternalOperator._isInitialize = true;
		}
	}
}