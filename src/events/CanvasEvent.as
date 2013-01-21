package events 
{
	import flash.events.Event;
	
	/**
	 * ...
	 * @author max
	 */
	public class CanvasEvent extends Event 
	{
		public var args:*;
		
		public static const FRAME_MOVE:String = "frame_move";
		
		public function CanvasEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false) 
		{ 
			super(type, bubbles, cancelable);
			
		} 
		
		public override function clone():Event 
		{ 
			return new CanvasEvent(type, bubbles, cancelable);
		} 
		
		public override function toString():String 
		{ 
			return formatToString("CanvasEvent", "type", "bubbles", "cancelable", "eventPhase"); 
		}
		
	}
	
}