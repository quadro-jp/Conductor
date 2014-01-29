package jp.quadro.notify 
{
	import jp.quadro.ui.BasicController;
	
	/**
	 * ...
	 * @author quadro
	 */
	public class NavigationIntent extends Intent
	{
		private var _id:uint;
		private var _key:String;
		private var _name:String;
		private var _type:String;
		
		public function NavigationIntent(invoker:BasicController, type:String) 
		{
			_id = invoker.id;
			_key = invoker.key;
			_name = invoker.name;
			_type = type;
		}
		
		override public function getIntent():Object
		{
			return { id:_id, key:_key, name:_name, type:_type };
		}
	}
}