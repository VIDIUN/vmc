package com.vidiun.vmc.modules.analytics.commands
{
	import com.adobe.cairngorm.commands.ICommand;
	import com.adobe.cairngorm.control.CairngormEvent;
	import com.vidiun.vmc.modules.analytics.model.AnalyticsModelLocator;
	import com.vidiun.vmc.modules.analytics.vo.AccountUsageVO;
	import com.vidiun.commands.partner.PartnerGetUsage;
	import com.vidiun.events.VidiunEvent;
	import com.vidiun.vo.VidiunPartnerUsage;
	
	import mx.rpc.IResponder;
	
	public class GetUsageGraphCommand implements ICommand, IResponder
	{
		private var _model : AnalyticsModelLocator = AnalyticsModelLocator.getInstance();
		
		public function execute(event:CairngormEvent):void
		{
			new VidiunPartnerUsage();
			var params:Object = event.data;
			var getPartnerUsage:PartnerGetUsage = new PartnerGetUsage(params.year, params.month, params.resolution);
			getPartnerUsage.addEventListener(VidiunEvent.COMPLETE, result);
			getPartnerUsage.addEventListener(VidiunEvent.FAILED, fault);
			_model.vc.post(getPartnerUsage);	
		}
		
		public function result(data:Object):void
		{
			var usageData:AccountUsageVO = new AccountUsageVO();
			usageData.hostingGB = data.data.hostingGB;
			usageData.totalBWSoFar = data.data.usageGB;
			usageData.totalPercentSoFar = data.data.Percent;
			usageData.usageSeries = data.data.usageGraph;
			usageData.packageBW = data.data.packageBW;
			
			_model.usageData = usageData;
		}
		
		public function fault(info:Object):void
		{
			
		}
	}
}