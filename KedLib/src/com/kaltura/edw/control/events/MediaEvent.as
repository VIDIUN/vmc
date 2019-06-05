package com.vidiun.edw.control.events
{
	import com.vidiun.vmvc.control.VMvCEvent;
	import com.vidiun.vo.VidiunMediaEntry;

	public class MediaEvent extends VMvCEvent
	{
		public static const APPROVE_REPLACEMENT:String = "approveReplacement";
		public static const CANCEL_REPLACEMENT:String = "cancelReplacement";
		
		/**
		 * update media files on entry <br>
		 * data should be {conversionProfileId, resource}
		 */		
		public static const UPDATE_MEDIA:String = "updateMedia";
		
		/**
		 * update media file for single flavor on entry <br>
		 * data should be {flavorAssetId, resource}
		 */		
		public static const UPDATE_SINGLE_FLAVOR:String = "updateSingleFlavor";
		
		/**
		 * add a single flavor to an entry and set its content (media) <br>
		 * data should be {flavorParamsId, resource}
		 */		
		public static const ADD_SINGLE_FLAVOR:String = "addSingleFlavor";
		
		
		
		
		public var entry:VidiunMediaEntry;
		/**
		 * whether to open entrydrilldown after response returns
		 * */
		public var openDrilldown:Boolean;
		
		public function MediaEvent(type:String, entry:VidiunMediaEntry, openDrilldown:Boolean = false, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			this.entry = entry;
			this.openDrilldown = openDrilldown;
			super(type, bubbles, cancelable);
		}
	}
}