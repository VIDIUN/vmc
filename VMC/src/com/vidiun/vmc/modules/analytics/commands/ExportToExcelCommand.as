package com.vidiun.vmc.modules.analytics.commands {
	import com.adobe.cairngorm.commands.ICommand;
	import com.adobe.cairngorm.control.CairngormEvent;
	import com.vidiun.commands.report.ReportGetUrlForReportAsCsv;
	import com.vidiun.events.VidiunEvent;
	import com.vidiun.vmc.modules.analytics.model.AnalyticsModelLocator;
	import com.vidiun.vmc.modules.analytics.model.types.ScreenTypes;
	import com.vidiun.vmc.modules.analytics.view.core.FileManager;
	import com.vidiun.vo.VidiunEndUserReportInputFilter;
	import com.vidiun.vo.VidiunFilterPager;
	import com.vidiun.vo.VidiunReportInputFilter;
	
	import mx.controls.Alert;
	import mx.events.CloseEvent;
	import mx.resources.ResourceManager;
	import mx.rpc.IResponder;

	public class ExportToExcelCommand implements ICommand, IResponder {
		private var _model:AnalyticsModelLocator = AnalyticsModelLocator.getInstance();
		private var fm:FileManager = new FileManager();
		private var _fileUrl:String = "";


		public function execute(event:CairngormEvent):void {
			_model.loadingFlag = true;
			_model.processingCSVFlag = true;
			var headers:String = "";

			for (var j:int = 0; j < _model.selectedReportData.originalTotalHeaders.length; j++)
				if (_model.selectedReportData.originalTotalHeaders[j] != "object_id")
					headers += ResourceManager.getInstance().getString('analytics', _model.selectedReportData.originalTotalHeaders[j]) + ",";

			headers = headers.substr(0, headers.length - 1);
			headers += ";"; //";Object Id,"; (see mantis ticket 13090 requesting to remove this header)

			if (_model.selectedReportData.wasObjectIdDropped && (_model.selectedReportData.objectIds == "" || _model.selectedReportData.objectIds == null)) {
				headers += "Object Id,";
			}

			if (_model.selectedReportData.originalTableHeaders) {
				for (var i:int = 0; i < _model.selectedReportData.originalTableHeaders.length; i++) {
					if (_model.selectedReportData.originalTableHeaders[i] != "object_id") {
						headers += ResourceManager.getInstance().getString('analytics', _model.selectedReportData.originalTableHeaders[i]) + ",";
					}
				}
				// remove last ","
				headers = headers.substr(0, headers.length - 1);
			}
			else {
				headers += ResourceManager.getInstance().getString('analytics', 'no_table');
			}



			// default texts (not supposed to be used)
			var message2Send:String = _model.selectedReportData.message;
			if (_model.selectedReportData.message == "" || _model.selectedReportData.message == null)
				message2Send = ResourceManager.getInstance().getString('analytics', 'no_msg');
			message2Send = message2Send.replace(/<.*?>/g, ""); // remove HTML tags if any
			
			if (_model.selectedReportData.title == "" || _model.selectedReportData.title == null)
				_model.selectedReportData.title = ResourceManager.getInstance().getString('analytics', 'no_ttl');

			
			var vrif:VidiunReportInputFilter;
			
			switch (_model.currentScreenState) {
				case ScreenTypes.END_USER_ENGAGEMENT:
				case ScreenTypes.END_USER_ENGAGEMENT_DRILL_DOWN:
				case ScreenTypes.END_USER_STORAGE:
				case ScreenTypes.END_USER_STORAGE_DRILL_DOWN:
					vrif = ExecuteReportHelper.createEndUserFilterFromCurrentReport(_model.filter);
					//in the reports above we need to send playback context instead of categories - we get it on the filter.
//					vrif.playbackContext = vrif.categories;
//					vrif.categories = null;
					break;
					
				case ScreenTypes.VIDEO_DRILL_DOWN_DEFAULT:
				case ScreenTypes.VIDEO_DRILL_DOWN_DROP_OFF:
				case ScreenTypes.VIDEO_DRILL_DOWN_INTERACTIONS:
					if (_model.entitlementEnabled) {
						vrif = ExecuteReportHelper.createEndUserFilterFromCurrentReport(_model.filter);
						//in the reports above we need to send playback context instead of categories
						vrif.playbackContext = vrif.categories;
						vrif.categories = null;
					}
					else {
						vrif = ExecuteReportHelper.createFilterFromCurrentReport(_model.filter);
					}
					break;
				default:
					vrif = ExecuteReportHelper.createFilterFromCurrentReport(_model.filter);
					break;
			}
			
			// create a pager to add all entries to log, regardless of viewed entries
			var pager:VidiunFilterPager = new VidiunFilterPager();
			pager.pageIndex = 1;
			if (_model.selectedReportData.totalCount > 0) {
				pager.pageSize = _model.selectedReportData.totalCount;
			}
			else {
				// reports where the totals are too heavy to count return 0 for total. in this case we 
				// still want to export "all" (this will not break cases where there actually is no data)
				pager.pageSize = 1000000;
			}
			
			var export2Csv:ReportGetUrlForReportAsCsv = new ReportGetUrlForReportAsCsv(_model.selectedReportData.title,
					message2Send, headers, _model.selectedReportData.type, vrif, _model.selectedReportData.selectedDim,
					pager, _model.selectedReportData.orderBy, _model.selectedReportData.objectIds);

			export2Csv.addEventListener(VidiunEvent.COMPLETE, result);
			export2Csv.addEventListener(VidiunEvent.FAILED, fault);
			_model.vc.post(export2Csv);
		}


		public function result(data:Object):void {
			_model.processingCSVFlag = false;
			_model.checkLoading();
			var vEvent:VidiunEvent = data as VidiunEvent;
			vEvent.target.removeEventListener(VidiunEvent.COMPLETE, result);
			vEvent.target.removeEventListener(VidiunEvent.FAILED, fault);
			_fileUrl = vEvent.data as String;
			Alert.show(ResourceManager.getInstance().getString('analytics', 'csvReady'),
				ResourceManager.getInstance().getString('analytics', 'csvReadyTitle'), Alert.OK, null, onClose);
		}


		private function onClose(event:CloseEvent):void {
			fm.downloadFile(_fileUrl,
				ResourceManager.getInstance().getString('analytics', 'downloadCSVTitle'),
				_model.selectedReportData.title + ".csv");
		}


		public function fault(info:Object):void {
			_model.processingCSVFlag = false;
			_model.checkLoading();
			var vEvent:VidiunEvent = info as VidiunEvent;
			vEvent.target.removeEventListener(VidiunEvent.COMPLETE, result);
			vEvent.target.removeEventListener(VidiunEvent.FAILED, fault);
			if (vEvent.error.errorCode == "POST_TIMEOUT" || vEvent.error.errorCode == "CONNECTION_TIMEOUT") {
				// report is taking more than client-timeout to process
				Alert.show(ResourceManager.getInstance().getString('analytics', 'csvProcessTimeout'),
					ResourceManager.getInstance().getString('analytics', 'error'));
			}
			else {
				Alert.show(vEvent.error.errorMsg,
					ResourceManager.getInstance().getString('analytics', 'error'));
			}
		}
	}
}
