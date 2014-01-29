package jp.quadro.notify 
{
	import jp.quadro.ui.BasicController;
	
	/**
	 * ...
	 * @author quadro
	 */
	public class NullIntent extends Intent
	{
		override public function getIntent():Object
		{
			return { };
		}
	}
}