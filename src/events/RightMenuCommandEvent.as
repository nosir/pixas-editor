package events 
{
	import flash.events.Event;
	
	/**
	 * @author max
	 */
	public class RightMenuCommandEvent extends Event 
	{
		public var args:*;
		
		public static const ZOOM:String = "zoom";
		
		public function RightMenuCommandEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false) 
		{ 
			super(type, bubbles, cancelable);
			
		} 
		
		public override function clone():Event 
		{ 
			return new RightMenuCommandEvent(type, bubbles, cancelable);
		} 
		
		public override function toString():String 
		{ 
			return formatToString("RightMenuCommandEvent", "type", "bubbles", "cancelable", "eventPhase"); 
		}
		
	}
	
}