package component 
{
	import base.Param;
	import com.bit101.components.Label;
	import com.bit101.components.PushButton;
	import com.bit101.components.Slider;
	import flash.display.Sprite;
	import flash.events.Event;
	
	/**
	 * @author max
	 */
	public class NumericSlider extends Sprite 
	{
		private var _value:int = Param.CUBE_DEFAULT_X_DMS;
		private var _tick:uint = 1;
		
		private var slider:Slider;
		private var label:Label;
		private var aBtn:PushButton;
		private var sBtn:PushButton;
		private var _minimum:int = 6;
		private var _maximum:int = 400;
		
		public function NumericSlider(_parent:Sprite,_x:Number = 0,_y:Number = 0, __listener:Function = null) 
		{
			x = _x;
			y = _y;
			
			sBtn = new PushButton(this, 0, 0, "", __onSubstractBtn);
			var sLabel:Label = new Label(this, sBtn.x + 2, -4, "-");
			sBtn.width = sBtn.height = 11;
			
			slider = new Slider(Slider.HORIZONTAL, this, sBtn.width-1, 0, __onSliderChange);
			slider.tick = _tick;
			slider.height = 11;
			slider.width = 100;
			
			aBtn = new PushButton(this, slider.x + slider.width - 1, 0, "", __onAddBtn);
			var aLabel:Label = new Label(this, aBtn.x + 1, -4, "+");
			aBtn.width = aBtn.height = 11;
			
			label = new Label(this , aBtn.x + aBtn.width + 5, -4, "");
			
			addEventListener(Event.CHANGE, __listener);
			_parent.addChild(this);
		}
		
		override public function get width():Number
		{
			return label.x + label.width;
		}		
		public function setSliderParams(_min:int, _max:int, _v:int):void
		{
			_minimum = _min;
			_maximum = _max;
			_value = Math.max(_minimum, Math.min(_v, _maximum));
			slider.setSliderParams(_minimum, _maximum, _value);
			label.text = String(_value);
		}
		public function get tick():uint
		{
			return _tick;
		}		
		public function set tick(_t:uint):void
		{
			_tick = _t;
			slider.tick = _tick;
		}	
		public function get value():int
		{
			return _value;
		}		
		public function set value(_v:int):void
		{
			_value = Math.max(_minimum, Math.min(_v, _maximum));
			slider.value = _value;
			label.text = String(_value);
		}
		
		public function get enabled():Boolean
		{
			return slider.enabled;
		}		
		public function set enabled(_b:Boolean):void
		{
			slider.enabled = aBtn.enabled = sBtn.enabled = _b;
		}	
		
		public function set maximum(_m:int):void
		{
			_maximum = _m;
			slider.maximum = _m;
			label.text = String(slider.value);
		}	
		
		public function get maximum():int
		{
			return _maximum;
		}
		
		private function __onSliderChange(e:Event):void
		{
			_value = slider.value;
			label.text = String(_value);
			
			dispatchEvent(new Event(Event.CHANGE));
		}
		private function __onSubstractBtn(e:Event):void
		{
			_value =  Math.max(_minimum, Math.min(_value - tick, _maximum));
			slider.value = _value;
			label.text = String(_value);
			dispatchEvent(new Event(Event.CHANGE));
		}
		private function __onAddBtn(e:Event):void
		{
			_value =  Math.max(_minimum, Math.min(_value + tick, _maximum));
			slider.value = _value;
			label.text = String(_value);
			dispatchEvent(new Event(Event.CHANGE));
		}
	}

}