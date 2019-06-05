package com.vidiun.edw.events
{
	import flash.events.Event;
	
	public class VedErrorEvent extends Event {
		
		public static const ERROR:String = "vedError";
		
		
		private var _error:String;
		
		public function VedErrorEvent(type:String, text:String, bubbles:Boolean = true, cancelable:Boolean=false) {
			super(type, bubbles, cancelable);
			_error = text;
		}
		
		
		/**
		 * description of the error associated with this event 
		 */		
		public function get error():String {
			return _error;
		}
	}
}