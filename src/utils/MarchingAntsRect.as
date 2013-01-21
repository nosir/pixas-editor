package utils
{
	import flash.display.BitmapData;
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	/*
	 ************************************************
	
	   TITLE: Marching Ants Rectangle
	   VERSION: 1.0
	   AUTHOR: Mario Klingemann <mario@quasimondo.com>
	   CREATED: October 3, 2005
	
	 ************************************************
	 */
	
	 public class MarchingAntsRect
	{
		private static const colors:Array = [0xff000000, 0xffffffff];
		private static const pattern:Array = [3, 3];
		private static const speed:uint = 32;
		private static const patternLength:uint = 6;
		
		private var patternMap:BitmapData;
		private var copyRect:Rectangle;
		private var sp:Sprite;
		private var canvas:Graphics;
		
		private static var copyPoint:Point = new Point(1, 0);
		
		public function MarchingAntsRect(_sp:Sprite)
		{
			sp = _sp;
			canvas = sp.graphics;
			initBitmap();
		}
		
		public function start():void
		{
			sp.addEventListener(Event.ENTER_FRAME, update);
		}
		
		public function draw(rect:Rectangle):void
		{
			canvas.clear();
			paint(rect);
		}
		
		public function destroy():void
		{
			sp.removeEventListener(Event.ENTER_FRAME, update);
			canvas.clear();
		}
		
		private function paint(r:Rectangle):void
		{
			var rect:Rectangle = new Rectangle(r.width < 0 ? r.x + r.width : r.x, r.height < 0 ? r.y + r.height : r.y, Math.abs(r.width), Math.abs(r.height));
			
			canvas.lineStyle();
			
			canvas.moveTo(rect.left, rect.top);
			canvas.beginBitmapFill(patternMap, new Matrix(1, 0, 0, 1, rect.left % patternLength, 0));
			canvas.lineTo(rect.left + rect.width, rect.top);
			canvas.lineTo(rect.left + rect.width, rect.top + 1);
			canvas.lineTo(rect.left, rect.top + 1);
			canvas.lineTo(rect.left, rect.top);
			canvas.endFill();
			
			canvas.moveTo(rect.left + rect.width, rect.top + 1);
			canvas.beginBitmapFill(patternMap, new Matrix(0, 1, 1, 0, 0, 1 + rect.top % patternLength + patternLength - rect.width % patternLength));
			canvas.lineTo(rect.left + rect.width, rect.top + rect.height);
			canvas.lineTo(rect.left + rect.width - 1, rect.top + rect.height);
			canvas.lineTo(rect.left + rect.width - 1, rect.top + 1);
			canvas.lineTo(rect.left + rect.width, rect.top + 1);
			canvas.endFill();
			
			canvas.moveTo(rect.left, rect.top + rect.height - 1);
			canvas.beginBitmapFill(patternMap, new Matrix(-1, 0, 0, 1, rect.left + rect.width - 1 - (patternLength - (rect.width + rect.height - 1) % patternLength), 0));
			canvas.lineTo(rect.left + rect.width - 1, rect.top + rect.height - 1);
			canvas.lineTo(rect.left + rect.width - 1, rect.top + rect.height);
			canvas.lineTo(rect.left, rect.top + rect.height);
			canvas.lineTo(rect.left, rect.top + rect.height - 1);
			canvas.endFill();
			
			canvas.moveTo(rect.left, rect.top + 1);
			canvas.beginBitmapFill(patternMap, new Matrix(0, -1, 1, 0, 0, 1 + rect.top % patternLength));
			canvas.lineTo(rect.left + 1, rect.top + 1);
			canvas.lineTo(rect.left + 1, rect.top + rect.height - 1);
			canvas.lineTo(rect.left, rect.top + rect.height - 1);
			canvas.lineTo(rect.left, rect.top + 1);
			canvas.endFill();
		
		}
		
		private function update(e:Event):void
		{
			var p:Number = patternMap.getPixel32(patternMap.width - 1, 0);
			patternMap.copyPixels(patternMap, copyRect, copyPoint);
			patternMap.setPixel32(0, 0, p);
		}
		
		private function initBitmap():void
		{
			patternMap = new BitmapData(patternLength, 1, true, 0);
			
			var x:Number = 0;
			for (var i:uint = 0; i < pattern.length; i++)
			{
				for (var j:uint = 0; j < pattern[i]; j++)
				{
					patternMap.setPixel32(x++, 0, colors[i]);
				}
			}
			
			copyRect = new Rectangle(0, 0, patternLength - 1, 1);
		}
	
	}
}