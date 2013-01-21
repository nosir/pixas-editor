package events 
{
	import flash.events.Event;
	
	/**
	 * ...
	 * @author max
	 */
	public class PropertiesEvent extends Event 
	{
		public var args:*;
		
		public static const COLOR_CHANGE:String = "color_change";
		public static const BORDER_CHANGE:String = "border_change";
		public static const ALPHA_CHANGE:String = "alpha_change";
		public static const DMS_CHANGE:String = "dms_change";
		public static const NAME_CHANGE:String = "name_change";
		public static const C3D_CHANGE:String = "c3d_change";
		public static const HEIGHT_CHANGE:String = "height_change";
		
		public function PropertiesEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false) 
		{ 
			super(type, bubbles, cancelable);
			
		} 
		
		public override function clone():Event 
		{ 
			return new PropertiesEvent(type, bubbles, cancelable);
		} 
		
		public override function toString():String 
		{ 
			return formatToString("PropertiesEvent", "type", "bubbles", "cancelable", "eventPhase"); 
		}
		
	}
	
}