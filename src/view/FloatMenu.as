package view 
{
	import utils.AxisOperator;
	import utils.CustomEventDispatcher;
	import base.DOM;
	import base.EmbedAssets;
	import base.Param;
	import com.bit101.components.*;
	import events.FloatMenuEvent;
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.display.StageDisplayState;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import utils.KeyCode;
	/**
	 * @author max
	 */
	public class FloatMenu extends CustomEventDispatcher 
	{
		private var cbBox:ComboBox;
		private var cbDragBox:ComboBox;
		private var toggleFsBtn:PushButton;
		private var moveBtn:PushButton;
		private var handBtn:PushButton;
		private var label:Label;
		private var tr:Sprite;
		private var labelBottomSpace:uint;
		
		public function FloatMenu() 
		{
			super(FloatMenuEvent);
		}
		public function init() :void
		{
			tr = new Sprite();
			labelBottomSpace = Param.PROPERTIES_HEIGHT;
			
			label = new Label(tr, -90, 0, "About Pixas Editor");
			label.textField.textColor = 0x666666;
			label.mouseEnabled = true;
			label.buttonMode = true;
			label.addEventListener(MouseEvent.CLICK, __onLabelClick);
			
			toggleFsBtn = new PushButton(tr, -90, 10, "Fullscreen", __onToggleFullscreen);
			toggleFsBtn.width = 80;
			
			cbDragBox = new ComboBox(tr, -175, 10);
			cbDragBox.addItem( { label:"Z Lock", data:AxisOperator.AXIS_X} );
			cbDragBox.addItem( { label:"X.Y Lock", data:AxisOperator.AXIS_Z} );
			cbDragBox.selectedIndex = 0;
			cbDragBox.numVisibleItems = 2;
			cbDragBox.addEventListener(Event.SELECT, __onCbDragBoxSelect);
			cbDragBox.width = 80;
			
			cbBox = new ComboBox(tr, -260, 10);
			for (var i:uint = 1; i <= 8; i++)
			{
				cbBox.addItem( { label:String(i * 100)+" %", data:i} );
			}
			cbBox.selectedIndex = Param.ZOOM - 1;
			cbBox.numVisibleItems = 8;
			cbBox.addEventListener(Event.SELECT, __onCbBoxSelect);
			cbBox.width = 80;
			
			handBtn = new PushButton(tr, - 288, 10, "", __onHandBtn);
			handBtn.width = 23;
			handBtn.toggle = true;
			var handImg:Bitmap = new EmbedAssets.HandImg() as Bitmap;
			handImg.x = 5;
			handImg.y = 4;
			handBtn.addChild(handImg);
			
			moveBtn = new PushButton(tr, - 310, 10, "", __onMoveBtn);
			moveBtn.width = 23;
			moveBtn.toggle = true;
			moveBtn.selected = true;
			var moveImg:Bitmap = new EmbedAssets.MoveImg() as Bitmap;
			moveImg.x = 8;
			moveImg.y = 4;
			moveBtn.addChild(moveImg);
			
			DOM.stage.addEventListener(Event.RESIZE, __onResize);
			__onResize();
			
			DOM.float_menu_sp.addChild(tr);
		}
		public function resetUnlock():void
		{
			cbDragBox.selectedIndex = 0;
		}
		public function updateTool(_t:uint):void
		{
			switch (_t)
			{
				case KeyCode.V :
					moveBtn.selected = true;
					handBtn.selected = false;
					break;
				case KeyCode.H :
					moveBtn.selected = false;
					handBtn.selected = true;
					break;
			}
		}
		public function updatePos(_h:uint):void
		{
			labelBottomSpace = _h;
			__onResize();
		}
		public function updateZoomValue(_value:int):void
		{
			cbBox.selectedIndex = Math.min(8, Math.max(1, _value + cbBox.selectedItem.data)) - 1;
			__onCbBoxSelect();
		}
		
		private function __onResize(e:Event = null):void
		{
			label.y = DOM.stage.stageHeight - labelBottomSpace - 20;
			tr.x = DOM.stage.stageWidth - Param.LAYER_WIDTH;
			toggleFsBtn.label = (DOM.stage.displayState == StageDisplayState.NORMAL ? "Fullscreen":"Exit Fullscreen");
		}
		private function __onToggleFullscreen(event:Event):void
		{
			DOM.stage.displayState = (DOM.stage.displayState == StageDisplayState.NORMAL ?
				StageDisplayState.FULL_SCREEN_INTERACTIVE:
				StageDisplayState.NORMAL);
		}
		private function __onLabelClick(e:MouseEvent):void
		{
			popEvent(FloatMenuEvent.ABOUT_CLICK);
		}
		private function __onCbDragBoxSelect(event:Event = null):void
		{
			popEvent(FloatMenuEvent.UNLOCK_AXIS_CHANGE, cbDragBox.selectedItem.data);
		}
		private function __onCbBoxSelect(event:Event = null):void
		{
			popEvent(FloatMenuEvent.ZOOM_CHANGE, cbBox.selectedItem.data);
		}
		
		private function __onHandBtn(e:Event):void
		{
			popEvent(FloatMenuEvent.MODE_CHANGE, KeyCode.H);
		}
		private function __onMoveBtn(e:Event):void
		{
			popEvent(FloatMenuEvent.MODE_CHANGE, KeyCode.V);
		}
	}

}