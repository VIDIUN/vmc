package com.vidiun.edw.control.events
{
	import com.vidiun.vmvc.control.VMvCEvent;

	public class LiveEvent extends VMvCEvent
	{
		/**
		 * regenerate live stream security token
		 */
		public static const REGENERATE_LIVE_TOKEN : String = "content_regenerateLiveToken";
		
		
		public function LiveEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}	
	}
}