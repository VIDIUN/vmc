package com.vidiun.edw.control
{
	import com.vidiun.edw.control.commands.DuplicateEntryDetailsModelCommand;
	import com.vidiun.edw.control.commands.GetEntryCategoriesCommand;
	import com.vidiun.edw.control.commands.GetLivestreamStatusCommand;
	import com.vidiun.edw.control.commands.GetSingleEntryCommand;
	import com.vidiun.edw.control.commands.ListEntriesCommand;
	import com.vidiun.edw.control.commands.LoadFilterDataCommand;
	import com.vidiun.edw.control.commands.UpdateEntryCategoriesCommand;
	import com.vidiun.edw.control.commands.customData.*;
	import com.vidiun.edw.control.events.VedEntryEvent;
	import com.vidiun.edw.control.events.LoadEvent;
	import com.vidiun.edw.control.events.MetadataDataEvent;
	import com.vidiun.edw.control.events.MetadataProfileEvent;
	import com.vidiun.edw.control.events.ModelEvent;
	import com.vidiun.edw.control.events.SearchEvent;
	import com.vidiun.vmvc.control.VMvCController;
	
	public class DataTabController extends VMvCController {
		
		private static var _instance:DataTabController;
		
		
		public static function getInstance():DataTabController {
			if (!_instance){
				_instance = new DataTabController();
			}
			return _instance;
		}
		
		public function DataTabController()
		{
			initializeCommands();
		}
		
		public function initializeCommands():void {
			addCommand(MetadataProfileEvent.GET_METADATA_UICONF, GetMetadataUIConfCommand);
			addCommand(MetadataProfileEvent.LIST, ListMetadataProfileCommand);
			addCommand(MetadataProfileEvent.GET, GetMetadataProfileCommand);
			addCommand(MetadataDataEvent.LIST, ListMetadataDataCommand);
			addCommand(MetadataDataEvent.UPDATE, UpdateMetadataDataCommand);
			addCommand(MetadataDataEvent.RESET, ListMetadataDataCommand);
			addCommand(SearchEvent.SEARCH_ENTRIES, ListEntriesCommand);
			addCommand(LoadEvent.LOAD_FILTER_DATA, LoadFilterDataCommand);
			
			addCommand(ModelEvent.DUPLICATE_ENTRY_DETAILS_MODEL, DuplicateEntryDetailsModelCommand);
			addCommand(VedEntryEvent.GET_ENTRY_AND_DRILLDOWN, GetSingleEntryCommand);	
			addCommand(VedEntryEvent.GET_ENTRY_CATEGORIES, GetEntryCategoriesCommand);	
			addCommand(VedEntryEvent.RESET_ENTRY_CATEGORIES, GetEntryCategoriesCommand);	
			addCommand(VedEntryEvent.UPDATE_ENTRY_CATEGORIES, UpdateEntryCategoriesCommand);	
			addCommand(VedEntryEvent.GET_LIVESTREAM_STATUS, GetLivestreamStatusCommand);	
			addCommand(VedEntryEvent.RESET_LIVESTREAM_STATUS, GetLivestreamStatusCommand);	
		}
	}
}