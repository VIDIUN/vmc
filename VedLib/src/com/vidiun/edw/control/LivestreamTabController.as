package com.vidiun.edw.control
{
	import com.vidiun.edw.control.commands.ListLiveConversionProfilesCommand;
	import com.vidiun.edw.control.commands.RegenerateLiveTokenCommand;
	import com.vidiun.edw.control.events.LiveEvent;
	import com.vidiun.edw.control.events.ProfileEvent;
	import com.vidiun.vmvc.control.VMvCController;
	
	public class LivestreamTabController extends VMvCController {
		
		public function LivestreamTabController()
		{
			initializeCommands();
		}
		
		public function initializeCommands():void {
			addCommand(ProfileEvent.LIST_LIVE_CONVERSION_PROFILES, ListLiveConversionProfilesCommand);
			addCommand(LiveEvent.REGENERATE_LIVE_TOKEN, RegenerateLiveTokenCommand);
		}
	}
}