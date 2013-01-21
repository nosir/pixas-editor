package command 
{
	import base.DOM;
	import events.KeyCommandEvent;
	import flash.events.KeyboardEvent;
	import utils.CustomEventDispatcher;
	import utils.KeyCode;
	/**
	 * @author max
	 */
	public class KeyCommand extends CustomEventDispatcher
	{
		public var keyCtrlDown:Boolean;
		public var keyShiftDown:Boolean;
		private var tab:Boolean;
		
		public function KeyCommand() 
		{
			super(KeyCommandEvent);
		}
		public function init():void
		{
			keyCtrlDown = false;
			keyShiftDown = false;
			tab = false;
			
			DOM.stage.addEventListener(KeyboardEvent.KEY_DOWN, __onkeyDown);
            DOM.stage.addEventListener(KeyboardEvent.KEY_UP, __onkeyUp);
		}
		private function __onkeyDown(e:KeyboardEvent):void
		{
			//trace(e.keyCode);
			switch (e.keyCode)
			{
				case KeyCode.LEFT :
					popEvent(KeyCommandEvent.ARROW, [-1,1]);
					break;
				case KeyCode.UP :
					popEvent(KeyCommandEvent.ARROW, [1,-1]);
					break;
				case KeyCode.RIGHT :
					popEvent(KeyCommandEvent.ARROW, [1,1]);
					break;
				case KeyCode.DOWN :
					popEvent(KeyCommandEvent.ARROW, [-1,-1]);
					break;
				case KeyCode.SHIFT :
					keyShiftDown = true;
					break;
				case KeyCode.CTRL :
					keyCtrlDown = true;
					break;
			}
		}
		private function __onkeyUp(e:KeyboardEvent):void
		{
			
			trace(e.keyCode);
			switch (e.keyCode)
			{
				case KeyCode.SHIFT :
					keyShiftDown = false;
					break;
				case KeyCode.CTRL :
					keyCtrlDown = false;
					break;
				case KeyCode.H :
					if (DOM.stage.focus == null)
					{
						popEvent(KeyCommandEvent.MODE, KeyCode.H); 
					}
					break;
				case KeyCode.V :
					if (DOM.stage.focus == null)
					{
						popEvent(KeyCommandEvent.MODE, KeyCode.V); 
					}
					break;
				case KeyCode.A :
					if (e.ctrlKey) 
					{
						popEvent(KeyCommandEvent.CTRL_A);
						keyCtrlDown = false;
					}
					break;
				case KeyCode.D :
					if (e.ctrlKey) 
					{
						popEvent(KeyCommandEvent.CTRL_D);
						//keyCtrlDown = false;
					}
					break;
				case KeyCode.ADD :
					if (e.ctrlKey) 
					{
						popEvent(KeyCommandEvent.CTRL_ZOOM, 1); 
					}
					break;
				case KeyCode.SUBSTRACT :
					if (e.ctrlKey) 
					{
						popEvent(KeyCommandEvent.CTRL_ZOOM, -1); 
					}
					break;
				case KeyCode.ZERO :
					if (e.ctrlKey && e.altKey) 
					{
						popEvent(KeyCommandEvent.CTRL_ZOOM, -1000); 
					}
					break;
				case KeyCode.DEL :
					popEvent(KeyCommandEvent.DEL);
					break;
				case KeyCode.TAB :
					tab = !tab;
					popEvent(KeyCommandEvent.TAB, tab);
					break;
			}
		}		
	}

}