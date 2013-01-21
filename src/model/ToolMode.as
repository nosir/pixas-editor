package model 
{
	import events.ToolModeEvent;
	import utils.CustomEventDispatcher;
	import utils.KeyCode;
	/**
	 * @author max
	 */
	public class ToolMode extends CustomEventDispatcher
	{
		private var mode:uint;
		
		public function ToolMode() 
		{
			super(ToolModeEvent);
		}
		
		public function init():void
		{
			mode = KeyCode.V;
		}
		
		public function setMode(_m:uint):void
		{
			mode = _m;
			popEvent(ToolModeEvent.SET, mode);
		}
		
		public function getMode():uint
		{
			return mode;
		}
	}

}