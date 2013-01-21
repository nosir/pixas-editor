package events 
{
	import flash.events.Event;
	
	/**
	 * @author max
	 */
	public class LayerEvent extends Event 
	{
		public var args:*;
		
		public static const ITEMS_VISIBLE_CHANGE:String = "items_visible_change";
		public static const ITEM_COPY:String = "item_copy";
		public static const ITEM_DELETE:String = "items_delete";
		public static const LINE_MOUSE_DOWN:String = "line_mouse_down";
		public static const LINE_MOUSE_UP:String = "line_mouse_up";
		public static const LINE_SHOW_CHANGE:String = "line_show_change";
		public static const LINE_NAME_CHANGE:String = "line_name_change";
		public static const BACKGROUND_CLICK:String = "bg_click";
		
		public function LayerEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false) 
		{ 
			super(type, bubbles, cancelable);
			
		} 
		
		public override function clone():Event 
		{ 
			return new LayerEvent(type, bubbles, cancelable);
		} 
		
		public override function toString():String 
		{ 
			return formatToString("LayerEvent", "type", "bubbles", "cancelable", "eventPhase"); 
		}
		
	}
	
}