package view 
{
	import base.DOM;
	import base.Param;
	import com.bit101.components.*;
	import component.SeperateLine;
	import fl.transitions.easing.Regular;
	import fl.transitions.Tween;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.net.navigateToURL;
	import flash.net.URLRequest;
	import utils.CustomEventDispatcher;
	
	/**
	 * @author max
	 */
	public class About extends CustomEventDispatcher 
	{
		private var sp:Sprite;
		private var win:Window;
		private var bg:Sprite;
		
		public function About() 
		{
			super(null);
		}
		
		public function show():void
		{
			DOM.about_sp.visible = true;
			__onResize();
			var tween:Tween = new Tween(DOM.about_sp, "alpha", Regular.easeOut, 0, 1, 0.3, true);
		}
		
		public function init():void
		{
			bg = new Sprite();
			bg.graphics.beginFill(0x000000,Param.MODAL_BG_ALPHA);
			bg.graphics.drawRect(0, 0, DOM.stage.stageWidth, DOM.stage.stageHeight);
			bg.graphics.endFill();
			DOM.about_sp.visible = false;
			DOM.about_sp.addChild(bg);
			
			win = new Window(DOM.about_sp, 0, 0, "About Pixas Editor");
			win.width = Param.ABOUT_WIDTH;
			win.height = Param.ABOUT_HEIGHT;
			win.hasCloseButton = true;
			win.addEventListener(Event.CLOSE, __onBtnClick);
			
			sp = new Sprite();
			sp.x = 5;
			sp.y = 8;
			win.addChild(sp);
			
			
			var aboutLabel:Label = new Label(sp, 10, 0, "About");
			var line1:SeperateLine = new SeperateLine(sp, 10, 21, 170);
			var line2:SeperateLine = new SeperateLine(sp, 200, 21, 170);
			
			var peLabel:Label = new Label(sp, 10, 25, Param.VERSION);

			var feedbackLabel:Label = new Label(sp, 10, 125, "Feedback");
			var line4:SeperateLine = new SeperateLine(sp, 10, 145, 170);

			var shortLabel:Label = new Label(sp, 200, 0, "Shortcuts");

			var twitterButton:PushButton = new PushButton(sp, 10, 153, "Twitter", __onTwitterBtnClick);
			twitterButton.width = 80;
			twitterButton.height = 18;

			var infoLabel:Label = new Label(sp, 10, 40, "I build Pixels, I target for nothing.");

			var labsLabel:Label = new Label(sp, 10, 65, "Libraries");
			var line3:SeperateLine = new SeperateLine(sp, 10, 85, 170);

			var blogButton:PushButton = new PushButton(sp, 100, 153, "Blog", __onBlogBtnClick);
			blogButton.width = 80;
			blogButton.height = 18;
			blogButton.visible = false;

			var pixasButton:PushButton = new PushButton(sp, 10, 93, "Pixas", __onPixasBtnClick);
			pixasButton.width = 80;
			pixasButton.height = 18;

			var miniButton:PushButton = new PushButton(sp, 100, 93, "Minimalcomps", __onMiniBtnClick);
			miniButton.width = 80;
			miniButton.height = 18;
			
			var lineSep:uint = 20;
			var lineInit:uint = 25;
			var introPos:uint = 290;
			
			var label1:Label = new Label(sp, 200, lineInit, "Ctrl + , -");
			var label2:Label = new Label(sp, introPos, lineInit, "Zoom In , Out");
			
			var label5:Label = new Label(sp, 200, lineInit + lineSep, "Ctrl + Alt + 0");
			var label6:Label = new Label(sp, introPos, lineInit + lineSep, "Zoom 100%");
			
			var label7:Label = new Label(sp, 200, lineInit + lineSep * 2, "Ctrl + D");
			var label8:Label = new Label(sp, introPos, lineInit + lineSep * 2, "Duplicate Layer");	
			
			var label7x:Label = new Label(sp, 200, lineInit + lineSep * 3, "Ctrl + A");
			var label8x:Label = new Label(sp, introPos, lineInit + lineSep * 3, "Select All");	
			
			var label13:Label = new Label(sp, 200, lineInit + lineSep * 4, "Ctrl , Shift");
			var label14:Label = new Label(sp, introPos, lineInit + lineSep * 4, "Multi Select");
			
			var label9:Label = new Label(sp, 200, lineInit + lineSep * 5, "Tab");
			var label10:Label = new Label(sp, introPos, lineInit + lineSep * 5, "Toggle Minimum");
			
			var label11:Label = new Label(sp, 200, lineInit + lineSep * 6, "Delete");
			var label12:Label = new Label(sp, introPos, lineInit + lineSep * 6, "Delete Select");
			
			var label17:Label = new Label(sp, 200, lineInit + lineSep * 7, "V");
			var label18:Label = new Label(sp, introPos, lineInit + lineSep * 7, "Move");
			
			var label15:Label = new Label(sp, 200, lineInit + lineSep * 8, "H");
			var label16:Label = new Label(sp, introPos, lineInit + lineSep * 8, "Hand");
			
			DOM.stage.addEventListener(Event.RESIZE, __onResize);
			__onResize();
		}
		
		private function __onTwitterBtnClick(e:MouseEvent):void
		{
			navigateToURL(new URLRequest(Param.TWITTER_ADDRESS), "_blank");
		}
		private function __onBlogBtnClick(e:MouseEvent):void
		{
			navigateToURL(new URLRequest(Param.FEEDBACK_ADDRESS), "_blank");
		}
		private function __onPixasBtnClick(e:MouseEvent):void
		{
			navigateToURL(new URLRequest(Param.PIXAS_ADDRESS), "_blank");
		}
		private function __onMiniBtnClick(e:MouseEvent):void
		{
			navigateToURL(new URLRequest(Param.MINI_ADDRESS), "_blank");
		}
		private function __onResize(e:Event = null):void
		{
			win.x = Math.round((DOM.stage.stageWidth - Param.ABOUT_WIDTH) / 2);
			win.y = Math.round((DOM.stage.stageHeight - Param.ABOUT_HEIGHT) / 2);
			
			bg.graphics.clear();
			bg.graphics.beginFill(0x000000, Param.MODAL_BG_ALPHA);
			bg.graphics.drawRect(0, 0, DOM.stage.stageWidth, DOM.stage.stageHeight);
			bg.graphics.endFill();
		}
		
		private static function __onBtnClick(e:Event = null):void
		{
			DOM.about_sp.visible = false;
		}	
	}

}