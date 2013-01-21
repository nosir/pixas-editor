package utils 
{
	import com.risonhuang.pixas.math.Coord3D;
	import flash.display.Sprite;
	/**
	 * ...
	 * @author max
	 */
	public class AxisOperator 
	{
		public static const AXIS_X:String = "x";
		public static const AXIS_Y:String = "y";
		public static const AXIS_Z:String = "z";
		
		public function AxisOperator() 
		{
			
		}
		
		public static function getEvenNumber(_i:int):int
		{
			return _i + _i % 2;
		}
		
		public static function flash2c3dLockH(c3d:Coord3D, zOffset:Number):Coord3D
		{
			var c3d:Coord3D = new Coord3D(c3d.x,c3d.y,c3d.z);
			c3d.z = c3d.z - zOffset;
			return c3d;
		}
		
		public static function flash2c3dLockV(c3dZ:int, x:Number, y:Number):Coord3D
		{
			var c3d:Coord3D = new Coord3D(0, 0, c3dZ);
			c3d.x = getEvenNumber(Math.round(c3dZ + y + 0.5*x));
			c3d.y = getEvenNumber(Math.round(c3dZ + y - 0.5*x));
			return c3d;
		}
	}

}