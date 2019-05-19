package com.vidiun.vmc.modules.analytics.commands
{
	import com.adobe.cairngorm.commands.ICommand;
	import com.adobe.cairngorm.control.CairngormEvent;
	import com.vidiun.vmc.modules.analytics.control.DrillDownEvent;
	import com.vidiun.vmc.modules.analytics.model.AnalyticsModelLocator;
	import com.vidiun.commands.baseEntry.BaseEntryGet;
	import com.vidiun.events.VidiunEvent;
	import com.vidiun.vo.VidiunBaseEntry;
	import com.vidiun.vo.VidiunMediaEntry;
	import com.vidiun.vo.VidiunMixEntry;
	
	import mx.rpc.IResponder;

	public class GetMediaEntryCommand implements ICommand, IResponder
	{
		private var _model : AnalyticsModelLocator = AnalyticsModelLocator.getInstance();
		public function execute(event:CairngormEvent):void
		{
			//get Entry
			_model.loadingFlag = true;
			_model.loadingEntryFlag = true;
			
			if(_model.reportDataMap[_model.currentScreenState].selectedMediaEntry)
				_model.reportDataMap[_model.currentScreenState].selectedMediaEntry = null;
				
			var baseEntryGet : BaseEntryGet = new BaseEntryGet( (event as DrillDownEvent).subjectId );
			baseEntryGet.addEventListener( VidiunEvent.COMPLETE , result );
			baseEntryGet.addEventListener( VidiunEvent.FAILED , fault );
			_model.vc.post( baseEntryGet );
		}
		
		public function result(result:Object):void
		{
			_model.loadingEntryFlag = false;
			_model.checkLoading();
			
			var vme : VidiunBaseEntry; 
			
			if( result.data is VidiunMediaEntry )
				 vme = (result.data as VidiunMediaEntry);
			else if( result.data is VidiunMixEntry )
				 vme = (result.data as VidiunMixEntry);
			else
				vme = result.data;

			_model.reportDataMap[_model.currentScreenState].selectedMediaEntry = vme;
			_model.selectedReportData = null; //refrash
			_model.selectedReportData = _model.reportDataMap[_model.currentScreenState];
		}
		
		public function fault(info:Object):void
		{
			//Test the drill down
			///////////////////////////////////////	
/* 			var vme : VidiunBaseEntry = new VidiunMediaEntry();
			vme.id = "00_e6cf46wd"; //TESTING!!!!!!
			_model.reportDataMap[_model.currentScreenState].selectedMediaEntry = vme; */
			///////////////////////////////////////	
			_model.loadingEntryFlag = false;
			_model.checkLoading();
		}
		
	}
}