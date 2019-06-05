package com.vidiun.vmc.events
{
	import flash.events.Event;
	
	/**
	 * The ErrorEvent class represents errors that VMCModules encounter 
	 * and need to inform the main VMC application. 
	 * @author Atar
	 */	
	public class VmcErrorEvent extends Event {
		
		
		public static const ERROR:String = "vmcError";
		
		
		private var _error:String;
		
		
		public function VmcErrorEvent(type:String, text:String, bubbles:Boolean = true, cancelable:Boolean=false) {
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