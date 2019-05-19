package com.vidiun.vmc.modules.analytics.commands
{
	import com.adobe.cairngorm.commands.ICommand;
	import com.adobe.cairngorm.control.CairngormEvent;
	import com.vidiun.vmc.modules.analytics.control.GraphEvent;
	import com.vidiun.vmc.modules.analytics.model.AnalyticsModelLocator;
	import com.vidiun.vmc.modules.analytics.model.reportdata.ReportData;

	public class ChangeDimCommand implements ICommand
	{
		private var _model : AnalyticsModelLocator = AnalyticsModelLocator.getInstance();
		public function execute(event:CairngormEvent):void
		{
			var graphEvent : GraphEvent = event as GraphEvent;
			var reportData:ReportData = _model.reportDataMap[_model.currentScreenState] as ReportData;
			reportData.selectedDim = graphEvent.newDim;
			reportData.chartDp = reportData.dimToChartDpMap[graphEvent.newDim];
			reportData.selectedChartHeaders = reportData.dimToChartHeadersMap[graphEvent.newDim];
			
			_model.selectedReportData = null; // refresh
			_model.selectedReportData = reportData;
		}
	}
}