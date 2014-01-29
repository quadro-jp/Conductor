package jp.quadro.ui 
{
	import flash.display.DisplayObjectContainer;
	import jp.quadro.controller.AbstractController;
	
	/**
	 * ...
	 * @author aso
	 */
	public class BasicController extends AbstractController
	{
		/**
		 * <p> 基本的なコントローラー。 </p>
		 *
		 * @author aso
		 */
		public function BasicController(container:DisplayObjectContainer = null, group:String = "", key:String = "", id:uint = 0)
		{
			super(container, group, key, id);
		}
	}
}