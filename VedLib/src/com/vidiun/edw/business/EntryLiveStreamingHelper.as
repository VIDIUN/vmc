package com.vidiun.edw.business
{
	import com.vidiun.types.VidiunDVRStatus;
	import com.vidiun.types.VidiunRecordStatus;
	import com.vidiun.utils.VTimeUtil;
	import com.vidiun.vo.VidiunLiveStreamEntry;
	
	import mx.resources.ResourceManager;

	public class EntryLiveStreamingHelper
	{
		
		public static const PREFIXES_WIDTH:Number = 130;
		public static const BROADCASTING_WIDTH:Number = 500;
		
		public function EntryLiveStreamingHelper()
		{
		}
		
		public static function getDVRStatus (entry:VidiunLiveStreamEntry):String {
			var result:String = '';
			if (!entry.dvrStatus || entry.dvrStatus == VidiunDVRStatus.DISABLED) {
				result = ResourceManager.getInstance().getString('drilldown', 'off');
			}
			else if (entry.dvrStatus == VidiunDVRStatus.ENABLED) {
				result = ResourceManager.getInstance().getString('drilldown', 'on');
			}
			return result;
		}
		
		public static function getDVRWindow (entry:VidiunLiveStreamEntry):String {
			return ResourceManager.getInstance().getString('drilldown', 'dvrWinFormat', [VTimeUtil.formatTime2(entry.dvrWindow*60, true, false, true)]);
		}
		
		public static function getRecordStatus (entry:VidiunLiveStreamEntry):String {
			var result:String = '';
			if (!entry.recordStatus || entry.recordStatus == VidiunRecordStatus.DISABLED) {
				result = ResourceManager.getInstance().getString('drilldown', 'off');
			}
			else if (entry.recordStatus == VidiunRecordStatus.APPENDED || entry.recordStatus == VidiunRecordStatus.PER_SESSION) {
				result = ResourceManager.getInstance().getString('drilldown', 'on');
			}
			return result;
		}
		
		
	}
}