package utils 
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	/**
	 * @author max
	 */
	public class CustomEventDispatcher extends EventDispatcher
	{
		protected var eventClass:Class;
		
		public function CustomEventDispatcher(_eventClass:Class = null) 
		{
			eventClass = _eventClass;
		}
		protected function popEvent(_str:String,_args:* = null):void
		{
			if (eventClass == null)
			{
				throw new Error("CustomEventClass in Constructor undefined");
				return;
			}
			var evt:* = new eventClass(_str);
			evt.args = _args;
			dispatchEvent(evt);
		}
		
		
	}

}