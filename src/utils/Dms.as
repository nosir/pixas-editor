package utils 
{
	/**
	 * @author	max
	 */
	public class Dms
	{
		public static const X:String = "x";
		public static const Y:String = "y";
		public static const Z:String = "z";
		public static const TALL:String = "tall";
		public var xDms:uint;
		public var yDms:uint;
		public var zDms:uint;
		public var tall:Boolean;

		public function Dms(_xDms:uint = 0, _yDms:uint = 0, _zDms:uint = 0,_tall:Boolean=false) 
		{
			xDms = _xDms;
			yDms = _yDms;
			zDms = _zDms;
			tall = _tall;
		}
		
		public function toString():String
		{
			return "[xDms : " + xDms+ ", yDms : " + yDms + ", zDms: " + zDms + ", tall: "+ tall +"]";
		}
		
	}
}