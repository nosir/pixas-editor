package events 
{
	import flash.events.Event;
	
	/**
	 * ...
	 * @author max
	 */
	public class ToolModeEvent extends Event 
	{
		public var args:*;
		
		public static const SET:String = "set";
		
		public function ToolModeEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false) 
		{ 
			super(type, bubbles, cancelable);
			
		} 
		
		public override function clone():Event 
		{ 
			return new ToolModeEvent(type, bubbles, cancelable);
		} 
		
		public override function toString():String 
		{ 
			return formatToString("ToolModeEvent", "type", "bubbles", "cancelable", "eventPhase"); 
		}
		
	}
	
}