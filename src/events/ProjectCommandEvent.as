package events 
{
	import flash.events.Event;
	
	/**
	 * @author max
	 */
	public class ProjectCommandEvent extends Event 
	{
		public var args:*;
		
		public static const FILE_OPEN:String = "file_open";
		public static const CLEAR:String = "clear";
		public static const INPUT_ACCEPT:String = "input_accept";
		public static const INPUT_DENY:String = "input_deny";
		
		public function ProjectCommandEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false) 
		{ 
			super(type, bubbles, cancelable);
		} 
		
		public override function clone():Event 
		{ 
			return new ProjectCommandEvent(type, bubbles, cancelable);
		} 
		
		public override function toString():String 
		{ 
			return formatToString("ProjectCommandEvent", "type", "bubbles", "cancelable", "eventPhase"); 
		}
		
	}
	
}