package events 
{
	import flash.events.Event;
	
	/**
	 * @author max
	 */
	public class PropertiesCommandEvent extends Event 
	{
		public var args:*;
		
		public static const LOST_FOCUS:String = "lose_focus";
		public static const GET_FOCUS:String = "get_focus";
		
		public function PropertiesCommandEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false) 
		{ 
			super(type, bubbles, cancelable);
			
		} 
		
		public override function clone():Event 
		{ 
			return new PropertiesCommandEvent(type, bubbles, cancelable);
		} 
		
		public override function toString():String 
		{ 
			return formatToString("PropertiesCommandEvent", "type", "bubbles", "cancelable", "eventPhase"); 
		}
		
	}
	
}