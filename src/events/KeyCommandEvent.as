package events 
{
	import flash.events.Event;
	
	/**
	 * ...
	 * @author max
	 */
	public class KeyCommandEvent extends Event 
	{
		public var args:*;
		
		public static const TAB:String = "tab";
		public static const DEL:String = "del";
		public static const CTRL_A:String = "a";
		public static const CTRL_D:String = "d";
		public static const CTRL_ZOOM:String = "zoom";
		public static const ARROW:String = "arrow";
		public static const MODE:String = "mode";
		
		public function KeyCommandEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false) 
		{ 
			super(type, bubbles, cancelable);
			
		} 
		
		public override function clone():Event 
		{ 
			return new KeyCommandEvent(type, bubbles, cancelable);
		} 
		
		public override function toString():String 
		{ 
			return formatToString("KeyCommandEvent", "type", "bubbles", "cancelable", "eventPhase"); 
		}
		
	}
	
}