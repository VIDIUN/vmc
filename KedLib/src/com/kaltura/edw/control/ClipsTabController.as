package com.vidiun.edw.control
{
	import com.vidiun.edw.control.commands.clips.*;
	import com.vidiun.edw.control.events.ClipEvent;
	import com.vidiun.vmvc.control.VMvCController;
	
	public class ClipsTabController extends VMvCController {
		
		public function ClipsTabController()
		{
			initializeCommands();
		}
		
		public function initializeCommands():void {
			
			addCommand(ClipEvent.GET_ENTRY_CLIPS, GetEntryClipsCommand);
			addCommand(ClipEvent.RESET_MODEL_ENTRY_CLIPS, ResetEntryClipsCommand);
		}
	}
}