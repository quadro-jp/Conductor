package jp.quadro.net
{
	/**
	* ポップアップオプション
	* @author aso
	* @version 0.1
	*/
	public class PopUpWindowOption extends Object
	{
		private var _data:String;
		private var _name:String;
		
		/** menubar=no,toolbar=no,location=no,status=no,resizable=yes
		* コンストラクタ
		* @param	name
		* @param	menubar
		* @param	toolbar
		* @param	location
		* @param	status
		* @param	resizable
		* @param	scrollbars
		*/
		public function PopUpWindowOption( name:String, width:Number, height:Number, menubar:Boolean = false, toolbar:Boolean = false, location:Boolean = false, status:Boolean = false, resizable:Boolean = true, scrollbars:Boolean = true )
		{
			var optionWidth:String = width ? ", width=" + width + ", " : "640,";
			var optionHeight:String = height ? ", height=" + height + ", " : "360,";
			var optionMenubar:String = optionMenubar = menubar ? "menubar=yes," : "menubar=no,";
			var optionToolbar:String = toolbar ? "toolbar=yes," : "toolbar=no,";
			var optionLocation:String = location ? "location=yes," : "location=no,";
			var optionStatus:String = status ? "status=yes," : "status=no,";
			var optionResizable:String = resizable ? "resizable=yes," : "resizable=no,";
			var optionScrollbars:String = scrollbars ? "scrollbars=yes" : "scrollbars=no";
			
			_data = name + optionWidth + optionHeight + optionMenubar + optionToolbar + optionLocation + optionStatus + optionResizable + optionScrollbars;
		}
		
		public function get data():String { return _data; }
		public function set data(value:String):void { _data = value; }
		
		public function get name():String { return _name; }
		public function set name(value:String):void { _name = value; }
	}
}
