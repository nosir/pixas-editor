package component 
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import utils.SpriteOpreator;
	
	/**
	 * @author max
	 */
	public class ColorButton extends Sprite 
	{
		private var color:uint;
		private var _width:Number = 0;
		private var _height:Number = 0;
		private var listener:Function;
		
		public function ColorButton(_parent:Sprite,_x:Number = 0,_y:Number = 0, _color:uint = 0x000000,__listener:Function = null) 
		{
			_width = 9;
			_height = 9;
			color = _color;
			listener = __listener;
			x = _x;
			y = _y;
			draw();
			buttonMode = true;
			
			addEventListener(Event.CHANGE, __listener);
			addEventListener(MouseEvent.CLICK, __onSpClick);
			
			_parent.addChild(this);
		}
		
		override public function set width(_w:Number):void
		{
			_width = _w;
			draw();
		}		

		override public function set height(_h:Number):void
		{
			_height = _h;
			draw();
		}
		
		public function get value():uint
		{
			return color;
		}		
		public function set value(_color:uint):void
		{
			color = _color;
			draw();
		}
		
		private function draw():void
		{
			graphics.clear();
			graphics.beginFill(color);
			graphics.drawRect(0, 0, _width, _height);
			filters = [SpriteOpreator.getShadow(2, true)];
		}
		
		private function __onSpClick(e:MouseEvent):void
		{
			dispatchEvent(new Event(Event.CHANGE));
		}

	}

}