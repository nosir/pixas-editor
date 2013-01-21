package events 
{
	import flash.events.Event;
	
	/**
	 * @author max
	 */
	public class FloatMenuEvent extends Event 
	{
		public var args:*;
		public static const UNLOCK_AXIS_CHANGE:String = "unlock_axis_change";
		public static const ZOOM_CHANGE:String = "zoom_change";
		public static const ABOUT_CLICK:String = "about_click";
		public static const MODE_CHANGE:String = "mode_change";

		public function FloatMenuEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false) 
		{ 
			super(type, bubbles, cancelable);
			
		} 
		
		public override function clone():Event 
		{ 
			return new FloatMenuEvent(type, bubbles, cancelable);
		} 
		
		public override function toString():String 
		{ 
			return formatToString("FloatMenuEvent", "type", "bubbles", "cancelable", "eventPhase"); 
		}
		
	}
	
}