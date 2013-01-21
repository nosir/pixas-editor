package component 
{
	import com.bit101.components.Label;
	import com.bit101.components.PushButton;
	import com.bit101.components.Window;
	import flash.display.Sprite;
	import flash.events.Event;
	import base.*;
	/**
	 * @author max
	 */
	public class Confirm
	{
		private static var lable:Label;
		private static var bg:Sprite;
		private static var window:Window;
		private static var handle:Function;
		
		public function Confirm() 
		{
		}
		
		private static function hide():void
		{
			DOM.confirm_sp.visible = false;
		}
		
		public static function show(_str:String,_handle:Function):void
		{
			handle = _handle;
			
			if (!bg)
			{
				bg = new Sprite();
				bg.graphics.beginFill(0x000000,Param.MODAL_BG_ALPHA);
				bg.graphics.drawRect(0, 0, DOM.stage.stageWidth, DOM.stage.stageHeight);
				bg.graphics.endFill();
				DOM.stage.addEventListener(Event.RESIZE, __onResize);
				DOM.confirm_sp.addChild(bg);
			}
			
			if (!window)
			{
				window = new Window(DOM.confirm_sp, 0, 0, "Confirm");
				window.hasCloseButton = true;
				window.width = 200;
				window.height = 130;
				window.addEventListener(Event.CLOSE, __onCancelBtnClick);
				lable = new Label(window, 15, 10, _str);
				lable.textField.width = 170;
				lable.textField.multiline = true;
				lable.textField.wordWrap = true;
				var confirmBtn:PushButton = new PushButton(window, 15, 70, "Confirm", __onConfirmBtnClick);
				var cancelBtn:PushButton = new PushButton(window, 105, 70, "Cancel", __onCancelBtnClick);
				confirmBtn.width = cancelBtn.width = 80;
			}
			else
			{
				lable.text = _str;
			}
			window.x = Math.floor((DOM.stage.stageWidth - window.width) / 2);
			window.y = Math.floor((DOM.stage.stageHeight - window.height) / 2);			
			DOM.confirm_sp.visible = true;
		}
		
		private static function __onResize(e:Event = null):void
		{
			bg.graphics.clear();
			bg.graphics.beginFill(0x000000, Param.MODAL_BG_ALPHA);
			bg.graphics.drawRect(0, 0, DOM.stage.stageWidth, DOM.stage.stageHeight);
			bg.graphics.endFill();
			
			window.x = Math.floor((DOM.stage.stageWidth - window.width) / 2);
			window.y = Math.floor((DOM.stage.stageHeight - window.height) / 2);
		}
		private static function __onCancelBtnClick(e:Event = null):void
		{
			hide();
		}
		private static function __onConfirmBtnClick(e:Event = null):void
		{
			hide();
			handle();
		}
	}

}