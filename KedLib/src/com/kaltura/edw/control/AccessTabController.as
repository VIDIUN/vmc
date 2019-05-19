package com.vidiun.edw.control
{
	import com.vidiun.edw.control.commands.AddNewAccessControlProfileCommand;
	import com.vidiun.edw.control.commands.ListAccessControlsCommand;
	import com.vidiun.edw.control.events.AccessControlEvent;
	import com.vidiun.vmvc.control.VMvCController;
	
	public class AccessTabController extends VMvCController {
		
		public function AccessTabController()
		{
			initializeCommands();
		}
		
		public function initializeCommands():void {
			addCommand(AccessControlEvent.ADD_NEW_ACCESS_CONTROL_PROFILE, AddNewAccessControlProfileCommand);
			addCommand(AccessControlEvent.LIST_ACCESS_CONTROLS_PROFILES, ListAccessControlsCommand);
		}
	}
}