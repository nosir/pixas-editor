package view 
{
	import base.DOM;
	import base.Param;
	import com.bit101.components.CheckBox;
	import com.bit101.components.InputText;
	import com.bit101.components.Label;
	import com.bit101.components.ScrollPane;
	import com.bit101.components.Style;
	import com.risonhuang.pixas.objects.PixelObject;
	import events.LayerLineEvent;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.FocusEvent;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.filters.BitmapFilterQuality;
	import utils.CustomEventDispatcher;
	import utils.SpriteOpreator;
	
	/**
	 * ...
	 * @author max
	 */
	public class LayerLine extends CustomEventDispatcher 
	{
		private var index:uint;
		private var line:Sprite;
		private static var pmtOffsetX:uint = 10;
		private static var pmtOffsetY:uint = 5;
		private static var widthCB:uint = 24;
		private static var width:uint = 111;
		private static var height:uint = 24;
		private var right:Sprite;
		private var label:Label;
		private var inputText:InputText;
		private var showCB:CheckBox;
		
		public function LayerLine(_scrollPane:ScrollPane) 
		{
			super(LayerLineEvent);
			line = new Sprite();
			_scrollPane.addChild(line);
		}
		public function init(_args:Object):void
		{
			index = _args.index;
			var cbSelected:Boolean = _args.show;
			
			var left:Sprite = new Sprite();
			var backCB:Sprite = new Sprite();
			var faceCB:Sprite = new Sprite();
			
			faceCB.graphics.beginFill(Style.BUTTON_FACE);
			faceCB.graphics.drawRect(0, 0, widthCB - 2, height - 2);
			faceCB.graphics.endFill();
			faceCB.x = faceCB.y = 1;
			faceCB.filters = [SpriteOpreator.getShadow(1)];
			
			backCB.graphics.beginFill(Style.BACKGROUND);
			backCB.graphics.drawRect(0, 0, widthCB, height);
			backCB.graphics.endFill();
			backCB.filters = [SpriteOpreator.getShadow(2, true)];
			
			left.addChild(backCB);
			left.addChild(faceCB);
			showCB = new CheckBox(left, 7, 7, "", __onShowChange);
			showCB.selected = cbSelected;
			line.addChild(left);
			
			right = new Sprite();
			var back:Sprite = new Sprite();
			var face:Sprite = new Sprite();
			
			face.graphics.beginFill(Style.BUTTON_FACE);
			face.graphics.drawRect(0, 0, width - 2, height - 2);
			face.graphics.endFill();
			face.x = face.y = 1;
			face.filters = [SpriteOpreator.getShadow(1)];
			
			back.graphics.beginFill(Style.BACKGROUND);
			back.graphics.drawRect(0, 0, width, height);
			back.graphics.endFill();
			back.filters = [SpriteOpreator.getShadow(2, true)];
			
			right.addChild(back);
			right.addChild(face);
			
			var poThumb:PixelObject = _args.poThumb;
			switch (_args.type) 
			{
				case 0:
					poThumb.x = pmtOffsetX + 7;
					poThumb.y = pmtOffsetY + 3;
					break;
				case 1:
					poThumb.x = pmtOffsetX + 3;
					poThumb.y = pmtOffsetY + 9;
					break;
				case 2:
					poThumb.x = pmtOffsetX + 11;
					poThumb.y = pmtOffsetY + 9;
					break;
				case 3:
					poThumb.x = pmtOffsetX + 7;
					poThumb.y = pmtOffsetY + 7;
					break;
				case 4:
					poThumb.x = pmtOffsetX + 7;
					poThumb.y = pmtOffsetY + 4;
					break;
				case 5:
					poThumb.x = pmtOffsetX + 10;
					poThumb.y = pmtOffsetY + 7;
					break;
				case 6:
					poThumb.x = pmtOffsetX + 5;
					poThumb.y = pmtOffsetY + 7;
					break;
				case 7:
					poThumb.x = pmtOffsetX + 7;
					poThumb.y = pmtOffsetY + 7;
					break;
				case 8:
					poThumb.x = pmtOffsetX + 8;
					poThumb.y = pmtOffsetY + 7;
					break;
			}
			right.addChild(poThumb);
			
			label = new Label(right, 0, 0, _args.name);
			label.autoSize = false;
			label.width = 75;
			label.move(32, height / 2 - label.height / 2);
			right.addEventListener(MouseEvent.MOUSE_UP, __onLineMouseUp);
			right.addEventListener(MouseEvent.MOUSE_DOWN, __onLineMouseDown);
			right.addEventListener(MouseEvent.DOUBLE_CLICK, __onLabelDBClick);
			right.mouseChildren = false;
			right.doubleClickEnabled = true;
			right.x = left.x + left.width - 1;
			line.addChild(right);
			
			inputText = new InputText(line, 53, 4, label.text, __onInputChange);
			inputText.visible = false;
			inputText.width = 77;
			//imputtext
			inputText.maxChars = Param.NAME_MAX_CHAR;
			inputText.textField.addEventListener(FocusEvent.MOUSE_FOCUS_CHANGE, __onInputFocusOut);
		}
		public function updateLabel(_label:String):void
		{
			label.text = _label;
		}
		
		private function __onkeyUp(e:KeyboardEvent):void
		{
			if (e.keyCode == 13 && DOM.stage.focus == inputText.textField)
			{
				DOM.stage.removeEventListener(KeyboardEvent.KEY_UP, __onkeyUp);
				__onInputFocusOut();
			}
		}

		private function __onLabelDBClick(e:MouseEvent):void
		{
			inputText.visible = true;
			DOM.stage.focus = inputText.textField;
			inputText.textField.setSelection(inputText.textField.text.length, 0);
			DOM.stage.addEventListener(KeyboardEvent.KEY_UP, __onkeyUp);
		}
		private function __onInputChange(e:Event):void
		{
			label.text = e.target.text;
		}
		//event
		private function __onLineMouseUp(e:MouseEvent):void
		{
			DOM.stage.removeEventListener(MouseEvent.MOUSE_UP, __onLineMouseUp);
			popEvent(LayerLineEvent.LINE_MOUSE_UP, index);
		}
		private function __onLineMouseDown(e:MouseEvent):void
		{
			DOM.stage.addEventListener(MouseEvent.MOUSE_UP, __onLineMouseUp);
			popEvent(LayerLineEvent.LINE_MOUSE_DOWN, index);
		}
		private function __onInputFocusOut(e:FocusEvent = null):void
		{
			inputText.visible = false;
			popEvent(LayerLineEvent.LINE_NAME_CHANGE, {index:index,name:label.text,e:e});
		}
		private function __onShowChange(e:Event):void
		{
			popEvent(LayerLineEvent.LINE_SHOW_CHANGE, {index:index,selected:showCB.selected});
		}
		//public
		public function set x(_x:Number):void
		{
			line.x = _x;
		}
		
		public function get x():Number
		{
			return line.x ;
		}
		
		public function set y(_y:Number):void
		{
			line.y = _y;
		}
		
		public function get y():Number
		{
			return line.y ;
		}
		
		public function addFrame():void
		{
			SpriteOpreator.addFrame(line, BitmapFilterQuality.MEDIUM);
		}
		
		public function removeFrame():void
		{
			SpriteOpreator.removeFrame(line);
		}
		
		public function updateCBStatus(_b:Boolean):void
		{
			showCB.selected = _b;
		}
		public function getIndex():uint
		{
			return index;
		}
		public function getLine():Sprite
		{
			return line;
		}	
		public function destroy():void
		{
			right.removeEventListener(MouseEvent.CLICK, __onLineMouseUp);
			right.removeEventListener(MouseEvent.CLICK, __onLineMouseDown);
			right.removeEventListener(MouseEvent.DOUBLE_CLICK, __onLabelDBClick);
			inputText.textField.removeEventListener(FocusEvent.FOCUS_OUT, __onInputFocusOut);
			SpriteOpreator.removeAllChildren(line);
			line.parent.removeChild(line);
		}
	}

}