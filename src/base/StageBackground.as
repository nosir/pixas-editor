package base 
{
	import flash.display.Sprite;
	import flash.events.Event;
	/**
	 * @author max
	 */
	public class StageBackground 
	{
		private static var bg:Sprite;
		
		public function StageBackground() 
		{
			
		}
		
		internal static function init():void
		{
			bg = DOM.bg_sp;
			bg.graphics.beginFill(Param.BG_COLOR);
			bg.graphics.drawRect(0, 0, 100, 100);
			DOM.stage.addEventListener(Event.RESIZE, __onResize);
			__onResize();
		}
		private static function __onResize(e:Event = null):void
		{
			bg.width = DOM.stage.stageWidth;
			bg.height = DOM.stage.stageHeight;
		}
	}

}