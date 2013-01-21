package command 
{
	import events.PropertiesCommandEvent;
	import utils.CustomEventDispatcher;
	
	/**
	 * @author max
	 */
	public class PropertiesCommand extends CustomEventDispatcher 
	{
		private var index:int;
		public function PropertiesCommand() 
		{
			super(PropertiesCommandEvent);
		}
		public function init() :void
		{
			index = -1;
		}
		public function checkFocus(_activeBox:Vector.<uint>):void
		{
			if (_activeBox.length == 1)
			{
				index = _activeBox[0];
				popEvent(PropertiesCommandEvent.GET_FOCUS, index);
			}
			else
			{
				popEvent(PropertiesCommandEvent.LOST_FOCUS);
				index = -1;
			}
		}
		public function getFocusIndex():int
		{
			return index;
		}
	}

}