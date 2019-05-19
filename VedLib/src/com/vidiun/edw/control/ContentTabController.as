package com.vidiun.edw.control
{
	import com.vidiun.edw.control.commands.mix.GetAllEntriesCommand;
	import com.vidiun.edw.control.commands.mix.GetEntryRoughcutsCommand;
	import com.vidiun.edw.control.commands.mix.ResetContentPartsCommand;
	import com.vidiun.edw.control.events.VedEntryEvent;
	import com.vidiun.vmvc.control.VMvCController;
	
	public class ContentTabController extends VMvCController {
		
		public function ContentTabController()
		{
			initializeCommands();
		}
		
		public function initializeCommands():void {
			addCommand(VedEntryEvent.GET_ENTRY_ROUGHCUTS, GetEntryRoughcutsCommand);
			addCommand(VedEntryEvent.GET_ALL_ENTRIES, GetAllEntriesCommand);
			addCommand(VedEntryEvent.RESET_PARTS, ResetContentPartsCommand);
		}
	}
}