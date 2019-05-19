package com.vidiun.edw.events
{
	import flash.events.Event;
	
	
	/**
	 * An event with data, used for general VED events.
	 * */
	public class VedDataEvent extends Event {
		
		/**
		 * this is the event dispatched by VED when the selected entry is reloaded
		 * */
		public static const ENTRY_RELOADED:String = "vedEntryReloaded";
		
		/**
		 * this is the event dispatched by VED after the selected entry was updated 
		 */		
		public static const ENTRY_UPDATED:String = "vedEntryUpdated";
		
		/**
		 * this event tells the envelope app that the window should be closed
		 * */
		public static const CLOSE_WINDOW:String = "vedCloseWindow";
		
		/**
		 * this event tells the envelope app that a category had beed deleted
		 * */
		public static const CATEGORY_CHANGED:String = "vedCategoryChanged";
		
		/**
		 * this event tells the envelope app that the replacement entry should be opened
		 * */
		public static const OPEN_REPLACEMENT:String = "vedOpenReplacement";
		
		/**
		 * this event tells the envelope app that the given entry should be opened
		 * event.data is the entry to open
		 */
		public static const OPEN_ENTRY:String = "vedOpenEntry"; 
		
		/**
		 * this event tells the EDW that it should switch to another panel
		 * event.data is the id of the required panel
		 */
		public static const NAVIGATE:String = "vedNavigate"; 
		
		
		
		public var data:*;
		
		public function VedDataEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
		
		override public function clone():Event {
			var e:VedDataEvent = new VedDataEvent(this.type, this.bubbles, this.cancelable);
			e.data = this.data;
			return e;
		}
	}
}