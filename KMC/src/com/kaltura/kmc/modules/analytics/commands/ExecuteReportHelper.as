package com.vidiun.vmc.modules.analytics.commands {
	import com.vidiun.vmc.modules.analytics.model.AnalyticsModelLocator;
	import com.vidiun.vmc.modules.analytics.model.types.ScreenTypes;
	import com.vidiun.vmc.modules.analytics.view.renderers.DrillDownLinkButton;
	import com.vidiun.vmc.modules.analytics.vo.FilterVo;
	import com.vidiun.types.VidiunReportInterval;
	import com.vidiun.vo.VidiunEndUserReportInputFilter;
	import com.vidiun.vo.VidiunReportInputFilter;
	
	import mx.resources.ResourceManager;
	import mx.formatters.DateFormatter;

	public class ExecuteReportHelper {
		private static var _model:AnalyticsModelLocator = AnalyticsModelLocator.getInstance();

		private static var dateFormatter:DateFormatter; 
		
		public function ExecuteReportHelper() {
		}


		public static function reportSetupBeforeExecution():void {
			_model.showRefererIcon = false;
			if (_model.currentScreenState == ScreenTypes.TOP_SYNDICATIONS_DRILL_DOWN)
				_model.showRefererIcon = true;
		}

		
		private static function initDateFormatter():void {
			dateFormatter = new DateFormatter();
			dateFormatter.formatString = "YYYYMMDD"; 
		}
		
		
		public static function getObjectIds(screenType:int):String {
			// specific object (drilldown):
			var objectIds:String = '';
			if (_model.selectedEntry && 
				(screenType == ScreenTypes.VIDEO_DRILL_DOWN_DEFAULT 
				|| screenType == ScreenTypes.VIDEO_DRILL_DOWN_DROP_OFF 
				|| screenType == ScreenTypes.VIDEO_DRILL_DOWN_INTERACTIONS 
				|| screenType == ScreenTypes.CONTENT_CONTRIBUTIONS_DRILL_DOWN 
				|| screenType == ScreenTypes.TOP_SYNDICATIONS_DRILL_DOWN 
				|| screenType == ScreenTypes.MAP_OVERLAY_DRILL_DOWN 
				|| screenType == ScreenTypes.END_USER_STORAGE_DRILL_DOWN
				|| screenType == ScreenTypes.PLATFORM_DRILL_DOWN)) {
				objectIds = _model.selectedReportData.objectIds = _model.selectedEntry;
			}
			return objectIds;
		}
		
		
		/**
		 * create the filter for the given report
		 * @param fvo	filter vo from screen
		 * @param screenType	screen type
		 * @return	filter object that should be sent to server 
		 */
		public static function createFilterFromReport(fvo:FilterVo, screenType:int):VidiunReportInputFilter {
			var vrif:VidiunReportInputFilter;
			//If we have a user report call we need to have another filter (that support application and users) 
			//when we generate the report get total call
			if (_model.entitlementEnabled && 
				(screenType == ScreenTypes.END_USER_ENGAGEMENT 
					|| screenType == ScreenTypes.END_USER_ENGAGEMENT_DRILL_DOWN 
					|| screenType == ScreenTypes.VIDEO_DRILL_DOWN_DEFAULT 
					|| screenType == ScreenTypes.VIDEO_DRILL_DOWN_DROP_OFF 
					|| screenType == ScreenTypes.VIDEO_DRILL_DOWN_INTERACTIONS 
					|| screenType == ScreenTypes.END_USER_STORAGE 
					|| screenType == ScreenTypes.END_USER_STORAGE_DRILL_DOWN)) {
				vrif = ExecuteReportHelper.createEndUserFilterFromCurrentReport(_model.getFilterForScreen(screenType));
			}
			else if (screenType == ScreenTypes.PLATFORM
					|| screenType == ScreenTypes.PLATFORM_DRILL_DOWN
					|| screenType == ScreenTypes.OS
					|| screenType == ScreenTypes.BROWSER) {
				vrif = ExecuteReportHelper.createEndUserFilterFromCurrentReport(_model.getFilterForScreen(screenType));
			}
			else {
				vrif = ExecuteReportHelper.createFilterFromCurrentReport(_model.getFilterForScreen(screenType));
			}
			return vrif;
		}
		
		

		/**
		 * creates a new VidiunReportInputFilter from the current filter in the VMCModelLocator instance
		 * @return vrif the new VidiunReportInputFilter
		 *
		 */
		public static function createFilterFromCurrentReport(fvo:FilterVo):VidiunReportInputFilter {
			var vrif:VidiunReportInputFilter = new VidiunReportInputFilter();
			var today:Date = new Date();
			if (fvo) {
				// filter dates are in seconds, Date.time is in ms, Date.timezoneOffset is in minutes.
				if (!dateFormatter) initDateFormatter();
				// use new filters (YYYYMMDD). send local date.
				vrif.fromDay = dateFormatter.format(fvo.fromDate);
				vrif.toDay = dateFormatter.format(fvo.toDate);
				vrif.keywords = fvo.keywords;
				vrif.categories = fvo.categories;
				vrif.searchInTags = true;
				vrif.searchInAdminTags = false;
				
				if (fvo.interval != null){
					vrif.interval = fvo.interval;
				}
				// add time offset in minutes.
				vrif.timeZoneOffset = today.timezoneOffset;
			}

			return vrif;
		}
		
		public static function createEndUserFilterFromCurrentReport(fvo:FilterVo):VidiunEndUserReportInputFilter{
			var veurif:VidiunEndUserReportInputFilter = new VidiunEndUserReportInputFilter();
			var today:Date = new Date();
			if (fvo) {
				// filter dates are in seconds, Date.time is in ms, Date.timezoneOffset is in minutes.
				if (!dateFormatter) initDateFormatter();
				// use new filters (YYYYMMDD). send local date.
				veurif.fromDay = dateFormatter.format(fvo.fromDate);
				veurif.toDay = dateFormatter.format(fvo.toDate);
				
				veurif.keywords = fvo.keywords;
				
				//if we selected specific application
				if(fvo.application != ResourceManager.getInstance().getString('analytics', 'all'))
					veurif.application = fvo.application;
				
				if (fvo.interval != null){
					veurif.interval = fvo.interval;
				}
				
				veurif.userIds = fvo.userIds;
				veurif.playbackContext = fvo.playbackContext;
				veurif.categories = fvo.categories;
				veurif.searchInTags = true;
				veurif.searchInAdminTags = false;
				// add time offset in minutes.
				veurif.timeZoneOffset = today.timezoneOffset;
			}
			
			return veurif; 
		}
	}
}