package command 
{
	import base.Param;
	import component.Confirm;
	import events.LayerCommandEvent;
	import utils.CustomEventDispatcher;
	import utils.VectorUtil;
	/**
	 * @author max
	 */
	public class LayerCommand extends CustomEventDispatcher
	{
		private static var layerShiftStartIndex:int;
		
		public function LayerCommand() 
		{
			super(LayerCommandEvent);
		}
		
		public function init():void
		{
			layerShiftStartIndex = -1;
		}
		public function delCheck(_activeBox:Vector.<uint>):void
		{
			if (_activeBox.length == 0) { return; }
			Confirm.show(Param.CONFIRM_DEL,__onDelConfirm);
		}
		private function __onDelConfirm():void
		{
			popEvent(LayerCommandEvent.DEL);
		}
		public function resort(_target:uint,_stopY:Number,_layerBox:Vector.<uint>):void
		{
			var stopIndex:int = Math.floor((Param.LIST_TOP_SPACE + _layerBox.length * (Param.LINE_HEIGHT + Param.PO_LINE_SPACE) - _stopY) / (Param.LINE_HEIGHT + Param.PO_LINE_SPACE));
			var from:uint =  _layerBox.indexOf(_target);
			var to:int = (stopIndex > from)?(stopIndex - 1):stopIndex;
			to = Math.max(Math.min(to, _layerBox.length - 1), 0);
			_layerBox = VectorUtil.move(_layerBox, from, to);
			popEvent(LayerCommandEvent.RESORT, _layerBox);
		}
		
		public function filterActive(_index:uint,_layerBox:Vector.<uint>,_activeBox:Vector.<uint>,_keyCommand:KeyCommand,_canvasMouseDownBubble:Boolean=false,_ignoreMulti:Boolean = false):void
		{
			if (_keyCommand.keyCtrlDown)
			{
				if (_activeBox.indexOf(_index) >= 0) 
				{
					_activeBox.splice(_activeBox.indexOf(_index), 1);
				}
				else
				{
					_activeBox.push(_index);
				}
			}
			else
			{
				if (_keyCommand.keyShiftDown && layerShiftStartIndex >= 0 && layerShiftStartIndex != _index)
				{
					_activeBox = new Vector.<uint>;
					var indexStart:uint = _layerBox.indexOf(layerShiftStartIndex);
					var indexNow:uint = _layerBox.indexOf(_index);
					var indexLeft:uint = Math.min(indexStart, indexNow);
					var indexRight:uint = Math.max(indexStart, indexNow);
					for (var i:uint = indexLeft; i <= indexRight; i++ )
					{
						_activeBox.push(_layerBox[i]);
					}
				}
				else
				{
					if (_ignoreMulti && _activeBox.indexOf(_index)>=0)
					{
						//do nothing
					}
					else
					{
						_activeBox = new Vector.<uint>;
						_activeBox[0] = _index;
						layerShiftStartIndex = _index;
					}
				}
			}
			popEvent(LayerCommandEvent.ACTIVE_FILTER, {activeBox:_activeBox,canvasMouseDownBubble:_canvasMouseDownBubble,index:_index});
		}
	}

}