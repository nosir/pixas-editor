package command 
{
	import base.Param;
	import com.adobe.images.PNGEncoder;
	import com.risonhuang.pixas.objects.PixelObject;
	import component.Alert;
	import component.Confirm;
	import events.ProjectCommandEvent;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	import flash.net.FileFilter;
	import flash.net.FileReference;
	import flash.utils.ByteArray;
	import utils.CodeGenerator;
	import utils.CustomEventDispatcher;
	import utils.SpriteOpreator;
	
	/**
	 * @author max
	 */
	public class ProjectCommand extends CustomEventDispatcher 
	{
		private var loadFR:FileReference;
		private var fileFilter:FileFilter;
		private var tmpLayBox:Vector.<uint>;
		public static const X_DMS:String = "xDms";
		public static const Y_DMS:String = "yDms";
		public static const GRID_SIZE:String = "grid_size";
		public static const OUT:String = "out";
		
		public function ProjectCommand() 
		{
			super(ProjectCommandEvent);
		}
		public function checkInput(args:Object):void
		{
			var _xDms:uint = args.xDms;
			var _yDms:uint = args.yDms;
			var _gridSize:uint = args.gridSize;
			
			if (_xDms % 2 != 0)
			{
				Alert.show("The X Dms of Canvas must be even number!");
				popEvent(ProjectCommandEvent.INPUT_DENY, X_DMS);
				return;
			}
			
			if (_yDms % 2 != 0)
			{
				Alert.show("The Y Dms of Canvas must be even number!");
				popEvent(ProjectCommandEvent.INPUT_DENY, Y_DMS);
				return;
			}
			
			if (_xDms < 6)
			{
				Alert.show("The X Dms of Canvas must be larger than 6!");
				popEvent(ProjectCommandEvent.INPUT_DENY, X_DMS);
				return;
			}
			if (_yDms < 6)
			{
				Alert.show("The Y Dms of Canvas must be larger than 6!");
				popEvent(ProjectCommandEvent.INPUT_DENY, Y_DMS);
				return;
			}
			
			if (_gridSize % 2 != 0)
			{
				Alert.show("The Grid Size of Canvas must be even number!");
				popEvent(ProjectCommandEvent.INPUT_DENY, GRID_SIZE);
				return;
			}
			if (_gridSize < 6)
			{
				Alert.show("The Grid Size of Canvas must be larger than 6!");
				popEvent(ProjectCommandEvent.INPUT_DENY, GRID_SIZE);
				return;
			}
			
			popEvent(ProjectCommandEvent.INPUT_ACCEPT, args);
		}
		public function init():void 
		{
			loadFR = new FileReference();
			fileFilter = new FileFilter("Project File: (*.pixas)","*.pixas");
			loadFR.addEventListener(Event.SELECT, __onFileSelected);
			loadFR.addEventListener(Event.COMPLETE, __onFileLoadComplete);
		}
		public function clearCheck(_layerBox:Vector.<uint>):void
		{
			if (_layerBox.length == 0) { Alert.show(Param.ALERT_CANVAS_EMPTY); return; }
			Confirm.show(Param.CONFIRM_CLEAR,__onClearConfirm);
		}
		private function __onClearConfirm():void
		{
			popEvent(ProjectCommandEvent.CLEAR);
		}
		public function open(_layerBox:Vector.<uint>):void 
		{
			tmpLayBox = _layerBox;
			loadFR.browse([fileFilter]);
		}
		private function __onOpenConfirm():void
		{
			var ba:ByteArray = loadFR.data;
			popEvent(ProjectCommandEvent.FILE_OPEN, ba.readObject());
			ba.clear();
		}
		private function __onFileSelected(evt:Event):void
		{
			loadFR.load();
		}
		private function __onFileLoadComplete(evt:Event):void 
		{
			if (tmpLayBox.length > 0)
			{
				Confirm.show(Param.CONFIRM_OPEN + loadFR.name, __onOpenConfirm);
			}
			else 
			{
				__onOpenConfirm();
			}
			//trace("load complete");
		}
		public function exportCode(obj:Object,_layerBox:Vector.<uint>):void 
		{
			if (_layerBox.length == 0) { Alert.show(Param.ALERT_CANVAS_EMPTY); return; }
			var fr:FileReference = new FileReference();
			fr.save(CodeGenerator.generate(obj), Param.CODE_NAME);
		}
		public function save(obj:Object,_layerBox:Vector.<uint>):void 
		{
			if (_layerBox.length == 0) { Alert.show(Param.ALERT_CANVAS_EMPTY); return; }
			
			var fr:FileReference = new FileReference();
			var ba:ByteArray = new ByteArray();
			ba.writeObject(obj);
			fr.save(ba, Param.SAVE_NAME);
			ba.clear();
		}
		public function exportImage(_source:Sprite,_activeBox:Vector.<uint>, _layerBox:Vector.<uint>,_poBox:Vector.<PixelObject>):void
		{
			if (_layerBox.length == 0){Alert.show(Param.ALERT_CANVAS_EMPTY);return;}
			
			_activeBox.forEach(function(item:uint, index:int, vector:Vector.<uint>):void{SpriteOpreator.removeFrame(_poBox[item])});
			
			var bounds:Rectangle = _source.getBounds(_source);
			//hack flash png import bug when the bounds pixels are not transparnt
			bounds.x -= 1;
			bounds.y -= 1;
			bounds.width += 2;
			bounds.height += 2;
			var mtx:Matrix = new Matrix(1, 0, 0, 1, -bounds.x, -bounds.y);
			var bmd:BitmapData = new BitmapData(bounds.width, bounds.height,true,0x00000000);
			bmd.draw(_source,mtx);
			var ba:ByteArray = PNGEncoder.encode(bmd);
			var fr:FileReference = new FileReference();
			fr.save(ba, Param.EXPORT_NAME);
			bmd.dispose();
			ba.clear();
			
			_activeBox.forEach(function(item:uint, index:int, vector:Vector.<uint>):void{SpriteOpreator.addFrame(_poBox[item])});
		}
	}
}