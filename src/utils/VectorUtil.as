package utils 
{
	/**
	 * ...
	 * @author max
	 */
	public class VectorUtil 
	{
		
		public function VectorUtil() 
		{
			
		}
		
		public static function move
			(_vec:Vector.<uint>, from:uint, to:uint):Vector.<uint>
		{
			var m:Vector.<uint> = _vec.splice(from, 1);
			var l:Vector.<uint> = _vec.slice(0, to);
			var r:Vector.<uint> = _vec.slice(to);
			var over:Vector.<uint> = l.concat(m).concat(r);
			return over;
		}
		
		public static function vectorsAreEqual(vec1:Vector.<uint>, vec2:Vector.<uint>):Boolean
		{
			if(vec1.length != vec2.length)
			{
				return false;
			}
			
			var len:Number = vec1.length;
			
			for(var i:Number = 0; i < len; i++)
			{
				if(vec1[i] !== vec2[i])
				{
					return false;
				}
			}
			
			return true;
		}
	}

}