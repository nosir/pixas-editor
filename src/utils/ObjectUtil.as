package utils 
{
	import flash.utils.ByteArray;
	/**
	 * @author max
	 */
	public class ObjectUtil 
	{
		
		public function ObjectUtil() 
		{
		}
		public static function clone(source:*):*
		{ 
			var copier:ByteArray=new ByteArray(); 
			copier.writeObject(source); 
			copier.position = 0;
			var obj:* = copier.readObject();
			copier.clear();
			return(obj); 
		}
		public static function deepTrace(obj:Object, indent:uint = 0):void
		{
			var indentString:String = "";
			var i:uint;
			var prop:String;
			var val:*;
			for (i = 0; i < indent; i++)
			{
				indentString += "\t";
			}
			for (prop in obj)
			{
				val = obj[prop];
				if (typeof(val) == "object")
				{
					trace(indentString + " " + prop + ": [Object]");
					deepTrace(val, indent + 1);
				}
				else
				{
					trace(indentString + " " + prop + ": " + val);
				}
			}
		}
	}
}