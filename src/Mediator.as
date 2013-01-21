package  
{
	import base.*;
	import command.*;
	import events.*;
	import flash.display.Sprite;
	import model.*;
	import utils.*;
	import view.*;
	/**
	 * @author max
	 */
	public class Mediator 
	{
		private var primitives:Primitives;
		private var project:Project;
		private var layer:Layer;
		private var canvas:Canvas;
		private var floatMenu:FloatMenu;
		private var properties:Properties;
		private var about:About;
		private var toolMode:ToolMode;
		private var dataStorage:DataStorage;
		private var keyCommand:KeyCommand;
		private var layerCommand:LayerCommand;
		private var canvasCommand:CanvasCommand;
		private var propertiesCommand:PropertiesCommand;
		private var projectCommand:ProjectCommand;
		private var rightMenuCommand:RightMenuCommand;
	
		public function Mediator(_timeline:Sprite) 
		{
			DOM.init(_timeline);
			
			keyCommand = new KeyCommand();
			keyCommand.addEventListener(KeyCommandEvent.TAB, __onKeyCommandTab);
			keyCommand.addEventListener(KeyCommandEvent.DEL, __onKeyCommandDel);
			keyCommand.addEventListener(KeyCommandEvent.CTRL_A, __onKeyCommandCtrlA);
			keyCommand.addEventListener(KeyCommandEvent.CTRL_D, __onKeyCommandCtrlD);
			keyCommand.addEventListener(KeyCommandEvent.CTRL_ZOOM, __onKeyCommandCtrlZoom);
			keyCommand.addEventListener(KeyCommandEvent.ARROW, __onKeyCommandArrow);
			keyCommand.addEventListener(KeyCommandEvent.MODE, __onKeyCommandMode);
			keyCommand.init();
			
			rightMenuCommand = new RightMenuCommand();
			rightMenuCommand.addEventListener(RightMenuCommandEvent.ZOOM, __onRightMenuCommandZoom);
			rightMenuCommand.init();
			
			dataStorage = new DataStorage();
			dataStorage.addEventListener(DataStorageEvent.ITEM_ADD, __onDataStorageItemAdd);
			dataStorage.addEventListener(DataStorageEvent.ACTIVE_BOX_UPDATE, __onDataStorageActiveBoxUpdate);
			dataStorage.addEventListener(DataStorageEvent.LAYER_BOX_UPDATE, __onDataStorageLayerBoxUpdate);
			dataStorage.addEventListener(DataStorageEvent.RESET, __onDataStorageReset);
			dataStorage.init();
			
			toolMode = new ToolMode();
			toolMode.addEventListener(ToolModeEvent.SET, __onToolModeSet);
			toolMode.init();
			
			floatMenu = new FloatMenu();
			floatMenu.addEventListener(FloatMenuEvent.UNLOCK_AXIS_CHANGE, __onFloatMenuUnlockChange);
			floatMenu.addEventListener(FloatMenuEvent.ZOOM_CHANGE, __onFloatMenuZoomChange);
			floatMenu.addEventListener(FloatMenuEvent.ABOUT_CLICK, __onFloatMenuAboutClick);
			floatMenu.addEventListener(FloatMenuEvent.MODE_CHANGE, __onFloatMenuModeChange);
			floatMenu.init();
			
			about = new About();
			about.init();
			
			propertiesCommand = new PropertiesCommand();
			propertiesCommand.addEventListener(PropertiesCommandEvent.LOST_FOCUS, __onPropertiesCommandLostFocus);
			propertiesCommand.addEventListener(PropertiesCommandEvent.GET_FOCUS, __onPropertiesCommandGetFocus);
			propertiesCommand.init();			
			properties = new Properties();
			properties.addEventListener(PropertiesEvent.NAME_CHANGE, __onPropertiesNameChange);
			properties.addEventListener(PropertiesEvent.DMS_CHANGE, __onPropertiesDmsChange);
			properties.addEventListener(PropertiesEvent.ALPHA_CHANGE, __onPropertiesAlphaChange);
			properties.addEventListener(PropertiesEvent.COLOR_CHANGE, __onPropertiesColorChange);
			properties.addEventListener(PropertiesEvent.BORDER_CHANGE, __onPropertiesBorderChange);
			properties.addEventListener(PropertiesEvent.C3D_CHANGE, __onPropertiesC3DChange);
			properties.addEventListener(PropertiesEvent.HEIGHT_CHANGE, __onPropertiesHeightChange);
			properties.init();
			
			canvasCommand = new CanvasCommand();
			canvasCommand.addEventListener(CanvasCommandEvent.MOUSE_DOWN, __onCanvasCommandMouseDown);
			canvasCommand.addEventListener(CanvasCommandEvent.MOUSE_UP, __onCanvasCommandMouseUp);
			canvasCommand.addEventListener(CanvasCommandEvent.C3D_UPDATE_IN_BOUND, __onCanvasCommandC3DUpdateInBound);
			canvasCommand.addEventListener(CanvasCommandEvent.C3D_UPDATE, __onCanvasCommandC3DUpdate);
			canvasCommand.addEventListener(CanvasCommandEvent.C3D_OEF_CHANGE, __onCanvasCommandC3DOefChange);
			canvasCommand.addEventListener(CanvasCommandEvent.BOTTOM_MOUSE_DOWN, __onCanvasCommandBottonMouseDown);
			canvasCommand.addEventListener(CanvasCommandEvent.BOTTOM_MOUSE_UP, __onCanvasCommandBottonMouseUp);
			canvasCommand.addEventListener(CanvasCommandEvent.ITEM_MOUSE_DOWN, __onCanvasCommandItemMouseDown);
			canvasCommand.addEventListener(CanvasCommandEvent.ITEM_MOUSE_UP, __onCanvasCommandItemMouseUp);
			canvasCommand.addEventListener(CanvasCommandEvent.FRAME_MOUSE_DOWN, __onCanvasCommandFrameMouseDown);
			canvasCommand.addEventListener(CanvasCommandEvent.FRAME_MOUSE_UP, __onCanvasCommandFrameMouseUp);
			canvasCommand.addEventListener(CanvasCommandEvent.ACTIVE_UPDATE, __onCanvasCommandActiveUpdate);
			canvasCommand.init();
			
			canvas = new Canvas();
			canvas.addEventListener(CanvasEvent.FRAME_MOVE, __onCanvasFrameMove);
			canvas.init();
			
			layerCommand = new LayerCommand();
			layerCommand.addEventListener(LayerCommandEvent.RESORT, __onLayerCommandResort);
			layerCommand.addEventListener(LayerCommandEvent.DEL, __onLayerCommandDel);
			layerCommand.addEventListener(LayerCommandEvent.ACTIVE_FILTER, __onLayerCommandActiveFilter);
			layerCommand.init();				
			layer = new Layer();
			layer.addEventListener(LayerEvent.ITEM_COPY, __onLayerItemCopy);
			layer.addEventListener(LayerEvent.ITEM_DELETE, __onLayerItemDelete);
			layer.addEventListener(LayerEvent.ITEMS_VISIBLE_CHANGE, __onLayerItemsVisibleChange);
			layer.addEventListener(LayerEvent.LINE_MOUSE_DOWN, __onLayerLineMouseDown);
			layer.addEventListener(LayerEvent.LINE_MOUSE_UP, __onLayerLineMouseUp);
			layer.addEventListener(LayerEvent.LINE_SHOW_CHANGE, __onLayerLineShowChange);
			layer.addEventListener(LayerEvent.LINE_NAME_CHANGE, __onLayerLineNameChange);
			layer.addEventListener(LayerEvent.BACKGROUND_CLICK, __onLayerBackgroundClick);
			layer.init();
			
			projectCommand = new ProjectCommand();
			projectCommand.addEventListener(ProjectCommandEvent.FILE_OPEN, __onProjectCommandFileOpen);
			projectCommand.addEventListener(ProjectCommandEvent.CLEAR, __onProjectCommandClear);
			projectCommand.addEventListener(ProjectCommandEvent.INPUT_ACCEPT, __onProjectCommandInputAccept);
			projectCommand.addEventListener(ProjectCommandEvent.INPUT_DENY, __onProjectCommandInputDeny);
			projectCommand.init();
			project = new Project();
			project.addEventListener(ProjectEvent.BOTTOM_SIZE_CHANGE, __onProjectBottomSizeChange);
			project.addEventListener(ProjectEvent.GRID_SHOW_CHANGE, __onProjectGridShowChange);
			project.addEventListener(ProjectEvent.RESET_POSITION, __onProjectResetPosition);
			project.addEventListener(ProjectEvent.EXPORT_IMAGE, __onProjectExportImage);
			project.addEventListener(ProjectEvent.EXPORT_CODE, __onProjectExportCode);
			project.addEventListener(ProjectEvent.SAVE, __onProjectSave);
			project.addEventListener(ProjectEvent.OPEN, __onProjectOpen);
			project.addEventListener(ProjectEvent.CLEAR, __onProjectClear);
			project.init();
			
			primitives = new Primitives();
			primitives.addEventListener(PrimitivesEvents.SIZE_CHANGE, __onPrimitivesSizeChange);
			primitives.addEventListener(PrimitivesEvents.ITEM_CLICK, __onPrimitivesItemClick);
			primitives.init();
		}
		
		//datastorage listener
		private function __onDataStorageReset(e:DataStorageEvent):void
		{
			layer.reset();
			canvas.reset();
			properties.lostFocus();
		}
		private function __onDataStorageLayerBoxUpdate(e:DataStorageEvent):void
		{
			layer.updateLayer(e.args);
			canvas.resortTop(e.args.layerBox, dataStorage.getPoBox());
			propertiesCommand.checkFocus(dataStorage.getActiveBox());
		}
		private function __onDataStorageActiveBoxUpdate(e:DataStorageEvent):void
		{
			canvasCommand.addFrameAt(e.args, dataStorage.getPoBox());
			layer.addFrameAt(e.args);
			propertiesCommand.checkFocus(e.args);
		}
		private function __onDataStorageItemAdd(e:DataStorageEvent):void
		{
			canvas.addItem(e.args);
			layer.addItem(e.args,dataStorage.getLayerBox());
		}
		
		//keycommand listener
		private function __onKeyCommandTab(e:KeyCommandEvent):void
		{
			primitives.minimize(e.args);
			layer.minimize(e.args);
			project.minimize(e.args);
			properties.minimize(e.args);
		}
		private function __onKeyCommandDel(e:KeyCommandEvent):void
		{
			layerCommand.delCheck(dataStorage.getActiveBox());
		}
		private function __onKeyCommandCtrlD(e:KeyCommandEvent):void
		{
			dataStorage.copyLayer();
		}
		private function __onKeyCommandCtrlA(e:KeyCommandEvent):void
		{
			dataStorage.updateActiveBox(dataStorage.getLayerBox());
		}
		private function __onKeyCommandCtrlZoom(e:KeyCommandEvent):void
		{
			floatMenu.updateZoomValue(e.args);
		}
		private function __onKeyCommandArrow(e:KeyCommandEvent):void
		{
			canvasCommand.updatePosByArrow(e.args,dataStorage.getActiveBox(),dataStorage.getPoBox(),dataStorage.getCoord3DBox());
		}
		private function __onKeyCommandMode(e:KeyCommandEvent):void
		{
			toolMode.setMode(e.args);
		}
		
		//right menu listener
		private function __onRightMenuCommandZoom(e:RightMenuCommandEvent):void
		{
			floatMenu.updateZoomValue(e.args);
		}
		
		//tool mode
		private function __onToolModeSet(e:ToolModeEvent):void
		{
			floatMenu.updateTool(e.args);
			canvasCommand.updateTool(e.args);
		}
		
		//float menu
		private function __onFloatMenuModeChange(e:FloatMenuEvent):void
		{
			toolMode.setMode(e.args);
		}
		private function __onFloatMenuAboutClick(e:FloatMenuEvent):void
		{
			about.show();
		}
		private function __onFloatMenuZoomChange(e:FloatMenuEvent):void
		{
			canvas.setScale(e.args);
		}
		private function __onFloatMenuUnlockChange(e:FloatMenuEvent):void
		{
			canvasCommand.updateUnlockAxis(e.args);
		}
		
		//properties command listener
		private function __onPropertiesCommandLostFocus(e:PropertiesCommandEvent):void
		{
			properties.lostFocus();
		}
		private function __onPropertiesCommandGetFocus(e:PropertiesCommandEvent):void
		{
			properties.getFocus(dataStorage.getDataByIndex(e.args));
		}		
		//properties listener
		private function __onPropertiesColorChange(e:PropertiesEvent):void
		{
			dataStorage.updateColor(propertiesCommand.getFocusIndex(),e.args);
		}
		private function __onPropertiesBorderChange(e:PropertiesEvent):void
		{
			dataStorage.updateBorder(propertiesCommand.getFocusIndex(),e.args);
		}
		private function __onPropertiesAlphaChange(e:PropertiesEvent):void
		{
			dataStorage.updateAlpha(propertiesCommand.getFocusIndex(),e.args);
		}		
		private function __onPropertiesDmsChange(e:PropertiesEvent):void
		{
			properties.correctPosInBound();
			dataStorage.updateDms(propertiesCommand.getFocusIndex(), e.args);
			canvasCommand.correctPosInBound(propertiesCommand.getFocusIndex(),dataStorage.getPoBox(),dataStorage.getDmsBox());
		}	
		private function __onPropertiesNameChange(e:PropertiesEvent):void
		{
			dataStorage.updateName(propertiesCommand.getFocusIndex(), e.args);
			layer.updateNameAt(propertiesCommand.getFocusIndex(), e.args);
		}
		private function __onPropertiesC3DChange(e:PropertiesEvent):void
		{
			dataStorage.updateC3D(propertiesCommand.getFocusIndex(), e.args);
		}	
		private function __onPropertiesHeightChange(e:PropertiesEvent):void
		{
			floatMenu.updatePos(e.args);
		}	
		
		//layer command listener 
		private function __onLayerCommandActiveFilter(e:LayerCommandEvent):void
		{
			dataStorage.updateActiveBox(e.args.activeBox);
			if (e.args.canvasMouseDownBubble)
			{
				canvasCommand.itemMouseDown(e.args.index,e.args.activeBox,dataStorage.getPoBox(),dataStorage.getCoord3DBox());
			}
		}
		private function __onLayerCommandResort(e:LayerCommandEvent):void
		{
			dataStorage.updateLayerBox(e.args);
		}			
		private function __onLayerCommandDel(e:LayerCommandEvent):void
		{
			dataStorage.deleteActiveLayer();
		}
		
		//layer listener
		private function __onLayerBackgroundClick(e:LayerEvent):void
		{
			dataStorage.resetActiveBox();
		}
		private function __onLayerLineMouseDown(e:LayerEvent):void
		{
			layerCommand.filterActive(e.args, dataStorage.getLayerBox(),dataStorage.getActiveBox(),keyCommand);
		}
		private function __onLayerLineMouseUp(e:LayerEvent):void
		{
			layerCommand.resort(e.args.targetIndex, e.args.stopY,dataStorage.getLayerBox());
		}
		private function __onLayerLineShowChange(e:LayerEvent):void
		{
			dataStorage.updateShow(e.args.index, e.args.selected);
		}
		private function __onLayerLineNameChange(e:LayerEvent):void
		{
			dataStorage.updateName(e.args.index, e.args.name);
			propertiesCommand.checkFocus(dataStorage.getActiveBox());
		}
		private function __onLayerItemCopy(e:LayerEvent):void
		{
			dataStorage.copyLayer();
		}
		private function __onLayerItemDelete(e:LayerEvent):void
		{
			layerCommand.delCheck(dataStorage.getActiveBox());
		}
		private function __onLayerItemsVisibleChange(e:LayerEvent):void
		{
			dataStorage.updateShowAll(e.args);
			layer.updateAllCBStatus(e.args);
		}
		
		//canvas command listener
		private function __onCanvasCommandC3DOefChange(e:CanvasCommandEvent):void
		{
			properties.updateC3D(e.args);
		}
		private function __onCanvasCommandC3DUpdateInBound(e:CanvasCommandEvent):void
		{
			dataStorage.updateC3D(e.args.index, e.args.c3d);
		}
		private function __onCanvasCommandC3DUpdate(e:CanvasCommandEvent):void
		{
			canvasCommand.correctPosInBound(e.args.index, dataStorage.getPoBox(), dataStorage.getDmsBox());
		}
		private function __onCanvasCommandBottonMouseDown(e:CanvasCommandEvent):void
		{
			canvas.bottomMouseDown();
		}
		private function __onCanvasCommandItemMouseDown(e:CanvasCommandEvent):void
		{
			layerCommand.filterActive(e.args, dataStorage.getLayerBox(),dataStorage.getActiveBox(), keyCommand, true, true);
		}
		private function __onCanvasCommandBottonMouseUp(e:CanvasCommandEvent):void
		{
			canvas.bottomMouseUp();
		}
		private function __onCanvasCommandItemMouseUp(e:CanvasCommandEvent):void
		{
			canvasCommand.itemMouseUp(dataStorage.getCoord3DBox());
			propertiesCommand.checkFocus(dataStorage.getActiveBox());
		}
		private function __onCanvasCommandMouseDown(e:CanvasCommandEvent):void
		{
			canvasCommand.checkMouseDownTarget(dataStorage.getActiveBox(),dataStorage.getLayerBox(),dataStorage.getPoBox());
		}
		private function __onCanvasCommandMouseUp(e:CanvasCommandEvent):void
		{
			canvasCommand.checkMouseUpTarget();
		}
		private function __onCanvasCommandFrameMouseDown(e:CanvasCommandEvent):void
		{
			dataStorage.resetActiveBox();
			canvasCommand.startFrame(dataStorage.getLayerBox(), dataStorage.getPoBox());
			canvas.startFrame();
		}
		private function __onCanvasCommandFrameMouseUp(e:CanvasCommandEvent):void
		{
			canvas.destroyFrame();
		}
		private function __onCanvasCommandActiveUpdate(e:CanvasCommandEvent):void
		{
			dataStorage.updateActiveBox(e.args);
		}
		//canvas listener
		private function __onCanvasFrameMove(e:CanvasEvent):void
		{
			canvasCommand.hitTest(e.args);
		}

		//primitives listener
		private function __onPrimitivesItemClick(e:PrimitivesEvents):void
		{
			dataStorage.add(DataAddMode.NEW, e.args);
			floatMenu.resetUnlock();
			canvasCommand.updateUnlockAxis(Param.AXIS_DRAG_UNLOCK);
		}
		private function __onPrimitivesSizeChange(e:PrimitivesEvents):void
		{
			project.updateSizeByPrimitives(e.args);
		}
		
		//project command listener
		private function __onProjectCommandFileOpen(e:ProjectCommandEvent):void
		{
			dataStorage.resetData(e.args);
		}
		private function __onProjectCommandClear(e:ProjectCommandEvent):void
		{
			dataStorage.clearData();
		}
		private function __onProjectCommandInputAccept(e:ProjectCommandEvent):void
		{
			project.resetInputFocus();
			canvas.updateBottomSize(e.args);
		}
		private function __onProjectCommandInputDeny(e:ProjectCommandEvent):void
		{
			project.resetInputFocus(e.args);
		}
		//project listener
		private function __onProjectClear(e:ProjectEvent):void
		{
			projectCommand.clearCheck(dataStorage.getLayerBox());
		}
		private function __onProjectOpen(e:ProjectEvent):void
		{
			projectCommand.open(dataStorage.getLayerBox());
		}
		private function __onProjectSave(e:ProjectEvent):void
		{
			projectCommand.save(dataStorage.getSaveData(),dataStorage.getLayerBox());
		}
		private function __onProjectExportImage(e:ProjectEvent):void
		{
			projectCommand.exportImage(canvas.getDrawContent(),dataStorage.getActiveBox(), dataStorage.getLayerBox(),dataStorage.getPoBox());
		}
		private function __onProjectExportCode(e:ProjectEvent):void
		{
			projectCommand.exportCode(dataStorage.getSaveData(),dataStorage.getLayerBox());
		}
		private function __onProjectUnlockChange(e:ProjectEvent):void
		{
			canvasCommand.updateUnlockAxis(e.args);
		}
		private function __onProjectResetPosition(e:ProjectEvent):void
		{
			canvas.center();
			project.resetAll();
		}
		private function __onProjectBottomSizeChange(e:ProjectEvent):void
		{
			projectCommand.checkInput(e.args);
		}
		private function __onProjectGridShowChange(e:ProjectEvent):void
		{
			canvas.setGridVisible(e.args);
		}
	}
}