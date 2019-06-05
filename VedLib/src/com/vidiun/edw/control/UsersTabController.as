package com.vidiun.edw.control
{
	import com.vidiun.edw.control.commands.usrs.GetEntitledUsersCommand;
	import com.vidiun.edw.control.commands.usrs.GetEntryUserCommand;
	import com.vidiun.edw.control.commands.usrs.SetEntryOwnerCommand;
	import com.vidiun.edw.control.events.VedEntryEvent;
	import com.vidiun.edw.control.events.UsersEvent;
	import com.vidiun.vmvc.control.VMvCController;
	
	public class UsersTabController extends VMvCController {
		
		public function UsersTabController() {
			initializeCommands();
		}
		
		public function initializeCommands():void {
			addCommand(UsersEvent.GET_ENTRY_OWNER, GetEntryUserCommand);
			addCommand(UsersEvent.GET_ENTRY_CREATOR, GetEntryUserCommand);
			addCommand(UsersEvent.RESET_ENTRY_USERS, GetEntryUserCommand);
			addCommand(UsersEvent.SET_ENTRY_OWNER, SetEntryOwnerCommand);
			addCommand(UsersEvent.GET_ENTRY_EDITORS, GetEntitledUsersCommand);
			addCommand(UsersEvent.GET_ENTRY_PUBLISHERS, GetEntitledUsersCommand);
		}
	}
}