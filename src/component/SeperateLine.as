package component 
{
	import flash.display.Sprite;
	
	/**
	 * @author max
	 */
	public class SeperateLine extends Sprite 
	{
		private var color_dark:uint;
		private var color_light:uint;
		private var _width:Number;
		
		public function SeperateLine(_parent:Sprite, _x:Number = 0, _y:Number = 0,
			_w:uint = 100, _color_dark:uint = 0xB5B5B5,_color_light:uint = 0xFFFFFF) 
		{
			_width = _w;
			color_dark = _color_dark;
			color_light = _color_light;
			x = _x;
			y = _y;
			draw();
			
			_parent.addChild(this);
		}
		
		override public function set width(_w:Number):void
		{
			_width = _w;
			draw();
		}		

		private function draw():void
		{
			graphics.clear();
			graphics.lineStyle(1, color_dark);
			graphics.moveTo(0, 0);
			graphics.lineTo(_width,0);
			graphics.lineStyle(1, color_light);
			graphics.moveTo(0, 1);
			graphics.lineTo(_width,1);
		}
		
	}

}