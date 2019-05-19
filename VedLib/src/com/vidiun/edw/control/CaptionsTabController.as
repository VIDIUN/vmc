package com.vidiun.edw.control
{
	import com.vidiun.edw.control.commands.UploadTokenCommand;
	import com.vidiun.edw.control.commands.captions.*;
	import com.vidiun.edw.control.events.CaptionsEvent;
	import com.vidiun.edw.control.events.UploadTokenEvent;
	import com.vidiun.vmvc.control.VMvCController;
	
	public class CaptionsTabController extends VMvCController {
		
		public function CaptionsTabController()
		{
			initializeCommands();
		}
		
		public function initializeCommands():void {
			addCommand(CaptionsEvent.LIST_CAPTIONS, ListCaptionsCommand);
			addCommand(CaptionsEvent.SAVE_ALL, SaveCaptionsCommand);
			addCommand(CaptionsEvent.UPDATE_CAPTION, GetCaptionDownloadUrl);
			addCommand(UploadTokenEvent.UPLOAD_TOKEN, UploadTokenCommand);
		}
	}
}