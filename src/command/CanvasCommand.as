package command 
{
	import base.*;
	import com.risonhuang.pixas.math.*;
	import com.risonhuang.pixas.objects.*;
	import events.*;
	import flash.display.*;
	import flash.events.*;
	import flash.geom.*;
	import utils.*;
	/**
	 * @author max
	 */
	public class CanvasCommand extends CustomEventDispatcher
	{
		//drag
		private var unlockAxis:String;
		private var dragPO:PixelObject;
		private var pt:Point;
		private var ptBeforeDrag:Point;
		private var activeBox:Vector.<uint>;
		private var poBox:Vector.<PixelObject>;
		private var layerBox:Vector.<uint>;
		private var c3dBox:Vector.<Coord3D>;
		private var activeBoxOffset:Vector.<Array>;
		private var mouseFocus:String;
		private var mode:uint;
		private static const ITEM:String = "item";
		private static const BOTTOM:String = "bottom";
		private static const NONE:String = "";
		
		public function CanvasCommand() 
		{
			super(CanvasCommandEvent);
		}
		public function init():void
		{
			mode = KeyCode.V;
			mouseFocus = NONE;
			
			DOM.canvas_sp.addEventListener(MouseEvent.MOUSE_DOWN, __onCanvasMouseDown);
			DOM.canvas_sp.addEventListener(MouseEvent.MOUSE_UP, __onCanvasMouseUp);			
			DOM.canvas_sp.addEventListener(MouseEvent.ROLL_OVER, __onCanvasMouseOver);
			DOM.canvas_sp.addEventListener(MouseEvent.ROLL_OUT, __onCanvasMouseOut);
			DOM.canvas_sp.mouseChildren = false;
			
			dragPO = new PixelObject();
			pt = new Point(0, 0);
			ptBeforeDrag = new Point(0, 0);
			unlockAxis = Param.AXIS_DRAG_UNLOCK;
		}
		//event
		private function __onCanvasMouseDown(e:MouseEvent):void
		{
			DOM.stage.addEventListener(MouseEvent.MOUSE_UP, __onCanvasMouseUp);
			popEvent(CanvasCommandEvent.MOUSE_DOWN);
		}
		private function __onCanvasMouseUp(e:MouseEvent):void
		{
			DOM.stage.removeEventListener(MouseEvent.MOUSE_UP, __onCanvasMouseUp);
			popEvent(CanvasCommandEvent.MOUSE_UP);
		}
		private function __onCanvasMouseOver(e:MouseEvent):void
		{
			if (mode == KeyCode.H)
			{
				Cursor.setHand();
			}
		}
		private function __onCanvasMouseOut(e:MouseEvent = null):void
		{
			if (mouseFocus == NONE) { Cursor.setDefault(); }
		}
		public function updateUnlockAxis(_str:String):void
		{
			unlockAxis = _str;
		}
		public function updateTool(_t:uint):void
		{
			mode = _t;
			resetCursor();
		}
		public function startFrame(_layerBox:Vector.<uint>,_poBox:Vector.<PixelObject>):void
		{
			poBox = _poBox;
			layerBox = _layerBox;
		}
		public function hitTest(_hitter:Sprite):void
		{
			var tmpBox:Vector.<uint> = new Vector.<uint>;
			layerBox.forEach(function(item:uint, index:int, vector:Vector.<uint>):void 
			{
				var po:PixelObject = poBox[item];
				if (HitTest.complexHitTestObject(poBox[item],_hitter)) { tmpBox.push(item); }
			});
			if(tmpBox.length >= 0){popEvent(CanvasCommandEvent.ACTIVE_UPDATE,tmpBox);}
		}
		private function resetCursor():void
		{
			if (mode == KeyCode.H && SpriteOpreator.canvasHitTest())
			{
				Cursor.setHand();
			}
			else
			{
				Cursor.setDefault();
			}
		}
		public function addFrameAt(_activeBox:Vector.<uint>, _poBox:Vector.<PixelObject>):void
		{
			SpriteOpreator.removeFrameForPixelObjectVector(_poBox);
			_activeBox.forEach(function(item:uint, index:int, vector:Vector.<uint>):void{SpriteOpreator.addFrame(_poBox[item])});
		}
		
		public function checkMouseUpTarget():void
		{
			switch (mouseFocus)
			{
				case CanvasCommand.BOTTOM :
					popEvent(CanvasCommandEvent.BOTTOM_MOUSE_UP);
					break;
				case CanvasCommand.ITEM :
					popEvent(CanvasCommandEvent.ITEM_MOUSE_UP);
					break;
				case CanvasCommand.NONE :
					popEvent(CanvasCommandEvent.FRAME_MOUSE_UP);
					break;
			}

			mouseFocus = NONE;
			resetCursor();
		}
		public function checkMouseDownTarget(_activeBox:Vector.<uint>, _layerBox:Vector.<uint>, _poBox:Vector.<PixelObject>):void
		{
			if (mode == KeyCode.H)
			{
				mouseFocus = CanvasCommand.BOTTOM;
				popEvent(CanvasCommandEvent.BOTTOM_MOUSE_DOWN);
			}
			if (mode == KeyCode.V)
			{
				for (var i:int = _layerBox.length - 1; i >= 0; i-- )
				{
					var bm:Bitmap = (_poBox[_layerBox[i]] as PixelObject).bitmap;
					if (bm.bitmapData.getPixel32(bm.mouseX, bm.mouseY) != 0)
					{
						//not in transparnt area
						mouseFocus = CanvasCommand.ITEM;
						popEvent(CanvasCommandEvent.ITEM_MOUSE_DOWN, _layerBox[i]);
						return;
					}
				}
				mouseFocus = NONE;
				popEvent(CanvasCommandEvent.FRAME_MOUSE_DOWN);
			}
		}
		public function itemMouseDown(_poIndex:uint,_activeBox:Vector.<uint>, _poBox:Vector.<PixelObject>, _c3dBox:Vector.<Coord3D>):void
		{
			c3dBox = _c3dBox;
			activeBox = _activeBox;
			poBox = _poBox;
			dragPO = poBox[_poIndex];
			
			pt.x = ptBeforeDrag.x = dragPO.x;
			pt.y = ptBeforeDrag.y = dragPO.y;
			if (unlockAxis == AxisOperator.AXIS_Z)
			{
				dragPO.startDrag(false,new Rectangle(pt.x,pt.y-1000,0,2000));
			}
			else
			{
				dragPO.startDrag();
			}
			dragPO.addEventListener(Event.ENTER_FRAME, __onPOEnterFrame);
			
			activeBoxOffset = new Vector.<Array>;
			activeBox.forEach(function(item:uint, index:int, vector:Vector.<uint>):void 
			{
				activeBoxOffset.push([poBox[item].x - pt.x, poBox[item].y - pt.y]);
			});
		}
		public function correctPosInBound(_index:uint,_poBox:Vector.<PixelObject>, _dmsBox:Vector.<Dms>):void
		{
			var dms:Dms = _dmsBox[_index];
			var po:PixelObject = _poBox[_index];
			
			po.positionX = Math.min(po.positionX, Param.MAX_POS - dms.xDms);
			po.positionX = Math.max(po.positionX, Param.MIN_POS);
			
			po.positionY = Math.min(po.positionY, Param.MAX_POS - dms.yDms);
			po.positionY = Math.max(po.positionY, Param.MIN_POS);
			
			po.positionZ = Math.min(po.positionZ, Param.MAX_Z_POS);
			po.positionZ = Math.max(po.positionZ, Param.MIN_Z_POS);
			
			popEvent(CanvasCommandEvent.C3D_UPDATE_IN_BOUND, { index:_index, c3d:po.position} );
		}
		public function itemMouseUp(_c3dBox:Vector.<Coord3D>):void
		{
			dragPO.removeEventListener(Event.ENTER_FRAME, __onPOEnterFrame);
			dragPO.stopDrag();
			activeBox.forEach(function(item:uint, index:int, vector:Vector.<uint>):void 
			{
				var po:PixelObject = poBox[item];
				
				if (unlockAxis == AxisOperator.AXIS_Z)
				{
					po.position = AxisOperator.flash2c3dLockH(_c3dBox[item], pt.y - ptBeforeDrag.y);
				}
				else
				{
					po.x = dragPO.x + activeBoxOffset[index][0];
					po.y = dragPO.y + activeBoxOffset[index][1];
					po.position = AxisOperator.flash2c3dLockV(_c3dBox[item].z, po.x, po.y);
				}
				
				popEvent(CanvasCommandEvent.C3D_UPDATE, {index:item, c3d:po.position} );
			});
			
			activeBox = null;
			poBox = null;
			dragPO = null;
			pt.x = pt.y = 0;
		}
		private function __onPOEnterFrame(e:Event):void
		{
			pt.x = e.target.x - pt.x;
			pt.y = e.target.y - pt.y;
			activeBox.forEach(function(item:uint, index:int, vector:Vector.<uint>):void {
				var po:PixelObject = poBox[item];
				if (po != e.target)
				{
					po.x += pt.x;
					po.y += pt.y;
				}
				else
				{
					//properties show axis change, this is not connected with real data storage change
					if (unlockAxis == AxisOperator.AXIS_Z)
					{
						popEvent(CanvasCommandEvent.C3D_OEF_CHANGE, AxisOperator.flash2c3dLockH(c3dBox[item] ,po.y - ptBeforeDrag.y));
					}
					else
					{
						popEvent(CanvasCommandEvent.C3D_OEF_CHANGE, AxisOperator.flash2c3dLockV(c3dBox[item].z, po.x, po.y));
					}
				}
			});
			pt.x = e.target.x;
			pt.y = e.target.y;
		}
		
		public function updatePosByArrow(_value:Array,_activeBox:Vector.<uint>,_poBox:Vector.<PixelObject>,_c3dBox:Vector.<Coord3D>):void
		{
			_activeBox.forEach(function(item:uint, index:int, vector:Vector.<uint>):void 
			{
				var po:PixelObject = _poBox[item];
				if (unlockAxis == AxisOperator.AXIS_Z)
				{
					po.position = _value[1] == -1 ? AxisOperator.flash2c3dLockH(_c3dBox[item], -_value[0]) : po.position;
				}
				else
				{
					po.position = AxisOperator.flash2c3dLockV(_c3dBox[item].z, po.x +  _value[0]*2, po.y +  _value[1] * _value[0]);
				}
				popEvent(CanvasCommandEvent.C3D_UPDATE, { po:_poBox[item], c3d:po.position} );
			});
			
			if (_activeBox.length == 1)
			{
				popEvent(CanvasCommandEvent.C3D_OEF_CHANGE, _poBox[_activeBox[0]].position);
			}
		}
	}

}