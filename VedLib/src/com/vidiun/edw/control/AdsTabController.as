package com.vidiun.edw.control
{
	import com.vidiun.edw.control.commands.cuepoints.*;
	import com.vidiun.edw.control.events.CuePointEvent;
	import com.vidiun.vmvc.control.VMvCController;
	
	public class AdsTabController extends VMvCController {
		
		public function AdsTabController()
		{
			initializeCommands();
		}
		
		public function initializeCommands():void {
			addCommand(CuePointEvent.RESET_CUEPOINTS_COUNT, ResetCuePointsCount);
			addCommand(CuePointEvent.COUNT_CUEPOINTS, CountCuePoints);
			addCommand(CuePointEvent.DOWNLOAD_CUEPOINTS, DownloadCuePoints);
			addCommand(CuePointEvent.UPLOAD_CUEPOINTS, UploadCuePoints);
		}
	}
}