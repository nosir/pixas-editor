package view 
{
	import base.*;
	import com.bit101.components.PushButton;
	import com.bit101.components.VBox;
	import com.bit101.components.Window;
	import com.risonhuang.pixas.colors.*;
	import com.risonhuang.pixas.dimensions.*;
	import com.risonhuang.pixas.objects.PixelObject;
	import com.risonhuang.pixas.objects.primitives.*;
	import events.PrimitivesEvents;
	import flash.events.Event;
	import utils.CustomEventDispatcher;
	/**
	 * @author max
	 */
	public class Primitives extends CustomEventDispatcher
	{
		private var window:Window;
		
		public function Primitives() 
		{
			super(PrimitivesEvents);
		}
		
		public function init():void
		{
			window = new Window(DOM.primitives_sp, 0, 0, "Primitives");
			window.draggable = false;
			window.width = Param.PROJECT_WIDTH;
			window.height = Param.PRIMITIVES_HEIGHT;
			window.hasCloseButton = false;
			window.hasMinimizeButton = true;
			window.addEventListener(Event.RESIZE, __onWinResize);
			
			var vBox:VBox = new VBox(window, 10, 10);
			vBox.spacing = Param.PO_LINE_SPACE;
			
			var btnHeight:uint = 24;
			
			var brickBtn:PushButton = new PushButton(vBox, 0, 0, "    Brick", __onBrickBtnClick);
			brickBtn.height = btnHeight;
			var poBrick:PixelObject = new PixelObject(new Brick(new BrickDms(10, 10),SideColor.getByInnerColor(Param.SIDE_DEFAULT_COLOR)));
			poBrick.x = 24;
			poBrick.y = 8;
			brickBtn.addChild(poBrick);
			
			var xSideBtn:PushButton = new PushButton(vBox, 0, 0, "     X Side", __onXSideBtnClick);
			xSideBtn.height = btnHeight;
			var poXSide:PixelObject = new PixelObject(new SideX(new SideXDms(10, 9),SideColor.getByInnerColor(Param.SIDE_DEFAULT_COLOR)));
			poXSide.x = 20;
			poXSide.y = 14;
			xSideBtn.addChild(poXSide);
			
			var ySideBtn:PushButton = new PushButton(vBox, 0, 0, "     Y Side", __onYSideBtnClick);
			ySideBtn.height = btnHeight;
			var poYSide:PixelObject = new PixelObject(new SideY(new SideYDms(10, 9),SideColor.getByInnerColor(Param.SIDE_DEFAULT_COLOR)));
			poYSide.x = 28;
			poYSide.y = 14;
			ySideBtn.addChild(poYSide);
			
			var cubeBtn:PushButton = new PushButton(vBox, 0, 0, "   Cube", __onCubeBtnClick);
			cubeBtn.height = btnHeight;
			var poCube:PixelObject = new PixelObject(new Cube(new CubeDms(8, 8, 7),CubeColor.getByHorizontalColor(Param.CUBE_DEFAULT_COLOR)));
			poCube.x = 24;
			poCube.y = 12;
			cubeBtn.addChild(poCube);
			
			var pyBtn:PushButton = new PushButton(vBox, 0, 0, "        Pyramid", __onPyBtnClick);
			pyBtn.height = btnHeight;
			var poPy:PixelObject = new PixelObject(new Pyramid(new PyramidDms(10),PyramidColor.getByRightColor(Param.PYRAMID_DEFAULT_COLOR)));
			poPy.x = 24;
			poPy.y = 9;
			pyBtn.addChild(poPy);
			
			var slotWestBtn:PushButton = new PushButton(vBox, 0, 0, "       W Slope", __onSlopeWestBtnClick);
			slotWestBtn.height = btnHeight;
			var poSlopeWest:PixelObject = new PixelObject(new SlopeWest(new SlopeDms(8,8),SlopeColor.getByHorizontalColor(Param.SLOPE_DEFAULT_COLOR)));
			poSlopeWest.x = 24;
			poSlopeWest.y = 12;
			slotWestBtn.addChild(poSlopeWest);
			
			var slotNorthBtn:PushButton = new PushButton(vBox, 0, 0, "        N Slope ", __onSlopeNorthBtnClick);
			slotNorthBtn.height = btnHeight;
			var poSlopeNorth:PixelObject = new PixelObject(new SlopeNorth(new SlopeDms(8,8),SlopeColor.getByHorizontalColor(Param.SLOPE_DEFAULT_COLOR)));
			poSlopeNorth.x = 25;
			poSlopeNorth.y = 12;
			slotNorthBtn.addChild(poSlopeNorth);
			
			var slotEastBtn:PushButton = new PushButton(vBox, 0, 0, "       E Slope", __onSlopeEastBtnClick);
			slotEastBtn.height = btnHeight;
			var poSlopeEast:PixelObject = new PixelObject(new SlopeEast(new SlopeDms(6,10),SlopeColor.getByHorizontalColor(Param.SLOPE_DEFAULT_COLOR)));
			poSlopeEast.x = 27;
			poSlopeEast.y = 12;
			slotEastBtn.addChild(poSlopeEast);
			
			var slotSouthBtn:PushButton = new PushButton(vBox, 0, 0, "       S Slope", __onSlopeSouthBtnClick);
			slotSouthBtn.height = btnHeight;
			var poSlopeSouth:PixelObject = new PixelObject(new SlopeSouth(new SlopeDms(10,6),SlopeColor.getByHorizontalColor(Param.SLOPE_DEFAULT_COLOR)));
			poSlopeSouth.x = 22;
			poSlopeSouth.y = 12;
			slotSouthBtn.addChild(poSlopeSouth);	
			
			
			__onWinResize();
		}		
		/*public function updateSizeByProject(_height:uint):void
		{
			window.y = Param.VIEW_SPACE + _height;
			window.height = DOM.stage.stageHeight - window.y;
		}*/
		public function minimize(_b:Boolean):void
		{
			window.minimized = _b;
		}
		
		private function __onWinResize(e:Event = null):void
		{
			popEvent(PrimitivesEvents.SIZE_CHANGE, window.height );
		}
		
		private function __onBrickBtnClick(e:Event):void
		{
			popEvent(PrimitivesEvents.ITEM_CLICK, 0);
		}
		private function __onXSideBtnClick(e:Event):void
		{
			popEvent(PrimitivesEvents.ITEM_CLICK, 1);
		}		
		private function __onYSideBtnClick(e:Event):void
		{
			popEvent(PrimitivesEvents.ITEM_CLICK, 2);
		}		
		private function __onCubeBtnClick(e:Event):void
		{
			popEvent(PrimitivesEvents.ITEM_CLICK, 3);
		}		
		private function __onPyBtnClick(e:Event):void
		{
			popEvent(PrimitivesEvents.ITEM_CLICK, 4);
		}
		private function __onSlopeEastBtnClick(e:Event):void
		{
			popEvent(PrimitivesEvents.ITEM_CLICK, 5);
		}
		private function __onSlopeSouthBtnClick(e:Event):void
		{
			popEvent(PrimitivesEvents.ITEM_CLICK, 6);
		}	
		private function __onSlopeWestBtnClick(e:Event):void
		{
			popEvent(PrimitivesEvents.ITEM_CLICK, 7);
		}	
		private function __onSlopeNorthBtnClick(e:Event):void
		{
			popEvent(PrimitivesEvents.ITEM_CLICK, 8);
		}	

	}
}