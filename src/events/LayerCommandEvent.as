package events 
{
	import flash.events.Event;
	
	/**
	 * ...
	 * @author max
	 */
	public class LayerCommandEvent extends Event 
	{
		public var args:*;
		
		public static const ACTIVE_FILTER:String = "active_filter";
		public static const RESORT:String = "resort";
		public static const DEL:String = "del";
		
		public function LayerCommandEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false) 
		{ 
			super(type, bubbles, cancelable);
			
		} 
		
		public override function clone():Event 
		{ 
			return new LayerCommandEvent(type, bubbles, cancelable);
		} 
		
		public override function toString():String 
		{ 
			return formatToString("LayerCommandEvent", "type", "bubbles", "cancelable", "eventPhase"); 
		}
		
	}
	
}