package com.vidiun.edw.control.events
{
	import com.vidiun.vmvc.control.VMvCEvent;
	
	/**
	 * This class represents event related to metadata
	 * @author Michal
	 * 
	 */
	public class MetadataDataEvent extends VMvCEvent
	{
		public static const ADD : String = "content_add_metadata_data";
		
		/**
		 * get current entry data
		 */
		public static const LIST : String = "content_list_metadata_data";
		
		/**
		 * update current entry mtadata 
		 * event.data is entry id
		 */
		public static const UPDATE : String = "content_update_metadata_data";
		
		/**
		 * reset current entry data on the model
		 */
		public static const RESET : String = "content_reset_metadata_data";

		/**
		 * Constructs a new MetadataDataEvent 
		 * @param type the type of the event: add / list / update
		 * @param bubbles
		 * @param cancelable
		 * 
		 */		
		public function MetadataDataEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}