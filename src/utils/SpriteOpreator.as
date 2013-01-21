package utils 
{
	import base.DOM;
	import com.risonhuang.pixas.objects.PixelObject;
	import flash.display.Sprite;
	import flash.filters.DropShadowFilter;
	import flash.filters.GlowFilter;
	import base.Param;
	/**
	 * @author max
	 */
	public class SpriteOpreator 
	{
		
		public function SpriteOpreator() 
		{
			
		}
		
		public static function canvasHitTest():Boolean
		{
			var x:Number = DOM.timeline.mouseX;
			var y:Number = DOM.timeline.mouseY;
			return !(DOM.project_sp.hitTestPoint(x, y) || 
							DOM.primitives_sp.hitTestPoint(x, y) ||
							DOM.properties_sp.hitTestPoint(x,y) ||
							DOM.layer_sp.hitTestPoint(x, y));
		}
		public static function removeAllChildren(_sp:Sprite):void
		{
			while (_sp.numChildren > 0) { _sp.removeChildAt(0); }
		}
		public static function roundPos(_sp:Sprite):void
		{
			_sp.x = Math.round(_sp.x);
			_sp.y = Math.round(_sp.y);
		}
		public static function addFrame(_sp:Sprite, _quality:uint = 1):void
		{
			_sp.filters = [new GlowFilter(Param.FRAME_COLOR, 1, 2, 2, 10, _quality, false, false)];
		}
		
		public static function removeFrame(_sp:Sprite):void
		{
			_sp.filters = [];
		}
		
		public static function removeFrameForPixelObjectVector(_vec:Vector.<PixelObject>):void
		{
			_vec.forEach(removeFrameLoop);
		}
		private static function removeFrameLoop(item:PixelObject, index:int, vector:Vector.<PixelObject>):void
		{
			removeFrame(item);
		}
		
		public static function getShadow(dist:Number, knockout:Boolean = false):DropShadowFilter
		{
			return new DropShadowFilter(dist, 45, 0x000000, 1, dist, dist, .3, 1, knockout);
		}
		
	}

}