package com.vidiun.edw.control
{
	import com.vidiun.edw.control.commands.*;
	import com.vidiun.edw.control.commands.usrs.GetEntryUserCommand;
	import com.vidiun.edw.control.events.*;
	import com.vidiun.vmvc.control.VMvCController;
	
	/**
	 * Controller which is accessible from all elements, so that VMC
	 * can use VED commands. 
	 * @author Atar
	 */	
	public class VedController extends VMvCController {
		
		private static var _instance:VedController;
		
		public static function getInstance():VedController {
			if (!_instance) {
				_instance = new VedController(new Enforcer());
			}
			return _instance;
		}
		
		public function VedController(enf:Enforcer) {
			
			initializeCommands();
		}
		
		
		public function initializeCommands():void {
			addCommand(LoadEvent.LOAD_FILTER_DATA, LoadFilterDataCommand);
			addCommand(VedEntryEvent.SET_SELECTED_ENTRY, SetSelectedEntryCommand);
			addCommand(VedEntryEvent.UPDATE_SELECTED_ENTRY_REPLACEMENT_STATUS, GetSingleEntryCommand);
			addCommand(VedEntryEvent.GET_ENTRY_AND_DRILLDOWN, GetSingleEntryCommand);
			addCommand(UsersEvent.GET_ENTRY_OWNER, GetEntryUserCommand);
			addCommand(SearchEvent.SEARCH_ENTRIES, ListEntriesCommand);
		}
	}
}
class Enforcer{}