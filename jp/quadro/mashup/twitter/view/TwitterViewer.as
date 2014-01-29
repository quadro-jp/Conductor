package jp.quadro.mashup.twitter.view
{
	import flash.display.*;
	import flash.events.*;
	import flash.geom.*;
	import flash.net.*;
	import flash.text.*;
	import flash.utils.*;
	import jp.quadro.display.*;
	import jp.quadro.effect.*;
	import jp.quadro.loader.*;
	import jp.quadro.mashup.twitter.data.*;
	import jp.quadro.mashup.twitter.events.*;
	import jp.quadro.mashup.twitter.net.*;
	import jp.quadro.utils.*;
	import com.greensock.TweenMax;
	import com.greensock.easing.*;
	import com.greensock.events.TweenEvent;
	
	/**
	* TwitterWebServiceからTwitterEvent.CHANGEが配信される度に
	* TwitterEventが保持するTweetDataを元にTweetDisplayを生成するビュークラス
	* @author aso
	* @version 0.1
	*/
	public class TwitterViewer extends Sprite 
	{
		private const BOTTOM:Number = 574;
		private var twitter:TwitterWebService;
		private var tweetArray:Array; //表示中つぶやきリスト
		private var settings:Settings;
		private var colorList:Array = ["Black", "Gray", "LightGray", "Blue", "Pink", "Green", "Yellow"];
		private var colorLData:Array = ["0x000000", "0x565656", "0xbdbdbd", "0x00a2ff", "0xff91dc", "0x6bcd13", "0xffd800"];
		
		/**
		 * コンストラクタ
		 * @param	twitter TwitterWebService
		 */
		public function TwitterViewer():void
		{
			twitter = TwitterWebService.getInstance();
			twitter.addEventListener(TwitterEvent.CHANGE, display);
			
			tweetArray = [];
			settings = Settings.getInstance();
			
			addEventListener(Event.ADDED_TO_STAGE, initialize);
		}
		
		private function initialize(e:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, initialize);
		}
		
		public function display(e:TwitterEvent):void 
		{
			if (e.tweetData == null) return;
			if (TweenMax.isTweening(tweetArray[0]) || TweenMax.isTweening(tweetArray[tweetArray.length - 1])) return;
			
			var tweetData:TweetData = e.tweetData;
			var textDisplay:TextDisplay;
			var display:TextField;
			var tweetDisplay:TweetDisplay;
			
			//インスタンスを生成
			textDisplay = new TextDisplay();
			tweetDisplay = new TweetDisplay(textDisplay);
			
			//テキストフィールド
			display = textDisplay.display;
			
			//カラーを決定
			var color:uint;
			
			for (var i:int = 0; i < colorList.length ; i++) 
			{
				if (tweetData.message.indexOf(colorList[i]) != -1)
				{
					color = colorLData[i];
					TweenMax.to(textDisplay.color, 0.0, { tint:color } );
					break;
				}
			}
			
			var styleSheet:StyleSheet;
			
			if (tweetData.name.indexOf(settings.screen_name) != -1)
			{
				textDisplay.displayBack.frame.visible = true;
				TweenMax.to(textDisplay.displayBack.frame, 0.0, { tint:color } );
				
				styleSheet = new StyleSheet();
				styleSheet.setStyle("a:link", { color:"#993333" } );
				styleSheet.setStyle("p", { leading:0, fontSize:"11", color:"#000000" } );
				display.styleSheet = styleSheet;
			}
			else
			{
				textDisplay.displayBack.frame.visible = false;
				
				styleSheet = new StyleSheet();
				styleSheet.setStyle("a:link", { color:"#993333" } );
				styleSheet.setStyle("p", { leading:0, fontSize:"11", color:"#000000" } );
				display.styleSheet = styleSheet;
			}
			
			var str:String = "<p><a href='" + tweetData.link + "' target='_blank'>" + tweetData.name + "</a></p></br>";
			str += "<p>" + RegExpUtil.remove(tweetData.message) + "</p>";
			textDisplay.setText(str);
			
			//アイコンを読み込み
			var loader:EasyLoader = new EasyLoader();
			loader.load(tweetData.icon, { container:textDisplay.icon, callback:callback } );
			
			function callback():void
			{
				textDisplay.icon.width = textDisplay.icon.height = 48;
			}
			
			var ht:Number = textDisplay.displayBack.height;
			tweetDisplay.y = -ht - 5;
			
			//トレース用にnameプロパティにつぶやきの内容をいれてみる
			tweetDisplay.name = tweetData.message;
			
			addChildAt(tweetDisplay, 0);
				
			tweetArray.push(tweetDisplay);
			
			var n:uint = tweetArray.length;
			
			for (i = 0; i < n; i++) 
			{
				var t:TweetDisplay = tweetArray[i];
				var d:Number = ( i == n - 1 && n > 1 ) ? 0.5 : 0.5;
				var delay:Number = ( i == n - 1 && n > 1 ) ? 0.5 : 0.0;
				var ty:int = t.y + ht + 4;
				
				if (ty > BOTTOM)
				{
					TweenMax.to(t, d, { y:ty, onComplete:remove(t, i) } );
					
				}else if (i == n - 1) {
					
					TweenMax.to(t, d, { y:ty, delay:delay } );
					
				}else {
					
					TweenMax.to(t, d, { y:ty, delay:delay} );
				}
			}
		}
		
		private function remove(target:TweetDisplay, index:uint):Function
		{
			return function():void
			{
				trace(target.name, "を削除");
				removeChild(target);
				tweetArray.splice(index, 1);
			}
		}
	}
}