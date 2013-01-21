package view 
{
	import base.*;
	import com.bit101.components.*;
	import command.ProjectCommand;
	import component.SeperateLine;
	import events.ProjectEvent;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.FocusEvent;
	import flash.events.KeyboardEvent;
	import utils.AxisOperator;
	import utils.CustomEventDispatcher;
	/**
	 * @author max
	 */
	public class Project extends CustomEventDispatcher
	{
		private var window:Window;
		private var inputXDms:InputText;
		private var inputYDms:InputText;
		private var inputGridSize:InputText;
		private var cbShowGrid:CheckBox;
		private var cbXYAutoChange:CheckBox
		private var radioX:RadioButton;
		private var radioY:RadioButton;
		private var radioZ:RadioButton;
		private var saveBtn:PushButton;
		private var saveAsBtn:PushButton;
		private var exportBtn:PushButton;
		private var codeBtn:PushButton;
		private var openBtn:PushButton;
		
		public function Project() 
		{
			super(ProjectEvent);
		}
		
		public function init():void
		{
			window = new Window(DOM.project_sp, 0, 0, "Project");
			window.draggable = false;
			window.width = Param.PROJECT_WIDTH;
			window.hasCloseButton = false;
			window.hasMinimizeButton = true;
			DOM.stage.addEventListener(Event.RESIZE, __onResize);

			var sp:Sprite = new Sprite();
			window.addChild(sp);
			sp.x = 10;
			sp.y = 10;
			
			var lableXDms:Label = new Label(sp, 0, 0, "X Dms:");

			var lableYDms:Label = new Label(sp, 0, 20, "Y Dms:");

			inputXDms = new InputText(sp, 45, 0, String(Param.GRID_X_WIDTH),null);
			inputXDms.width = 55;
			inputXDms.restrict = "0-9";
			inputXDms.maxChars = 3;
			inputXDms.textField.addEventListener(FocusEvent.MOUSE_FOCUS_CHANGE, __onBottomSizeChange);

			inputYDms = new InputText(sp, 45, 20, String(Param.GRID_Y_WIDTH), null);
			inputYDms.width = 55;
			inputYDms.restrict = "0-9";
			inputYDms.maxChars = 3;
			inputYDms.textField.addEventListener(FocusEvent.MOUSE_FOCUS_CHANGE, __onBottomSizeChange);
			
			var sepLine1:SeperateLine = new SeperateLine(sp, 0, 44);
			
			cbShowGrid = new CheckBox(sp, 0, 54, "Show Gird", __onCBChange);
			cbShowGrid.selected = true;

			var lableGridSize:Label = new Label(sp, 0, 69, "Grid Size:");

			inputGridSize = new InputText(sp, 45, 69, String(Param.GRID_SIZE), null);
			inputGridSize.width = 55;
			inputGridSize.restrict = "0-9";
			inputGridSize.maxChars = 2;
			inputGridSize.textField.addEventListener(FocusEvent.MOUSE_FOCUS_CHANGE, __onBottomSizeChange);
			
			var sepLine3:SeperateLine = new SeperateLine(sp, 0, 93);

			var resetBtn:PushButton = new PushButton(sp, 0, 103, "Reset Setting", __onResetBtnClick);
			var clearBtn:PushButton = new PushButton(sp, 0, 128, "Clear", __onClearBtnClick);
			
			var sepLine4:SeperateLine = new SeperateLine(sp, 0, 156);
			var vBox:VBox = new VBox(sp, 0, 166);
			exportBtn = new PushButton(vBox, 0, 0, "Export Image...", __onExportBtnClick);
			codeBtn = new PushButton(vBox, 0, 0, "Export AS3...", __onCodeBtnClick);
			saveBtn = new PushButton(vBox, 0, 0, "Save...", __onSaveBtnClick);
			openBtn = new PushButton(vBox, 0, 0, "Open...", __onOpenBtnClick);
			
			//var lableDemo:Label = new Label(sp, 0, 310, "Publish Notice In Main!");
			
			DOM.stage.addEventListener(KeyboardEvent.KEY_UP, __onkeyUp);
		}
		
		public function resetAll():void
		{
			inputXDms.text = String(Param.GRID_X_WIDTH);
			inputYDms.text = String(Param.GRID_Y_WIDTH);
			cbShowGrid.selected = Param.SHOW_GRID;
			inputGridSize.text = String(Param.GRID_SIZE);
			__onCBChange();
			__onBottomSizeChange();
		}
		public function updateSizeByPrimitives(_height:uint):void
		{
			window.y = Param.VIEW_SPACE + _height;
			window.height = DOM.stage.stageHeight - window.y;
		}
		public function minimize(_b:Boolean):void
		{
			window.minimized = _b;
		}
		public function resetInputFocus(_from:String = null):void
		{
			if (_from == null) { DOM.stage.focus = null; return; }
			
			var inputText:InputText;
			switch (_from)
			{
				case ProjectCommand.X_DMS :
					inputText = inputXDms;
					break;
				case ProjectCommand.Y_DMS :
					inputText = inputYDms;
					break;
				case ProjectCommand.GRID_SIZE :
					inputText = inputGridSize;
					break;
			}
			DOM.stage.focus = inputText.textField;
			inputText.textField.setSelection(inputText.textField.text.length, 0);
		}
		//event
		private function __onkeyUp(e:KeyboardEvent):void
		{
			if (e.keyCode == 13)
			{
				
				switch (DOM.stage.focus) 
				{
					case inputXDms.textField:
						__onBottomSizeChange();
						break;
					case inputYDms.textField:
						__onBottomSizeChange();
						break;
					case inputGridSize.textField:
						__onBottomSizeChange();
						break;
					default:
				}
			}
		}
		private function __onClearBtnClick(event:Event):void
		{
			popEvent(ProjectEvent.CLEAR);
		}
		private function __onSaveBtnClick(event:Event):void
		{
			popEvent(ProjectEvent.SAVE);
		}

		private function __onExportBtnClick(event:Event):void
		{
			popEvent(ProjectEvent.EXPORT_IMAGE);
		}
		private function __onCodeBtnClick(event:Event):void
		{
			popEvent(ProjectEvent.EXPORT_CODE);
		}
		private function __onOpenBtnClick(event:Event):void
		{
			popEvent(ProjectEvent.OPEN);
		}
		private function __onResize(e:Event = null):void
		{
			window.height = DOM.stage.stageHeight - window.y;
		}
		private function __onBottomSizeChange(event:Event = null):void
		{
			popEvent(ProjectEvent.BOTTOM_SIZE_CHANGE, {xDms:uint(inputXDms.text),yDms:uint(inputYDms.text),gridSize:uint(inputGridSize.text)});
		}
		private function __onCBChange(event:Event = null):void
		{
			popEvent(ProjectEvent.GRID_SHOW_CHANGE, cbShowGrid.selected);
		}
		private function __onResetBtnClick(event:Event = null):void
		{
			popEvent(ProjectEvent.RESET_POSITION);
		}
	}
}