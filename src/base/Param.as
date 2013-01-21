package base
{
	import utils.AxisOperator;
	/**
	 * @author max
	 */
	public class Param 
	{
		public static const VERSION:String = "Pixas Editor 1.0.2 Beta";
		public static const FEEDBACK_ADDRESS:String = "http://risonhuang.wordpress.com/";
		public static const TWITTER_ADDRESS:String = "https://twitter.com/pixas_engine/";
		public static const PIXAS_ADDRESS:String = "http://risonhuang.com/pixas.html";
		public static const MINI_ADDRESS:String = "http://www.minimalcomps.com/";
		public static const VIEW_SPACE:uint = 7;
		public static const FRAME_COLOR:uint = 0xFFFF00;
		public static const PO_LINE_SPACE:uint = 3;
		public static const BG_COLOR:uint = 0xEEEEEE;
		
		//about
		public static const ABOUT_WIDTH:uint = 390;
		public static const ABOUT_HEIGHT:uint = 213+30;
		
		//layout
		public static const PROJECT_WIDTH:uint = 120;
		public static const LAYER_WIDTH:uint = 160;
		
		//pmt
		public static const CUBE_DEFAULT_COLOR:uint = 0xEEEFF0;
		public static const CUBE_DEFAULT_X_DMS:uint = 40;
		public static const CUBE_DEFAULT_Y_DMS:uint = 40;
		public static const CUBE_DEFAULT_Z_DMS:uint = 40;
		public static const PYRAMID_DEFAULT_DMS:uint = 40;
		public static const PYRAMID_DEFAULT_COLOR:uint = 0xEEEFF0;
		public static const SIDE_DEFAULT_COLOR:uint = 0xEEEEEE;
		public static const SIDE_DEFAULT_X_DMS:uint = 40;
		public static const SIDE_DEFAULT_Y_DMS:uint = 40;
		public static const SIDE_DEFAULT_Z_DMS:uint = 40;
		public static const SLOPE_DEFAULT_COLOR:uint = 0xEEEFF0;
		public static const SLOPE_EAST_DEFAULT_X_DMS:uint = 28;
		public static const SLOPE_EAST_DEFAULT_Y_DMS:uint = 40;
		public static const SLOPE_SOUTH_DEFAULT_X_DMS:uint = 40;
		public static const SLOPE_SOUTH_DEFAULT_Y_DMS:uint = 28;
		public static const SLOPE_WEST_DEFAULT_X_DMS:uint = 28;
		public static const SLOPE_WEST_DEFAULT_Y_DMS:uint = 40;
		public static const SLOPE_NORTH_DEFAULT_X_DMS:uint = 40;
		public static const SLOPE_NORTH_DEFAULT_Y_DMS:uint = 28;
		
		//project
		public static const GRID_X_WIDTH:uint = 400;
		public static const GRID_Y_WIDTH:uint = 400;
		public static const GRID_SIZE:uint = 40;
		public static const SHOW_GRID:Boolean = true;
		public static const AXIS_DRAG_UNLOCK:String = AxisOperator.AXIS_X;
		public static const XY_AUTO_SWITCH:Boolean = true;
		public static const ZOOM:uint = 1;
		public static const EXPORT_NAME:String = "Untitled-1.png";
		public static const SAVE_NAME:String = "Untitled-1.pixas";
		public static const CODE_NAME:String = "Untitled-1.as";

		//canvas
		public static const CANVAS_Z_SPACE:uint = 90;
		public static const CANVAS_GRID_COLOR:uint = 0xAAAAAA;
		public static const CANVAS_FILL_COLOR:uint = 0xF9F9F9;
		//bound
		public static const MIN_Z_POS:int = 0;
		public static const MAX_Z_POS:int = 500;
		public static const MIN_POS:int = -500;
		public static const MAX_POS:uint = 1000;
		public static const BOUND_COLOR:uint = 0xCCCCCC;
		
		//properties
		public static const PROPERTIES_HEIGHT:uint = 100;
		
		//primitives
		public static const PRIMITIVES_HEIGHT:uint = 280;
		
		//alert confirm
		public static const MODAL_BG_ALPHA:Number = 0.5;
		public static const ALERT_CANVAS_EMPTY:String = "Oops~ The Canvas is empty. Add some primitives first.";
		public static const CONFIRM_CLEAR:String = "All of the primitives on the canvas will be removed!";
		public static const CONFIRM_OPEN:String = "All of the elements on the canvas will be replaced by the new data from: ";
		public static const CONFIRM_DEL:String = "All of the selected elements on the canvas will be deleted!";
		
		//layer
		public static const LINE_HEIGHT:uint = 24;
		public static const LIST_TOP_SPACE:uint = 10;
		public static const NAME_MAX_CHAR:uint = 16;
		
		
		public function Param() 
		{
			
		}
	}
}