package events 
{
	import flash.events.Event;
	
	/**
	 * ...
	 * @author max
	 */
	public class ProjectEvent extends Event 
	{
		public var args:*;
		
		public static const SIZE_CHANGE:String = "size_change";
		public static const GRID_SHOW_CHANGE:String = "grid_show_change";
		public static const BOTTOM_SIZE_CHANGE:String = "bottom_size_change";
		public static const RESET_POSITION:String = "reset_position";
		public static const EXPORT_IMAGE:String = "export_image";
		public static const EXPORT_CODE:String = "export_code";
		public static const SAVE:String = "save";
		public static const OPEN:String = "open";
		public static const CLEAR:String = "clear";
		
		public function ProjectEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false) 
		{ 
			super(type, bubbles, cancelable);
		} 
		
		public override function clone():Event 
		{ 
			return new ProjectEvent(type, bubbles, cancelable);
		} 
		
		public override function toString():String 
		{ 
			return formatToString("ProjectEvent", "type", "bubbles", "cancelable", "eventPhase"); 
		}
		
	}
	
}