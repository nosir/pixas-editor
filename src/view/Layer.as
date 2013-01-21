package view 
{
	/**
	 * @author max
	 */
	import com.bit101.components.*;
	import com.risonhuang.pixas.objects.PixelObject;
	import events.LayerEvent;
	import events.LayerLineEvent;
	import fl.transitions.easing.Regular;
	import fl.transitions.Tween;
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.events.Event;
	import base.*;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import model.DataAddMode;
	import utils.SpriteOpreator;
	import utils.CustomEventDispatcher;
	
	public class Layer extends CustomEventDispatcher
	{
		
		private var window:Window;
		private var scrollPane:ScrollPane;
		private var lines:Vector.<LayerLine>;
		private var allCB:CheckBox;
		private var delBtn:PushButton;
		private var copyBtn:PushButton;
		private var lineClickFlag:Boolean;
		
		public function Layer() 
		{
			super(LayerEvent);
		}
		
		public function init():void
		{
			lineClickFlag = false;
			
			lines = new Vector.<LayerLine>;
			
			window = new Window(DOM.layer_sp, 0, 0, "Layers");
			window.draggable = false;
			window.width = Param.LAYER_WIDTH;
			window.hasCloseButton = false;
			window.hasMinimizeButton = true;
			
			var topBar:Sprite = new Sprite();
			window.addChild(topBar);
		
			allCB = new CheckBox(topBar, 16, 16, "", __onAllCBChange);
			allCB.selected = true;
			allCB.enabled = false;

			copyBtn = new PushButton(topBar, 107, 10, "", __onCopyBtnClick);
			copyBtn.border = false;
			copyBtn.width = 24;
			copyBtn.enabled = false;
			var copyImg:Bitmap = new EmbedAssets.CopyImg() as Bitmap;
			copyImg.x = 4;
			copyImg.y = 3;
			copyBtn.addChild(copyImg);

			delBtn = new PushButton(topBar, 132, 10, "", __onDelBtnClick);
			delBtn.border = false;
			delBtn.width = 21;
			delBtn.enabled = false;
			var delImg:Bitmap = new EmbedAssets.DelImg() as Bitmap;
			delImg.x = 5;
			delImg.y = 3;
			delBtn.addChild(delImg);
			
			
			scrollPane = new ScrollPane(window, 0, 38);
			scrollPane.autoHideHScrollBar = true;
			scrollPane.dragContent = false;
			scrollPane.filters = [];
			scrollPane.background.addEventListener(MouseEvent.CLICK, __onLayerBackgroundClick);
			DOM.stage.addEventListener(Event.RESIZE, __onResize);
			__onResize();
		}
		private function __onResize(e:Event = null):void
		{
			//remove temporary avoid endless loop when set window.height
			window.removeEventListener(Event.RESIZE, __onResize);
			window.height = DOM.stage.stageHeight;
			window.x = DOM.stage.stageWidth - window.width;
			scrollPane.height = window.height - window.titleBar.height - scrollPane.y;
			scrollPane.width = window.width;
			window.addEventListener(Event.RESIZE, __onResize);
		}
		public function addItem(_args:Object,_layerBox:Vector.<uint>):void
		{
			var line:LayerLine = new LayerLine(scrollPane);
			line.addEventListener(LayerLineEvent.LINE_MOUSE_DOWN, __onLineMouseDown);
			line.addEventListener(LayerLineEvent.LINE_MOUSE_UP, __onLineMouseUp);
			line.addEventListener(LayerLineEvent.LINE_SHOW_CHANGE, __onLineShowChange);
			line.addEventListener(LayerLineEvent.LINE_NAME_CHANGE, __onLineNameChange);
			line.init(_args);
			line.x = 10;
			lines.push(line);
			allCB.enabled = true;
			
			_layerBox.forEach(function(item:uint, index:int, vector:Vector.<uint>):void 
			{
				lines[item].y = (_layerBox.length - index - 1) * (Param.LINE_HEIGHT + Param.PO_LINE_SPACE) + Param.LIST_TOP_SPACE;
			});
			
			scrollPane.update();
		}
		public function updateNameAt(_index:uint,_name:String):void
		{
			lines[_index].updateLabel(_name);
		}
		public function addFrameAt(_activeBox:Vector.<uint>):void
		{
			lines.forEach(function(item:LayerLine, index:int, vector:Vector.<LayerLine>):void{item.removeFrame()});
			_activeBox.forEach(function(item:uint, index:int, vector:Vector.<uint>):void{lines[item].addFrame();});
			delBtn.enabled = (_activeBox.length > 0);
			copyBtn.enabled = _activeBox.length == 1;
		}
		public function updateAllCBStatus(_b:Boolean):void
		{
			lines.forEach(function(item:LayerLine, index:int, vector:Vector.<LayerLine>):void{item.updateCBStatus(_b)});
		}
		public function minimize(_b:Boolean):void
		{
			window.minimized = _b;
		}
		public function reset():void
		{
			lines.forEach(function(item:LayerLine, index:int, vector:Vector.<LayerLine>):void{try { destroyLine(item); } catch (e:Error) {}});
			lines = new Vector.<LayerLine>;
			allCB.enabled = delBtn.enabled = copyBtn.enabled = false;
		}
		public function updateLayer(_args:Object):void
		{
			var _layerBox:Vector.<uint> = _args.layerBox;
			lines.forEach(function(item:LayerLine, index:int, vector:Vector.<LayerLine>):void
			{
				var testIndex:int = _layerBox.indexOf(item.getIndex());
				if (testIndex < 0)
				{
					try { destroyLine(item); } catch (e:Error) {}
				}
				else
				{
					var newY:int = (_layerBox.length - 1 - testIndex) * (Param.LINE_HEIGHT + Param.PO_LINE_SPACE) + Param.LIST_TOP_SPACE;
					if (_args.mode != DataAddMode.COPY)
					{
						var tween:Tween = new Tween(item, "y", Regular.easeOut, item.y, newY, 0.3, true);
					}
					else
					{
						item.y = newY;
					}
				}
			} );
			allCB.enabled = (_layerBox.length > 0);
			scrollPane.update();
		}
		private function destroyLine(_line:LayerLine):void
		{
			_line.destroy();
			_line.removeEventListener(LayerLineEvent.LINE_MOUSE_DOWN, __onLineMouseDown);
			_line.removeEventListener(LayerLineEvent.LINE_MOUSE_UP, __onLineMouseUp);
			_line.removeEventListener(LayerLineEvent.LINE_SHOW_CHANGE, __onLineShowChange);
			_line.removeEventListener(LayerLineEvent.LINE_NAME_CHANGE, __onLineNameChange);
		}
		//event
		private function __onLayerBackgroundClick(e:Event):void
		{
			if (!lineClickFlag) { popEvent(LayerEvent.BACKGROUND_CLICK);}
			lineClickFlag = false;
		}
		private function __onAllCBChange(e:Event):void
		{
			popEvent(LayerEvent.ITEMS_VISIBLE_CHANGE, allCB.selected);
		}
		private function __onCopyBtnClick(e:Event):void
		{
			popEvent(LayerEvent.ITEM_COPY);
		}
		private function __onDelBtnClick(e:Event):void
		{
			popEvent(LayerEvent.ITEM_DELETE);
		}
		private function __onLineNameChange(e:LayerLineEvent):void
		{
			lineClickFlag = e.args.e!=null;
			popEvent(LayerEvent.LINE_NAME_CHANGE, e.args);
		}
		private function __onLineMouseUp(e:LayerLineEvent):void
		{
			//action from children
			var _line:LayerLine = lines[e.args];
			_line.getLine().stopDrag();
			popEvent(LayerEvent.LINE_MOUSE_UP, {targetIndex:e.args,stopY:_line.y});
		}
		private function __onLineMouseDown(e:LayerLineEvent):void
		{
			//action from children
			//swap depth to top layer
			scrollPane.addChild(lines[e.args].getLine());
			lines[e.args].getLine().startDrag(false, new Rectangle(10, -100, 0, 2000));
			popEvent(LayerEvent.LINE_MOUSE_DOWN, e.args);
		}
		private function __onLineShowChange(e:LayerLineEvent):void
		{
			popEvent(LayerEvent.LINE_SHOW_CHANGE, e.args);
		}
	}

}