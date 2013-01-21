package base 
{
	/**
	 * @author max
	 */
	
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.ui.Mouse;
	
	public class Cursor 
	{
		private static var handCursor:Bitmap;
		private static var cursor:Sprite;
		
		public function Cursor() 
		{
			
		}
		
		internal static function init():void
		{
			cursor = DOM.cursor;
			cursor.mouseEnabled = false;
			handCursor = new EmbedAssets.HandCursor() as Bitmap;
			handCursor.visible = false;
			cursor.addChild(handCursor);
		}
		
		private static function __OEF(e:Event):void
		{
			handCursor.x = cursor.mouseX;
			handCursor.y = cursor.mouseY;
		}
			
		public static function setHand():void
		{
			Mouse.hide();
			cursor.addEventListener(Event.ENTER_FRAME, __OEF);
			handCursor.visible = true;
		}
		
		public static function setDefault():void
		{
			handCursor.visible = false;
			cursor.removeEventListener(Event.ENTER_FRAME, __OEF);
			Mouse.show();
		}
	}

}