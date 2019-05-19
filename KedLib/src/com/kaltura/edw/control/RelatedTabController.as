package com.vidiun.edw.control
{
	import com.vidiun.edw.control.commands.UploadTokenCommand;
	import com.vidiun.edw.control.commands.relatedFiles.*;
	import com.vidiun.edw.control.events.RelatedFileEvent;
	import com.vidiun.edw.control.events.UploadTokenEvent;
	import com.vidiun.vmvc.control.VMvCController;
	
	public class RelatedTabController extends VMvCController {
		
		public function RelatedTabController()
		{
			initializeCommands();
		}
		
		public function initializeCommands():void {
			addCommand(RelatedFileEvent.SAVE_ALL_RELATED, SaveRelatedFilesCommand);
			addCommand(RelatedFileEvent.LIST_RELATED_FILES, ListRelatedFilesCommand);
			addCommand(RelatedFileEvent.UPDATE_RELATED_FILE, UpdateRelatedFileCommand);
			
			addCommand(UploadTokenEvent.UPLOAD_TOKEN, UploadTokenCommand);
		}
	}
}