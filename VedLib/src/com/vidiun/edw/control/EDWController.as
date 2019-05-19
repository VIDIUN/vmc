package com.vidiun.edw.control
{
	import com.vidiun.edw.control.commands.*;
	import com.vidiun.edw.control.events.VedEntryEvent;
	import com.vidiun.vmvc.control.VMvCController;

	public class EDWController extends VMvCController {
		
		public function EDWController()
		{
			initializeCommands();
		}
		
		public function initializeCommands():void {
			addCommand(VedEntryEvent.DELETE_ENTRY, DeleteBaseEntryCommand);
			addCommand(VedEntryEvent.SET_SELECTED_ENTRY, SetSelectedEntryCommand);
			addCommand(VedEntryEvent.UPDATE_SINGLE_ENTRY, UpdateSingleEntry);
			addCommand(VedEntryEvent.LIST_ENTRIES_BY_REFID, ListEntriesByRefidCommand);
			
		}
	}
}