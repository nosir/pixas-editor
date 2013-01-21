package base 
{
	/**
	 * @author max
	 */
	public class EmbedAssets 
	{
		[Embed(source = "../../assets/hand_cursor.png")] public static var HandCursor:Class;
		[Embed(source = "../../assets/copy_img.png")] public static var CopyImg:Class;
		[Embed(source = "../../assets/del_img.png")] public static var DelImg:Class;
		[Embed(source = "../../assets/arrow_img.png")] public static var MoveImg:Class;
		[Embed(source = "../../assets/hand_img.png")] public static var HandImg:Class;
		
		public function EmbedAssets() 
		{
			
		}
		internal static function init():void
		{
		}
		
	}

}