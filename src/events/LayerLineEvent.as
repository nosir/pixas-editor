package events 
{
	import flash.events.Event;
	
	/**
	 * ...
	 * @author max
	 */
	public class LayerLineEvent extends Event 
	{
		public var args:*;
		
		public static const LINE_MOUSE_UP:String = "line_mouse_up";
		public static const LINE_MOUSE_DOWN:String = "line_mouse_down";
		public static const LINE_SHOW_CHANGE:String = "line_show_change";
		public static const LINE_NAME_CHANGE:String = "line_name_change";
		
		public function LayerLineEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false) 
		{ 
			super(type, bubbles, cancelable);
			
		} 
		
		public override function clone():Event 
		{ 
			return new LayerLineEvent(type, bubbles, cancelable);
		} 
		
		public override function toString():String 
		{ 
			return formatToString("LayerLineEvent", "type", "bubbles", "cancelable", "eventPhase"); 
		}
		
	}
	
}