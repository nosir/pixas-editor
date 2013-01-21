package view 
{
	import base.DOM;
	import base.Param;
	import com.bit101.components.*;
	import com.risonhuang.pixas.math.ColorPattern;
	import com.risonhuang.pixas.math.Coord3D;
	import component.ColorButton;
	import component.NumericSlider;
	import events.PropertiesEvent;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.FocusEvent;
	import utils.CustomEventDispatcher;
	import utils.Dms;
	
	/**
	 * @author max
	 */
	public class Properties extends CustomEventDispatcher 
	{
		private var sp:Sprite;
		//component
		private var window:Window;
		private var scrollPane:ScrollPane;
		private var nameLabel:Label;
		private var xPosLabel:Label;
		private var yPosLabel:Label;
		private var zPosLabel:Label;
		private var xDmsLabel:Label;
		private var yDmsLabel:Label;
		private var zDmsLabel:Label;
		private var nameInputText:InputText;
		private var xPosNoStepper:NumericSlider;
		private var yPosNoStepper:NumericSlider;
		private var zPosNoStepper:NumericSlider;
		private var xDmsNoStepper:NumericSlider;
		private var yDmsNoStepper:NumericSlider;
		private var zDmsNoStepper:NumericSlider;
		private var alphaHUISlider:HUISlider;
		private var borderCheckBox:CheckBox;
		private var tallCheckBox:CheckBox;
		private var colorChooser:ColorChooser;
		private var myCheckBox:CheckBox;
		
		public function Properties() 
		{
			super(PropertiesEvent);
		}
		private function __onResize(e:Event = null):void
		{
			window.y = DOM.stage.stageHeight - window.height;
			window.width = DOM.stage.stageWidth - Param.LAYER_WIDTH - Param.PROJECT_WIDTH;
			scrollPane.update();
			scrollPane.width = window.width;
		}
		private function __onWinResize(e:Event = null):void
		{
			window.y = DOM.stage.stageHeight - window.height;
			popEvent(PropertiesEvent.HEIGHT_CHANGE, window.height);
		}
		public function init():void
		{
			sp = DOM.properties_sp;
			
			window = new Window(sp, 0, 0, "Properties");
			window.x = Param.PROJECT_WIDTH;
			window.draggable = false;
			window.hasCloseButton = false;
			window.hasMinimizeButton = true;
			window.addEventListener(Event.RESIZE, __onWinResize);
			
			scrollPane = new ScrollPane(window, 0, 0);
			scrollPane.autoHideScrollBar = true;
			scrollPane.dragContent = false;
			scrollPane.filters = [];
			scrollPane.height = window.height - window.titleBar.height;
			scrollPane.enabled = false;
			
			//all component
			nameLabel = new Label(scrollPane, 15, 10, "Name:");

			nameInputText = new InputText(scrollPane, nameLabel.x + nameLabel.width + 4, 10, "");
			nameInputText.width = 80;
			nameInputText.maxChars = Param.NAME_MAX_CHAR;
			nameInputText.textField.addEventListener(FocusEvent.MOUSE_FOCUS_CHANGE, __onNameInputChange);
			
			alphaHUISlider = new HUISlider(scrollPane, nameLabel.x, 30, "Alpha:", __onAlphaChange);
			alphaHUISlider.width = 152;
			alphaHUISlider.maximum = 1;
			alphaHUISlider.value = 1;
			alphaHUISlider.tick = 0.1;
			
			xPosLabel = new Label(scrollPane, nameInputText.x + nameInputText.width + 25, 10, "X Pos:");
			yPosLabel = new Label(scrollPane, nameInputText.x + nameInputText.width + 25, 30, "Y Pos:");
			zPosLabel = new Label(scrollPane, nameInputText.x + nameInputText.width + 25, 50, "Z Pos:");
			xPosNoStepper = new NumericSlider(scrollPane, xPosLabel.x + xPosLabel.width + 3, 14, __onPosChange);
			xPosNoStepper.setSliderParams(Param.MIN_POS, Param.MAX_POS, 0);
			xPosNoStepper.tick = 2;	
			yPosNoStepper = new NumericSlider(scrollPane, xPosLabel.x + xPosLabel.width + 3, 34, __onPosChange);
			yPosNoStepper.setSliderParams(Param.MIN_POS, Param.MAX_POS, 0);
			yPosNoStepper.tick = 2;
			zPosNoStepper = new NumericSlider(scrollPane, xPosLabel.x + xPosLabel.width + 3, 54, __onPosChange);
			zPosNoStepper.setSliderParams(Param.MIN_Z_POS, Param.MAX_Z_POS, 0);
			
			xDmsLabel = new Label(scrollPane, xPosNoStepper.width + xPosNoStepper.x + 25, 10, "X Dms:");
			yDmsLabel = new Label(scrollPane, xPosNoStepper.width + xPosNoStepper.x + 25, 30, "Y Dms:");
			zDmsLabel = new Label(scrollPane, xPosNoStepper.width + xPosNoStepper.x + 25, 50, "Z Dms:");
			
			xDmsNoStepper = new NumericSlider(scrollPane, xDmsLabel.x + xDmsLabel.width + 3, 14, __onXDmsChange);
			xDmsNoStepper.setSliderParams(6, 400, Param.CUBE_DEFAULT_X_DMS);
			xDmsNoStepper.tick = 2;			
			yDmsNoStepper = new NumericSlider(scrollPane, xDmsLabel.x + xDmsLabel.width + 3, 34, __onYDmsChange);
			yDmsNoStepper.setSliderParams(6, 400, Param.CUBE_DEFAULT_Y_DMS);
			yDmsNoStepper.tick = 2;			
			zDmsNoStepper = new NumericSlider(scrollPane, xDmsLabel.x + xDmsLabel.width + 3, 54, __onZDmsChange);
			zDmsNoStepper.setSliderParams(3, 400, Param.CUBE_DEFAULT_Z_DMS);
			correctPosInBound();
			
			colorChooser = new ColorChooser(scrollPane, xDmsNoStepper.width + xDmsNoStepper.x + 35, 10, 0xFFFFFF, __onColorChange);
			colorChooser.usePopup = true;
			colorChooser.popupAlign = ColorChooser.TOP;
			
			var colors_preset:Array =
				[
					0xBBBBBB, ColorPattern.GRAY,0xF3ECE0, 0xFFCEEC, 0xFEEAB4, 0xFFFFA3, 0xCEFFA0, 0x9EEDFF, 0xEEABFF,
					0x999999, 0xDDDDDD, 0xD0C6B3, ColorPattern.PINK, 0xF0D9B6, 0xEFEFBC,  0xC0EE95, 0x93D6E5, 0xE4CBEA,
					0x888888, 0xCCCCCC, 0xCEB689, ColorPattern.WINE_RED, 0xF2B291,
					ColorPattern.YELLOW, ColorPattern.GRASS_GREEN, ColorPattern.BLUE, ColorPattern.PURPLE
				];
			for (var i:uint = 0; i < colors_preset.length; i++ )
			{
				new ColorButton(scrollPane, colorChooser.x + (i % 9)*13, 30+Math.floor(i/9)*13, colors_preset[i], __onColorBtnClick);
			}
			
			borderCheckBox = new CheckBox(scrollPane, colorChooser.x + 137, 14, "Show Border",__onBorderChange);
			borderCheckBox.selected = true;
			
			tallCheckBox = new CheckBox(scrollPane, borderCheckBox.x, 34, "Tall Mode",__onTallChange);
			tallCheckBox.enabled = false;
			
			var hackSlideLable:Label = new Label(scrollPane, borderCheckBox.x + 60, 10, "label");
			hackSlideLable.visible = false;
			
			sp.addEventListener(Event.ENTER_FRAME, __onHackContentHeightEnterFrame );
		}
		private function __onHackContentHeightEnterFrame(e:Event):void
		{
			if (scrollPane.content.height < 70)
			{
				sp.removeEventListener(Event.ENTER_FRAME, __onHackContentHeightEnterFrame );
				DOM.stage.addEventListener(Event.RESIZE, __onResize);
				__onResize();
			}
		}
		//public
		public function minimize(_b:Boolean):void
		{
			window.minimized = _b;
		}
		public function lostFocus():void
		{
			scrollPane.enabled = false;
			nameInputText.text = "";
			xPosNoStepper.value = yPosNoStepper.value = zPosNoStepper.value = 0;
			xDmsNoStepper.value = yDmsNoStepper.value = zDmsNoStepper.value = Param.CUBE_DEFAULT_X_DMS;
			alphaHUISlider.value = 1;
			colorChooser.value = 0xFFFFFF;
		}
		public function updateC3D(_c3d:Coord3D):void
		{
			if (!scrollPane.enabled) { return; }
			xPosNoStepper.value = _c3d.x;
			yPosNoStepper.value = _c3d.y;
			zPosNoStepper.value = _c3d.z;
		}
		public function getFocus(_args:Object):void
		{
			scrollPane.enabled = true;
			nameInputText.text = _args.name;
			xPosNoStepper.value = _args.c3d.x;
			yPosNoStepper.value = _args.c3d.y;
			zPosNoStepper.value = _args.c3d.z;
			alphaHUISlider.value = _args.alpha;
			borderCheckBox.selected = _args.border;
			colorChooser.value = _args.color;
			xDmsNoStepper.value = _args.dms.xDms;
			yDmsNoStepper.value = _args.dms.yDms;
			zDmsNoStepper.value = _args.dms.zDms;
			tallCheckBox.selected = _args.dms.tall;
			//hide unavailable ones
			xDmsLabel.enabled = xDmsNoStepper.enabled = _args.type != 2;
			yDmsLabel.enabled = yDmsNoStepper.enabled = _args.type != 1 && _args.type != 4;
			zDmsLabel.enabled = zDmsNoStepper.enabled = _args.type != 0 && _args.type != 4 && _args.type != 5 && _args.type != 6 && _args.type != 7 && _args.type != 8;
			tallCheckBox.enabled = _args.type == 4;
		}
		public function correctPosInBound():void
		{
			xPosNoStepper.maximum = Param.MAX_POS - xDmsNoStepper.value;
			yPosNoStepper.maximum = Param.MAX_POS - yDmsNoStepper.value;
		}

		//event
		private function __onPosChange(event:Event):void
		{
			popEvent(PropertiesEvent.C3D_CHANGE, new Coord3D(xPosNoStepper.value,yPosNoStepper.value,zPosNoStepper.value));
		}
		private function __onNameInputChange(event:FocusEvent):void
		{
			popEvent(PropertiesEvent.NAME_CHANGE, nameInputText.text);
		}
		private function __onXDmsChange(event:Event):void
		{
			popEvent(PropertiesEvent.DMS_CHANGE, {type:Dms.X,value:xDmsNoStepper.value});
		}
		private function __onYDmsChange(event:Event):void
		{
			popEvent(PropertiesEvent.DMS_CHANGE, {type:Dms.Y,value:yDmsNoStepper.value});
		}
		private function __onZDmsChange(event:Event):void
		{
			popEvent(PropertiesEvent.DMS_CHANGE, {type:Dms.Z,value:zDmsNoStepper.value});
		}
		private function __onTallChange(event:Event):void
		{
			popEvent(PropertiesEvent.DMS_CHANGE, {type:Dms.TALL,value:tallCheckBox.selected});
		}
		private function __onBorderChange(event:Event):void
		{
			popEvent(PropertiesEvent.BORDER_CHANGE, borderCheckBox.selected);
		}
		private function __onColorChange(event:Event):void
		{
			popEvent(PropertiesEvent.COLOR_CHANGE, colorChooser.value);
		}
		private function __onAlphaChange(event:Event):void
		{
			popEvent(PropertiesEvent.ALPHA_CHANGE, alphaHUISlider.value);
		}
		private function __onColorBtnClick(event:Event):void
		{
			popEvent(PropertiesEvent.COLOR_CHANGE, event.target.value);
			colorChooser.value = event.target.value;
		}
		
	}

}