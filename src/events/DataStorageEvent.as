package events 
{
	import flash.events.Event;
	
	/**
	 * @author max
	 */
	public class DataStorageEvent extends Event 
	{
		public var args:*;
		
		public static const ITEM_ADD:String = "item_add";
		public static const ACTIVE_BOX_UPDATE:String = "active_box_update";
		public static const LAYER_BOX_UPDATE:String = "layer_box_update";
		public static const RESET:String = "reset";
		
		public function DataStorageEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false) 
		{ 
			super(type, bubbles, cancelable);
			
		} 
		
		public override function clone():Event 
		{ 
			return new DataStorageEvent(type, bubbles, cancelable);
		} 
		
		public override function toString():String 
		{ 
			return formatToString("DataStorageEvent", "type", "bubbles", "cancelable", "eventPhase"); 
		}
		
	}
	
}