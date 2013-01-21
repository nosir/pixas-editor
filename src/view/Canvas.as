package view 
{
	import base.*;
	import com.risonhuang.pixas.colors.*;
	import com.risonhuang.pixas.dimensions.*;
	import com.risonhuang.pixas.math.*;
	import com.risonhuang.pixas.objects.*;
	import com.risonhuang.pixas.objects.primitives.*;
	import events.*;
	import fl.transitions.*;
	import fl.transitions.easing.*;
	import flash.display.*;
	import flash.events.*;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import model.DataAddMode;
	import utils.*;
	/**
	 * @author max
	 */
	public class Canvas extends CustomEventDispatcher
	{
		private var sp:Sprite;
		private var content:Sprite;
		private var hitter:Sprite;
		private var bg:Sprite;
		private var bottom:Sprite;
		private var bound:Sprite;
		private var paper:PixelObject;
		private var grid:PixelObject;
		private var top:Sprite;
		private var xDms:uint;
		private var yDms:uint;
		private var gridSize:uint;
		private var mouseTarget:Object;
		private var marchingAntsRect:MarchingAntsRect;
		private var ants:Sprite;
		private var rect:Rectangle;
		
		public function Canvas() 
		{
			super(CanvasEvent);
		}
		
		public function init():void
		{
			sp = DOM.canvas_sp;
			bottom = new Sprite();
			hitter = new Sprite();
			bg = new Sprite();
			content = new Sprite();
			grid = new PixelObject();
			paper = new PixelObject();
			top = new Sprite();
			ants = new Sprite();
			marchingAntsRect = new MarchingAntsRect(ants);
			sp.addChild(hitter);
			sp.addChild(bg);
			sp.addChild(content);
			bg.graphics.beginFill(Param.BG_COLOR);
			bg.graphics.drawRect(0, 0, 100, 100);
			buildBound();
			content.addChild(bound);
			content.addChild(bottom);
			content.addChild(top);
			bottom.addChild(paper);
			bottom.addChild(grid);
			sp.addChild(ants);
			
			//-sp
			//	-ants
			//	-content
			//		-top
			//			-cube
			//			-...
			//		-bottom
			//			-grid
			//			-paper
			//		-bound
			//	-bg
			//	-hitter
			////
			
			gridSize = Param.GRID_SIZE;
			xDms = Param.GRID_X_WIDTH;
			yDms = Param.GRID_Y_WIDTH;
			
			buildBottom();
			
			DOM.stage.addEventListener(Event.RESIZE, __onResize);
			setScale(Param.ZOOM);
			center();
			__onResize();
		}
		public function startFrame():void
		{
			rect = new Rectangle(sp.mouseX,sp.mouseY,0,0);
			sp.addEventListener(MouseEvent.MOUSE_MOVE,__onMouseMove);
			marchingAntsRect.start();
		}
		public function destroyFrame():void
		{
			hitter.graphics.clear();
			sp.removeEventListener(MouseEvent.MOUSE_MOVE, __onMouseMove);
			marchingAntsRect.destroy();
		}
		private function __onMouseMove(e:MouseEvent):void
		{
			rect.bottomRight = new Point(sp.mouseX, sp.mouseY);
			marchingAntsRect.draw(rect);
			hitter.graphics.clear();
			hitter.graphics.beginFill(Param.BG_COLOR);
			hitter.graphics.drawRect(rect.x, rect.y, rect.width, rect.height);
			popEvent(CanvasEvent.FRAME_MOVE,hitter);
		}
		
		public function getDrawContent():Sprite
		{
			return top;
		}
		private function __onResize(e:Event = null):void
		{
			bg.width = DOM.stage.stageWidth;
			bg.height = DOM.stage.stageHeight;
			if (content.scaleX == 1)
			{
				center();
			}
		}
		public function center():void
		{
			content.x = Param.PROJECT_WIDTH + Math.floor((DOM.stage.stageWidth - Param.PROJECT_WIDTH - Param.LAYER_WIDTH  )/ 2);
			content.y = Param.CANVAS_Z_SPACE;
		}
		public function updateBottomSize(args:Object):void
		{
			xDms = args.xDms;
			yDms = args.yDms;
			gridSize =args.gridSize;
			buildBottom();
		}
		public function setScale(_s:uint):void
		{
			var xc:Number = Param.PROJECT_WIDTH + (DOM.stage.stageWidth - Param.PROJECT_WIDTH - Param.LAYER_WIDTH) / 2;
			var yc:Number = (DOM.stage.stageHeight -  Param.PROPERTIES_HEIGHT)/ 2;
			content.x = Math.round(_s / content.scaleX * (content.x - xc) + xc);
			content.y = Math.round(_s / content.scaleY * (content.y - yc) + yc);
			content.scaleX = content.scaleY = _s;
			if (_s == 1)
			{
				center();
			}
		}
		public function setGridVisible(_b:Boolean):void
		{
			grid.visible = paper.visible = _b;
		}
		public function addItem(_args:Object):void
		{
			var po:PixelObject = _args.po as PixelObject;
			top.addChild(po);
			po.position = _args.c3d;
			if (_args.mode != DataAddMode.RESUME)
			{
				var tween:Tween = new Tween(po, "y", Regular.easeOut, po.y -40, po.y, 0.3, true);
			}
			po.visible = _args.show;
		}
		public function reset():void
		{
			SpriteOpreator.removeAllChildren(top);
		}
		public function resortTop(_layerBox:Vector.<uint>,_poBox:Vector.<PixelObject>):void
		{
			SpriteOpreator.removeAllChildren(top);
			_layerBox.forEach(function(item:uint, index:int, vector:Vector.<uint>):void{top.addChild(_poBox[item])});
		}
		public function bottomMouseDown():void
		{
			content.startDrag();
		}
		public function bottomMouseUp():void
		{
			content.stopDrag();
			SpriteOpreator.roundPos(content);
		}
		
		private function buildBottom():void
		{
			//trim dms
			if (xDms % gridSize > 0 || yDms % gridSize > 0)
			{
				xDms = Math.ceil(xDms / gridSize) * gridSize;
				yDms = Math.ceil(yDms / gridSize) * gridSize;
			}
			
			//buildPaper
			paper.removeAllChildren()
			
			//var hack_xDms:uint = xDms + 2;
			//var hack_yDms:uint = yDms + 2;
			var brickPaper:Brick = new Brick(new BrickDms(xDms,yDms),new SideColor(Param.CANVAS_FILL_COLOR,Param.CANVAS_FILL_COLOR));
			paper.addChild(new PixelObject(brickPaper));
			
			//buildGrid
			grid.removeAllChildren();
			
			var iLim:uint = Math.floor(xDms / gridSize);
			var jLim:uint = Math.floor(yDms / gridSize);
			//var hack_size:uint = gridSize + 2;
			var brickGrid:Brick = new Brick(new BrickDms(gridSize, gridSize),new SideColor(Param.CANVAS_GRID_COLOR,Param.CANVAS_FILL_COLOR));
			for (var i:uint = 0; i < iLim; i++ )
			{
				for (var j:uint = 0; j < jLim; j++ )
				{
					grid.addChild(new PixelObject(brickGrid, new Coord3D(i*gridSize,j*gridSize)));
				}
			}			
		}
		private function buildBound():void
		{
			var brickBound:Brick = new Brick(new BrickDms(Param.MAX_POS - Param.MIN_POS, Param.MAX_POS - Param.MIN_POS), new SideColor(Param.BOUND_COLOR, Param.BOUND_COLOR));
			bound = new PixelObject(brickBound, new Coord3D(Param.MIN_POS, Param.MIN_POS, 0));
		}		
	}
}