package jp.quadro.net
{
	import flash.external.ExternalInterface;
	import flash.net.*;
	
	/**
	 * navigateToURLでターゲットウィンドが_blank時のポップアップブロックを回避
	 * @author Aso
	 * @version 09/03/15
	 */
	public class NavigateURL
	{
		public function NavigateURL()
		{
			throw new Error("NavigateURLはスタティッククラスです。インスタンスか出来ません。");
		}
		
		/**
		 * 外部リンクをポップアップウィンドウとして開く
		 * @param url	url:URL
		 * @param name	ウィンドの名前
		 * @bdff NavigatorURL.popup("http://www.google.com", {name:"window"});
		 */
		public static function popup(url:String, option:PopUpWindowOption):void
		{
			var req:URLRequest = new URLRequest(url);
			
			if (!ExternalInterface.available)
			{
				navigateToURL(req, "_blank");
			}
			else
			{
				ExternalInterface.call("window.open('" + url + "', '" + option.name + "', '" + option.data + "')");
			}
		}
		
		/**
		 * 外部リンクを開く
		 * @param url		url:URL
		 * @param window	window:_self, _top, _blank
		 * @bdff NavigatorURL.to("http://www.google.com", "_blank");
		 */
		public static function to(url:String, window:String = "_self"):void
		{
			var req:URLRequest = new URLRequest(url);
			
			if (!ExternalInterface.available)
			{
				navigateToURL(req, window);
			}
			else
			{
				var userAgent:String = String(ExternalInterface.call("function() {return navigator.userAgent;}")).toLowerCase();
				
				if (userAgent.indexOf("firefox") != -1 || (userAgent.indexOf("msie") != -1 && uint(userAgent.substr(userAgent.indexOf("msie") + 5, 3)) >= 7))
				{
					ExternalInterface.call("window.open", req.url, window);
				} else {
					navigateToURL(req, window);
				}
			}
		}
		

	}
}