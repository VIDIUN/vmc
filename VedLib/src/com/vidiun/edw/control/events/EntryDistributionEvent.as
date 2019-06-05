package com.vidiun.edw.control.events
{
	import com.vidiun.vmvc.control.VMvCEvent;
	import com.vidiun.vo.VidiunEntryDistribution;
	
	public class EntryDistributionEvent extends VMvCEvent
	{
		public static const LIST:String = "content_listEntryDistribution";
		public static const UPDATE_LIST:String = "content_updateEntryDistributionList";
		public static const SUBMIT_UPDATE:String = "content_submitUpdateEntryDistribution";
		public static const UPDATE:String = "content_updateEntryDistribution";
		public static const SUBMIT:String = "content_submitEntryDistribution";
		public static const DELETE:String = "content_deleteEntryDistribution";
		public static const RETRY:String = "content_retryEntryDistribution";
		public static const GET_SENT_DATA:String = "content_getSentDataEntryDistribution";
		public static const GET_RETURNED_DATA:String = "content_getReturnedDataEntryDistribution";
		
		public var entryDistribution:VidiunEntryDistribution;
		public var distributionsWithProfilesToAddArray:Array;
		public var distributionsToRemoveArray:Array;
		
		public function EntryDistributionEvent( type:String, 
												distributionsWithProfilesToAddArray:Array = null,
												distributionsToRemoveArray:Array = null,
												entryDistribution: VidiunEntryDistribution = null,
												bubbles:Boolean=false, 
												cancelable:Boolean=false)
		{
			this.distributionsWithProfilesToAddArray = distributionsWithProfilesToAddArray;
			this.distributionsToRemoveArray = distributionsToRemoveArray;
			this.entryDistribution = entryDistribution;
			super(type, bubbles, cancelable);
		}
	}
}