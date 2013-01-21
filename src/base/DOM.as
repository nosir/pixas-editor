package base
{
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	/**
	 * @author max
	 */
	public class DOM 
	{
		public static var timeline:Sprite;
		public static var stage:Stage;
		public static var primitives_sp:Sprite;
		public static var bg_sp:Sprite;
		public static var project_sp:Sprite;
		public static var layer_sp:Sprite;
		public static var canvas_sp:Sprite;
		public static var alert_sp:Sprite;
		public static var confirm_sp:Sprite;
		public static var properties_sp:Sprite;
		public static var float_menu_sp:Sprite;
		public static var about_sp:Sprite;
		public static var cursor:Sprite;
		
		public function DOM() 
		{
		}
		
		public static function init(_timeline:Sprite):void
		{
			timeline = _timeline;
			stage = timeline.stage;
			stage.stageFocusRect = false;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			
			bg_sp = new Sprite();
			primitives_sp = new Sprite();
			project_sp = new Sprite();
			layer_sp = new Sprite();
			canvas_sp = new Sprite();
			alert_sp = new Sprite();
			confirm_sp = new Sprite();
			properties_sp = new Sprite();
			properties_sp = new Sprite();
			float_menu_sp = new Sprite();
			about_sp = new Sprite();
			cursor = new Sprite();
			
			timeline.addChild(bg_sp);
			timeline.addChild(canvas_sp);
			timeline.addChild(primitives_sp);
			timeline.addChild(project_sp);
			timeline.addChild(properties_sp);
			timeline.addChild(layer_sp);
			timeline.addChild(float_menu_sp);			
			timeline.addChild(about_sp);			
			timeline.addChild(alert_sp);			
			timeline.addChild(confirm_sp);			
			timeline.addChild(cursor);
			
			EmbedAssets.init();
			Cursor.init();
			StageBackground.init();
		}
	}

}