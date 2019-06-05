package com.vidiun.edw.components.et
{
	import com.vidiun.types.VidiunEntryModerationStatus;
	import com.vidiun.types.VidiunEntryStatus;
	import com.vidiun.types.VidiunPlaylistType;
	import com.vidiun.utils.VTimeUtil;
	import com.vidiun.vo.VidiunBaseEntry;
	import com.vidiun.vo.VidiunClipAttributes;
	import com.vidiun.vo.VidiunLiveEntry;
	import com.vidiun.vo.VidiunLiveStreamEntry;
	import com.vidiun.vo.VidiunOperationAttributes;
	
	import mx.controls.dataGridClasses.DataGridColumn;
	import mx.formatters.DateFormatter;
	import mx.resources.IResourceManager;
	import mx.resources.ResourceManager;

	public class EntryTableLabelFunctions {
		
		
		public static function formatDate(item:Object, column:DataGridColumn):String {
			var df:DateFormatter = new DateFormatter();
			df.formatString = ResourceManager.getInstance().getString('cms', 'listdateformat');
			var dt:Date = new Date();
			dt.setTime(item.createdAt * 1000);
			return df.format(dt);
		};

		public static function getPlaylistMediaTypes(item:Object, column:DataGridColumn):String {
			switch (item.playlistType) {
				case VidiunPlaylistType.STATIC_LIST:
					return ResourceManager.getInstance().getString('cms', 'manuall');
					break;
				case VidiunPlaylistType.DYNAMIC:
					return ResourceManager.getInstance().getString('cms', 'ruleBased');
					break;
				case VidiunPlaylistType.EXTERNAL:
					return ResourceManager.getInstance().getString('cms', 'externalRss');
					break;
			}
			return "";
		}
		
		public static function getClipIntime(item:Object, column:DataGridColumn):String {
			var entry:VidiunBaseEntry = item as VidiunBaseEntry;
			var result:String = '';
			for each (var opatt:VidiunOperationAttributes in entry.operationAttributes) {
				if (opatt is VidiunClipAttributes) {
					result = formatTime((opatt as VidiunClipAttributes).offset);
					break;
				}
			}
			return result;
		}
		
		
		private static function formatTime(offset:Number):String {
			var df:DateFormatter = new DateFormatter();
			df.formatString = ResourceManager.getInstance().getString('drilldown', 'h_m_s_ms');
			var dt:Date = new Date();
			dt.hours = dt.minutes = dt.seconds = 0;
			dt.milliseconds = offset;
			return df.format(dt);
		}
		
		
		/**
		 * format the timer
		 */
		public static function getTimeFormat(item:Object, column:DataGridColumn):String {
			if (item is VidiunLiveEntry) {
				return ResourceManager.getInstance().getString('cms', 'n_a');
			}
			return VTimeUtil.formatTime2(item.duration, true, true);
		}
		
		
		/**
		 * get correct string for entry moderation status 
		 */		
		public static function getStatusForModeration(item:Object, column:DataGridColumn):String {
			var entry:VidiunBaseEntry = item as VidiunBaseEntry;
			var rm:IResourceManager = ResourceManager.getInstance();
			switch (entry.moderationStatus) {
				case VidiunEntryModerationStatus.APPROVED:  {
					return rm.getString('entrytable', 'approvedStatus');
				}
				case VidiunEntryModerationStatus.AUTO_APPROVED:  {
					return rm.getString('entrytable', 'autoApprovedStatus');
				}
				case VidiunEntryModerationStatus.FLAGGED_FOR_REVIEW:  {
					return rm.getString('entrytable', 'flaggedStatus');
				}
				case VidiunEntryModerationStatus.PENDING_MODERATION:  {
					return rm.getString('entrytable', 'pendingStatus');
				}
				case VidiunEntryModerationStatus.REJECTED:  {
					return rm.getString('entrytable', 'rejectedStatus');
				}
			}
			return '';
		}

		/**
		 * the function translate status type enum to the matching locale string
		 * @param obj	data object for the itemrenderer
		 */
		public static function getStatus(item:Object, column:DataGridColumn):String {
			var rm:IResourceManager = ResourceManager.getInstance();
			var entry:VidiunBaseEntry = item as VidiunBaseEntry;
			var status:String = entry.status;
			switch (status) {
				case VidiunEntryStatus.DELETED: 
					//fixed to all states
					return rm.getString('cms', 'statusdeleted');
					break;
				
				case VidiunEntryStatus.ERROR_IMPORTING: 
					//fixed to all states
					return rm.getString('cms', 'statuserrorimporting');
					break;
				
				case VidiunEntryStatus.ERROR_CONVERTING: 
					//fixed to all states
					return rm.getString('cms', 'statuserrorconverting');
					break;
				
				case VidiunEntryStatus.IMPORT: 
					//fixed to all states
					if (entry is VidiunLiveStreamEntry) {
						return rm.getString('cms', 'provisioning');
					}
					else {
						return rm.getString('cms', 'statusimport');
					}
					break;
				
				case VidiunEntryStatus.PRECONVERT: 
					//fixed to all states
					return rm.getString('cms', 'statuspreconvert');
					break;
				
				case VidiunEntryStatus.PENDING:
					return rm.getString('cms', 'statuspending');
					break;
				
				case VidiunEntryStatus.NO_CONTENT:  
					return rm.getString('cms', 'statusNoMedia');
					break;
				
				case VidiunEntryStatus.READY:  
					return getStatusForReadyEntry(entry);
					break;
				
			}
			return '';
		}
		
		
		private static const SCHEDULING_ALL_OR_IN_FRAME:int = 1;
		private static const SCHEDULING_BEFORE_FRAME:int = 2;
		private static const SCHEDULING_AFTER_FRAME:int = 3;
		
		/**
		 * the text for a ready entry is caculated according to moderation status / scheduling
		 * */
		private static function getStatusForReadyEntry(entry:VidiunBaseEntry):String {
			var rm:IResourceManager = ResourceManager.getInstance();
			var result:String = '';
			var now:Date = new Date();
			var time:int = now.time / 1000;
			var schedulingType:int = 0;
			
			if (((entry.startDate == int.MIN_VALUE) && (entry.endDate == int.MIN_VALUE)) || ((entry.startDate <= time) && (entry.endDate >= time)) || ((entry.startDate < time) && (entry.endDate == int.MIN_VALUE)) || ((entry.startDate == int.MIN_VALUE) && (entry.endDate > time))) {
				schedulingType = SCHEDULING_ALL_OR_IN_FRAME;
			}
			else if (entry.startDate > time) {
				schedulingType = SCHEDULING_BEFORE_FRAME;
			}
			else if (entry.endDate < time) {
				schedulingType = SCHEDULING_AFTER_FRAME;
			}
			
			var moderationStatus:int = entry.moderationStatus;
			
			
			switch (moderationStatus) {
				case VidiunEntryModerationStatus.APPROVED:
				case VidiunEntryModerationStatus.AUTO_APPROVED:
				case VidiunEntryModerationStatus.FLAGGED_FOR_REVIEW:  
					if (schedulingType == SCHEDULING_ALL_OR_IN_FRAME){
						result = rm.getString('entrytable', 'liveStatus');
					}
					else if (schedulingType == SCHEDULING_BEFORE_FRAME) {
						result = rm.getString('entrytable', 'scheduledStatus');
					}
					else if (schedulingType == SCHEDULING_AFTER_FRAME) {
						result = rm.getString('entrytable', 'finishedStatus');
					}
					break;
				
				case VidiunEntryModerationStatus.PENDING_MODERATION:  
					result = rm.getString('entrytable', 'pendingStatus');
					break;
				
				case VidiunEntryModerationStatus.REJECTED:  
					result = rm.getString('entrytable', 'rejectedStatus');
					break;
				
			}
			
			
			return result;
		}
	}
}