package com.vidiun.edw.control
{
	import com.vidiun.edw.control.commands.GetSingleEntryCommand;
	import com.vidiun.edw.control.commands.ListFlavorAssetsByEntryIdCommand;
	import com.vidiun.edw.control.commands.dist.*;
	import com.vidiun.edw.control.commands.thumb.ListThumbnailAssetCommand;
	import com.vidiun.edw.control.events.EntryDistributionEvent;
	import com.vidiun.edw.control.events.VedEntryEvent;
	import com.vidiun.edw.control.events.ThumbnailAssetEvent;
	import com.vidiun.vmvc.control.VMvCController;
	
	public class DistributionTabController extends VMvCController {
		
		public function DistributionTabController()
		{
			initializeCommands();
		}
		
		public function initializeCommands():void {
			addCommand(ThumbnailAssetEvent.LIST, ListThumbnailAssetCommand);
			
			addCommand(VedEntryEvent.GET_FLAVOR_ASSETS, ListFlavorAssetsByEntryIdCommand);
			addCommand(VedEntryEvent.UPDATE_SELECTED_ENTRY_REPLACEMENT_STATUS, GetSingleEntryCommand);
			
			addCommand(EntryDistributionEvent.LIST, ListEntryDistributionCommand);
			addCommand(EntryDistributionEvent.UPDATE_LIST, UpdateEntryDistributionsCommand);
			addCommand(EntryDistributionEvent.SUBMIT, SubmitEntryDistributionCommand);
			addCommand(EntryDistributionEvent.SUBMIT_UPDATE, SubmitUpdateEntryDistributionCommand);
			addCommand(EntryDistributionEvent.UPDATE, UpdateEntryDistributionCommand);
			addCommand(EntryDistributionEvent.RETRY, RetryEntryDistributionCommand);
			addCommand(EntryDistributionEvent.GET_SENT_DATA, GetSentDataEntryDistributionCommand);
			addCommand(EntryDistributionEvent.GET_RETURNED_DATA, GetReturnedDataEntryDistributionCommand);
		}
	}
}