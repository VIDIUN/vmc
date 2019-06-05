package com.vidiun.vmc.events {
	import flash.events.Event;

	/**
	 * VmcHelpEvent is the event VMC modules use to request
	 * showing help pages.
	 * @author Atar
	 */
	public class VmcHelpEvent extends Event {

		public static const HELP:String = "helpRequest";

		private var _anchor:String;


		public function VmcHelpEvent(type:String, anchor:String, bubbles:Boolean = true, cancelable:Boolean = false) {
			super(type, bubbles, cancelable);
			_anchor = anchor;
		}
		
		override public function clone():Event {
			return new VmcHelpEvent(super.type, _anchor, super.bubbles, super.cancelable);
		}


		/**
		 * the anchore on the help page to show
		 */
		public function get anchor():String {
			return _anchor;
		}

	}
}