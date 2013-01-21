package model 
{
	import base.*;
	import com.risonhuang.pixas.colors.*;
	import com.risonhuang.pixas.dimensions.*;
	import com.risonhuang.pixas.math.*;
	import com.risonhuang.pixas.objects.*;
	import com.risonhuang.pixas.objects.primitives.*;
	import command.*;
	import events.*;
	import flash.net.registerClassAlias;
	import utils.CustomEventDispatcher;
	import utils.Dms;
	import utils.ObjectUtil;
	import utils.VectorUtil;
	/**
	 * @author max
	 */
	public class DataStorage extends CustomEventDispatcher
	{
		private static var activeBox:Vector.<uint>;
		private static var layerBox:Vector.<uint>;
		//ref operate watch out when copy!!
		private static var thumbBox:Vector.<PixelObject>;
		private static var poBox:Vector.<PixelObject>;
		private static var coord3DBox:Vector.<Coord3D>;
		private static var dmsBox:Vector.<Dms>;
		//copy operate
		private static var typeBox:Vector.<uint>;
		private static var nameBox:Vector.<String>;
		private static var showBox:Vector.<Boolean>;
		private static var colorBox:Vector.<uint>;
		private static var borderBox:Vector.<Boolean>;
		private static var alphaBox:Vector.<Number>;

		
		public function DataStorage() 
		{
			super(DataStorageEvent);
		}
		
		public function init():void
		{
			initBoxes();
			
			//for bytearray writeobject
			registerClassAlias("utils", Dms);
			registerClassAlias("com.risonhuang.pixas.math", Coord3D);
			registerClassAlias("com.risonhuang.pixas.objects", PixelObject);
		}
		
		private function initBoxes():void
		{
			activeBox = new Vector.<uint>;
			thumbBox = new Vector.<PixelObject>;
			typeBox = new Vector.<uint>;
			colorBox = new Vector.<uint>;
			poBox = new Vector.<PixelObject>;
			coord3DBox = new Vector.<Coord3D>;	
			nameBox = new Vector.<String>;	
			showBox = new Vector.<Boolean>;	
			layerBox = new Vector.<uint>;
			borderBox = new Vector.<Boolean>;
			alphaBox = new Vector.<Number>;
			dmsBox = new Vector.<Dms>;
		}
		public function clearData():void
		{
			initBoxes();
			popEvent(DataStorageEvent.RESET);
		}
		public function resetData(_obj:Object):void
		{
			initBoxes();
			popEvent(DataStorageEvent.RESET);
			
			//ObjectUtil.deepTrace(_obj);
			for (var i:uint = 0; i < _obj.type.length; i++ )
			{
				add(
					DataAddMode.RESUME,
					_obj.type[i],
					_obj.border[i],
					_obj.alpha[i],
					_obj.show[i],
					_obj.c3d[i],
					_obj.name[i]
				)
				colorBox[i] = _obj.color[i];
				dmsBox[i] = _obj.dms[i];
				rebuildPrimitive(i);
			}
		}
		public function getSaveData():Object
		{
			var obj:Object = {};
			obj.type = new Vector.<uint>;
			obj.name = new Vector.<String>;
			obj.c3d = new Vector.<Coord3D> ;
			obj.alpha = new Vector.<Number>;
			obj.border = new Vector.<Boolean>;
			obj.color = new Vector.<uint>;
			obj.dms = new Vector.<Dms>;
			obj.show = new Vector.<Boolean>;
			layerBox.forEach(function(item:uint, index:int, vector:Vector.<uint>):void
			{
				obj.type.push(typeBox[item]);
				obj.name.push(nameBox[item]);
				obj.c3d.push(coord3DBox[item]);
				obj.alpha.push(alphaBox[item]);
				obj.border.push(borderBox[item]);
				obj.color.push(colorBox[item]);
				obj.dms.push(dmsBox[item]);
				obj.show.push(showBox[item]);
			});
			return obj;
		}
		public function add(_mode:String, _type:uint, _border:Boolean = true, _alpha:Number = 1, _show:Boolean = true, _c3d:Coord3D = null,_name:String = null ):void
		{
			typeBox.push(_type);
			borderBox.push(_border);
			alphaBox.push(_alpha);
			showBox.push(_show);
			coord3DBox.push(_c3d == null ? new Coord3D(): _c3d);
			
			var pmt:AbstractPrimitive;
			var pmtThumb:AbstractPrimitive;
			var suffix:String;
			switch (_type) 
			{
				case 0:
					pmt = new Brick(new BrickDms(Param.SIDE_DEFAULT_X_DMS, Param.SIDE_DEFAULT_Y_DMS),SideColor.getByInnerColor(Param.SIDE_DEFAULT_COLOR));
					pmtThumb = new Brick(new BrickDms(10, 10),SideColor.getByInnerColor(Param.SIDE_DEFAULT_COLOR));
					suffix = "Brick";
					colorBox.push(Param.SIDE_DEFAULT_COLOR);
					dmsBox.push(new Dms(Param.SIDE_DEFAULT_X_DMS,Param.SIDE_DEFAULT_Y_DMS,0));
					break;
				case 1:
					pmt = new SideX(new SideXDms(Param.SIDE_DEFAULT_X_DMS, Param.SIDE_DEFAULT_Z_DMS),SideColor.getByInnerColor(Param.SIDE_DEFAULT_COLOR));
					suffix = "X Side";
					pmtThumb = new SideX(new SideXDms(10, 9),SideColor.getByInnerColor(Param.SIDE_DEFAULT_COLOR));
					colorBox.push(Param.SIDE_DEFAULT_COLOR);
					dmsBox.push(new Dms(Param.SIDE_DEFAULT_X_DMS, 2, Param.SIDE_DEFAULT_Z_DMS));
					break;
				case 2:
					pmt = new SideY(new SideYDms(Param.SIDE_DEFAULT_Y_DMS, Param.SIDE_DEFAULT_Z_DMS),SideColor.getByInnerColor(Param.SIDE_DEFAULT_COLOR));
					pmtThumb = new SideY(new SideYDms(10, 9),SideColor.getByInnerColor(Param.SIDE_DEFAULT_COLOR));
					suffix = "Y Side";
					colorBox.push(Param.SIDE_DEFAULT_COLOR);
					dmsBox.push(new Dms(2, Param.SIDE_DEFAULT_Y_DMS, Param.SIDE_DEFAULT_Z_DMS));
					break;
				case 3:
					pmt = new Cube(new CubeDms(Param.CUBE_DEFAULT_X_DMS,Param.CUBE_DEFAULT_Y_DMS,Param.CUBE_DEFAULT_Z_DMS),CubeColor.getByHorizontalColor(Param.CUBE_DEFAULT_COLOR));
					pmtThumb = new Cube(new CubeDms(8, 8, 7),CubeColor.getByHorizontalColor(Param.CUBE_DEFAULT_COLOR));
					suffix = "Cube";
					colorBox.push(Param.CUBE_DEFAULT_COLOR);
					dmsBox.push(new Dms(Param.CUBE_DEFAULT_X_DMS, Param.CUBE_DEFAULT_Y_DMS, Param.CUBE_DEFAULT_Z_DMS));
					break;
				case 4:
					pmt = new Pyramid(new PyramidDms(Param.PYRAMID_DEFAULT_DMS),PyramidColor.getByRightColor(Param.PYRAMID_DEFAULT_COLOR));
					pmtThumb = new Pyramid(new PyramidDms(10),PyramidColor.getByRightColor(Param.PYRAMID_DEFAULT_COLOR));
					suffix = "Pyramid";
					colorBox.push(Param.PYRAMID_DEFAULT_COLOR);
					dmsBox.push(new Dms(Param.CUBE_DEFAULT_X_DMS, Param.CUBE_DEFAULT_X_DMS, 0));
					break;
				case 5:
					pmt = new SlopeEast(new SlopeDms(Param.SLOPE_EAST_DEFAULT_X_DMS,Param.SLOPE_EAST_DEFAULT_Y_DMS),SlopeColor.getByHorizontalColor(Param.SLOPE_DEFAULT_COLOR));
					pmtThumb = new SlopeEast(new SlopeDms(6,10),SlopeColor.getByHorizontalColor(Param.SLOPE_DEFAULT_COLOR));
					suffix = "E Slope";
					colorBox.push(Param.SLOPE_DEFAULT_COLOR);
					dmsBox.push(new Dms(Param.SLOPE_EAST_DEFAULT_X_DMS,Param.SLOPE_EAST_DEFAULT_Y_DMS, 0));
					break;
				case 6:
					pmt = new SlopeSouth(new SlopeDms(Param.SLOPE_SOUTH_DEFAULT_X_DMS,Param.SLOPE_SOUTH_DEFAULT_Y_DMS),SlopeColor.getByHorizontalColor(Param.SLOPE_DEFAULT_COLOR));
					pmtThumb = new SlopeSouth(new SlopeDms(10,6),SlopeColor.getByHorizontalColor(Param.SLOPE_DEFAULT_COLOR));
					suffix = "S Slope";
					colorBox.push(Param.SLOPE_DEFAULT_COLOR);
					dmsBox.push(new Dms(Param.SLOPE_SOUTH_DEFAULT_X_DMS,Param.SLOPE_SOUTH_DEFAULT_Y_DMS, 0));
					break;
				case 7:
					pmt = new SlopeWest(new SlopeDms(Param.SLOPE_WEST_DEFAULT_X_DMS,Param.SLOPE_WEST_DEFAULT_Y_DMS),SlopeColor.getByHorizontalColor(Param.SLOPE_DEFAULT_COLOR));
					pmtThumb = new SlopeWest(new SlopeDms(8,8),SlopeColor.getByHorizontalColor(Param.SLOPE_DEFAULT_COLOR));
					suffix = "W Slope";
					colorBox.push(Param.SLOPE_DEFAULT_COLOR);
					dmsBox.push(new Dms(Param.SLOPE_WEST_DEFAULT_X_DMS,Param.SLOPE_WEST_DEFAULT_Y_DMS, 0));
					break;
				case 8:
					pmt = new SlopeNorth(new SlopeDms(Param.SLOPE_NORTH_DEFAULT_X_DMS,Param.SLOPE_NORTH_DEFAULT_Y_DMS),SlopeColor.getByHorizontalColor(Param.SLOPE_DEFAULT_COLOR));
					pmtThumb = new SlopeNorth(new SlopeDms(8,8),SlopeColor.getByHorizontalColor(Param.SLOPE_DEFAULT_COLOR));
					suffix = "N Slope";
					colorBox.push(Param.SLOPE_DEFAULT_COLOR);
					dmsBox.push(new Dms(Param.SLOPE_NORTH_DEFAULT_X_DMS,Param.SLOPE_NORTH_DEFAULT_Y_DMS, 0));
					break;
			}
			
			thumbBox.push(new PixelObject(pmtThumb));
			poBox.push(new PixelObject(pmt));
			nameBox.push(_name ? _name :("Untitled " + suffix));
			
			var _index:uint = poBox.length - 1;
			poBox[_index].alpha = alphaBox[_index];
			layerBox.push(_index);
			
			trace("data: " + layerBox);
			popEvent(DataStorageEvent.ITEM_ADD, 
				{	
					mode:_mode,
					type:typeBox[_index],
					po:poBox[_index],
					c3d:coord3DBox[_index],
					poThumb:thumbBox[_index],
					name:nameBox[_index],
					show:showBox[_index],
					index:_index
				} );
		}
		public function copyLayer():void
		{
			if (activeBox.length != 1) { return; }
			var oldIndex:uint = activeBox[0];
			add(DataAddMode.COPY, typeBox[oldIndex], borderBox[oldIndex], alphaBox[oldIndex], showBox[oldIndex], ObjectUtil.clone(coord3DBox[oldIndex]),nameBox[oldIndex]);
			trace(activeBox);
			var newIndex:uint = poBox.length - 1;
			//reset new properties
			colorBox[newIndex] = colorBox[oldIndex];
			dmsBox[newIndex] = ObjectUtil.clone(dmsBox[oldIndex]);
			rebuildPrimitive(newIndex);
			layerBox = VectorUtil.move(layerBox, layerBox.indexOf(newIndex), layerBox.indexOf(oldIndex) + 1);
			updateLayerBox(layerBox, DataAddMode.COPY);
			activeBox[0] = newIndex;
			updateActiveBox(activeBox);
		}
		public function updateShow(_index:uint, _b:Boolean):void
		{
			showBox[_index] = _b;
			poBox[_index].visible = _b;
		}
		public function updateShowAll(_b:Boolean):void
		{
			showBox.forEach(function(item:Boolean, index:int, vector:Vector.<Boolean>):void{item = _b});
			poBox.forEach(function(item:PixelObject, index:int, vector:Vector.<PixelObject>):void{item.visible = _b});
		}
		private function rebuildPrimitive(_index:uint):void
		{
			var pmt:AbstractPrimitive;
			var pmtThumb:AbstractPrimitive;
			var dms:Dms = dmsBox[_index];
			switch (typeBox[_index]) 
			{
				case 0:
					pmt = new Brick(new BrickDms(dms.xDms, dms.yDms), SideColor.getByInnerColor(colorBox[_index]), borderBox[_index]);
					pmtThumb = new Brick(new BrickDms(10, 10),SideColor.getByInnerColor(colorBox[_index]),borderBox[_index]);
					break;
				case 1:
					pmt = new SideX(new SideXDms(dms.xDms, dms.zDms),SideColor.getByInnerColor(colorBox[_index]),borderBox[_index]);
					pmtThumb = new SideX(new SideXDms(10, 9),SideColor.getByInnerColor(colorBox[_index]),borderBox[_index]);
					break;
				case 2:
					pmt = new SideY(new SideYDms(dms.yDms, dms.zDms),SideColor.getByInnerColor(colorBox[_index]),borderBox[_index]);
					pmtThumb = new SideY(new SideYDms(10, 9),SideColor.getByInnerColor(colorBox[_index]),borderBox[_index]);
					break;
				case 3:
					pmt = new Cube(new CubeDms(dms.xDms,dms.yDms,dms.zDms),CubeColor.getByHorizontalColor(colorBox[_index]),borderBox[_index]);
					pmtThumb = new Cube(new CubeDms(8, 8, 7),CubeColor.getByHorizontalColor(colorBox[_index]),borderBox[_index]);
					break;
				case 4:
					pmt = new Pyramid(new PyramidDms(dms.xDms,dms.tall),PyramidColor.getByRightColor(colorBox[_index]),borderBox[_index]);
					pmtThumb = new Pyramid(new PyramidDms(10),PyramidColor.getByRightColor(colorBox[_index]),borderBox[_index]);
					break;
				case 5:
					pmt = new SlopeEast(new SlopeDms(dms.xDms,dms.yDms),SlopeColor.getByHorizontalColor(colorBox[_index]),borderBox[_index]);
					pmtThumb = new SlopeEast(new SlopeDms(6,10),SlopeColor.getByHorizontalColor(colorBox[_index]),borderBox[_index]);
					break;
				case 6:
					pmt = new SlopeSouth(new SlopeDms(dms.xDms,dms.yDms),SlopeColor.getByHorizontalColor(colorBox[_index]),borderBox[_index]);
					pmtThumb = new SlopeSouth(new SlopeDms(10,6),SlopeColor.getByHorizontalColor(colorBox[_index]),borderBox[_index]);
					break;
				case 7:
					pmt = new SlopeWest(new SlopeDms(dms.xDms,dms.yDms),SlopeColor.getByHorizontalColor(colorBox[_index]),borderBox[_index]);
					pmtThumb = new SlopeWest(new SlopeDms(8,8),SlopeColor.getByHorizontalColor(colorBox[_index]),borderBox[_index]);
					break;
				case 8:
					pmt = new SlopeNorth(new SlopeDms(dms.xDms,dms.yDms),SlopeColor.getByHorizontalColor(colorBox[_index]),borderBox[_index]);
					pmtThumb = new SlopeNorth(new SlopeDms(8,8),SlopeColor.getByHorizontalColor(colorBox[_index]),borderBox[_index]);
					break;
			}
			poBox[_index].primitive = pmt;
			thumbBox[_index].primitive = pmtThumb;
		}
		public function getDataByIndex(_index:uint):Object
		{
			var obj:Object = { };
			obj.type = typeBox[_index];
			obj.name = nameBox[_index];
			obj.c3d = coord3DBox[_index];
			obj.alpha = alphaBox[_index];
			obj.border = borderBox[_index];
			obj.color = colorBox[_index];
			obj.dms = dmsBox[_index];
			obj.show = showBox[_index];
			return obj;
		}
		public function updateDms(_index:uint, _obj:Object):void
		{
			//updata DMS
			switch (_obj.type)
			{
				case Dms.X :
					dmsBox[_index].xDms = _obj.value;
					break;
				case Dms.Y :
					dmsBox[_index].yDms = _obj.value;
					break;
				case Dms.Z :
					dmsBox[_index].zDms = _obj.value;
					break;
				case Dms.TALL :
					dmsBox[_index].tall = _obj.value;
					break;
			}
			//trim invalid data
			switch (typeBox[_index])
			{
				case 0 :
					break;
				case 1 :
					dmsBox[_index].yDms = 2;
					break;
				case 2 :
					dmsBox[_index].xDms = 2;
					break;
				case 3 :
					break;
				case 4 :
					dmsBox[_index].yDms = dmsBox[_index].xDms;
					break;
			}
			rebuildPrimitive(_index);
		}
		public function updateAlpha(_index:uint, _alpha:Number):void
		{
			alphaBox[_index] = _alpha;
			poBox[_index].alpha = _alpha;
		}
		public function updateBorder(_index:uint, _b:Boolean):void
		{
			borderBox[_index] = _b;
			rebuildPrimitive(_index);
		}
		public function updateColor(_index:uint, _color:uint):void
		{
			colorBox[_index] = _color;
			rebuildPrimitive(_index);
		}
		public function updateC3D(_index:uint,_c3d:Coord3D):void
		{
			coord3DBox[_index] = _c3d;
			//trace(_c3d);
			poBox[_index].position = coord3DBox[_index];
		}
		public function updateName(_index:uint, _name:String):void
		{
			nameBox[_index] = _name;
		}
		public function getPoBox():Vector.<PixelObject>
		{
			return poBox;
		}
		public function getCoord3DBox():Vector.<Coord3D>
		{
			return coord3DBox;
		}
		public function getDmsBox():Vector.<Dms>
		{
			return dmsBox;
		}
		//return copy
		public function getLayerBox():Vector.<uint>
		{
			return layerBox.slice(0);
		}		
		public function getActiveBox():Vector.<uint>
		{
			return activeBox.slice(0);
		}
		
		//update and dispatch out event
		public function deleteActiveLayer():void
		{
			activeBox.forEach(function(item:uint, index:int, vector:Vector.<uint>):void
			{
				if (layerBox.indexOf(item) >= 0)
				{
					layerBox.splice(layerBox.indexOf(item),1);
					poBox[item].removeAllChildren();
				}
			});
			trace("data: " + layerBox);
			resetActiveBox();
			popEvent(DataStorageEvent.LAYER_BOX_UPDATE, {layerBox:layerBox});
		}
		public function resetActiveBox():void
		{
			activeBox = new Vector.<uint>;
			popEvent(DataStorageEvent.ACTIVE_BOX_UPDATE, activeBox);
		}
		public function updateLayerBox(_layerBox:Vector.<uint>,_mode:String = ""):void
		{
			layerBox  = _layerBox;
			popEvent(DataStorageEvent.LAYER_BOX_UPDATE, {layerBox:layerBox,mode:_mode});
		}
		public function updateActiveBox(_activeBox:Vector.<uint>):void
		{
			activeBox = _activeBox;
			popEvent(DataStorageEvent.ACTIVE_BOX_UPDATE, activeBox);
		}
	}

}