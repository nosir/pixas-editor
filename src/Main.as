package 
{
	import flash.display.Sprite;
	import flash.events.Event;
	
	/**
	 * @author max
	 */
	public class Main extends Sprite 
	{
		
		public function Main():void 
		{
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event = null):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			var _url:String = this.loaderInfo.loaderURL;
			if (_url.indexOf("http://pixas.googlecode.com/") >= 0 || _url.indexOf("https://pixas.googlecode.com/") >= 0 || _url.indexOf("http://risonhuang.com/") >= 0)
			{
				new Mediator(this);
			}
		}
		
	}
	
}