package com.vidiun.controls.vobjecthadles.events
{
	import flash.events.Event;

	public class VPropChangeEvent extends Event
	{
		public static const WIDTH_CHANGED_EVENT : String = "widthChangedEvent";
		public static const HEIGHT_CHANGED_EVENT : String = "heightChangedEvent";

		public var newValue : Number;

		public function VPropChangeEvent( type : String , newValue : Number , bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
			this.newValue = newValue;
		}
	}
}