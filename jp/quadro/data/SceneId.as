package jp.quadro.data 
{
	import jp.quadro.managers.SceneManager;
	
	/**
	 * ...
	 * @author aso
	 */
	public class SceneId
	{
		private var _name:String;
		
		public function SceneId(name:String)
		{
			var hash:String = name == '/' ? SceneManager.getInstance().getRootSceneName() : name;
			_name = hash.indexOf("/") == 0 ? hash.substr(1, hash.length) : hash;
		}
		
		public function get fullPath():String
		{
			return _name;
		}
		
		public function get root():String
		{
			return _name.split("/")[0];
		}
		
		public function get shortPath():String
		{
			var sceneName:Array = _name.split("/");
			return sceneName.pop();
		}
	}
}