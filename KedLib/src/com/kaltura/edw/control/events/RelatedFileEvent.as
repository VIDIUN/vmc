package com.vidiun.edw.control.events
{
	import com.vidiun.vmvc.control.VMvCEvent;
	import com.vidiun.vo.VidiunAttachmentAsset;
	
	public class RelatedFileEvent extends VMvCEvent
	{
		public static const LIST_RELATED_FILES:String = "listRelatedFiles";
		public static const SAVE_ALL_RELATED:String = "saveAllRelated";
		public static const UPDATE_RELATED_FILE:String = "updateRelatedFile";

		public var attachmentAsset:VidiunAttachmentAsset;
		/**
		 * array of related files to add 
		 */		
		public var relatedToAdd:Array;
		/**
		 * array of related files to update 
		 */		
		public var relatedToUpdate:Array;
		/**
		 * array of related files to delete 
		 */		
		public var relatedToDelete:Array;
		
		public function RelatedFileEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}