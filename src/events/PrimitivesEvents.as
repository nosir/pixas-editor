package events 
{
	import flash.events.Event;
	
	/**
	 * @author max
	 */
	public class PrimitivesEvents extends Event 
	{
		public var args:*;
		
		public static const SIZE_CHANGE:String = "size_change";		
		public static const ITEM_CLICK:String = "item_click";
		
		public function PrimitivesEvents(type:String, bubbles:Boolean=false, cancelable:Boolean=false) 
		{ 
			super(type, bubbles, cancelable);
			
		} 
		
		public override function clone():Event 
		{ 
			return new PrimitivesEvents(type, bubbles, cancelable);
		} 
		
		public override function toString():String 
		{ 
			return formatToString("PrimitivesEvents", "type", "bubbles", "cancelable", "eventPhase"); 
		}
		
	}

}