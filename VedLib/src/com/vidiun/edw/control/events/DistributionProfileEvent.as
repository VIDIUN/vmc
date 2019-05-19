package com.vidiun.edw.control.events
{
	import com.vidiun.vmvc.control.VMvCEvent;

	public class DistributionProfileEvent extends VMvCEvent
	{
		public static const LIST:String = "content_listDistributionProfile";
		public static const UPDATE:String = "content_updateDistributionProfiles";
		
		public var distributionProfiles:Array;
		
		public function DistributionProfileEvent( type:String,
												  distributionProfiles:Array = null,
												  bubbles:Boolean=false, 
												  cancelable:Boolean=false)
		{
			this.distributionProfiles = distributionProfiles;
			super(type, bubbles, cancelable);
		}
	}
}