package events 
{
	import flash.events.Event;
	
	/**
	 * ...
	 * @author max
	 */
	public class CanvasCommandEvent extends Event 
	{
		public var args:*;
		public static const MOUSE_UP:String = "mouse_up";
		public static const MOUSE_DOWN:String = "mouse_down";		
		public static const C3D_UPDATE_IN_BOUND:String = "c3d_update_in_bound";
		public static const C3D_UPDATE:String = "c3d_update";
		public static const C3D_OEF_CHANGE:String = "c3d_move_change";
		public static const ITEM_MOUSE_DOWN:String = "item_mouse_down";
		public static const ITEM_MOUSE_UP:String = "item_mouse_up";
		public static const BOTTOM_MOUSE_DOWN:String = "bottom_mouse_down";
		public static const BOTTOM_MOUSE_UP:String = "bottom_mouse_up";
		public static const FRAME_MOUSE_DOWN:String = "frame_mouse_down";
		public static const FRAME_MOUSE_UP:String = "frame_mouse_up";
		public static const ACTIVE_UPDATE:String = "active_up";

		
		public function CanvasCommandEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false) 
		{ 
			super(type, bubbles, cancelable);
			
		} 
		
		public override function clone():Event 
		{ 
			return new CanvasCommandEvent(type, bubbles, cancelable);
		} 
		
		public override function toString():String 
		{ 
			return formatToString("CanvasCommandEvent", "type", "bubbles", "cancelable", "eventPhase"); 
		}

	}
	
}