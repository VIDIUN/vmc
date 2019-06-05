package com.vidiun.edw.control.commands.dist
{
	import com.vidiun.edw.control.commands.VedCommand;
	import com.vidiun.edw.control.events.EntryDistributionEvent;
	import com.vidiun.vmvc.control.VMvCEvent;
	import com.vidiun.vo.VidiunEntryDistribution;
	
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	
	public class GetSentDataEntryDistributionCommand extends VedCommand
	{
		override public function execute(event:VMvCEvent):void {
			var entryDis:VidiunEntryDistribution = (event as EntryDistributionEvent).entryDistribution;
			var stringURL:String = _client.protocol + _client.domain + '/api_v3/index.php/service/contentDistribution_entryDistribution/action/serveSentData/actionType/1/id/' +
				entryDis.id + '/vs/' + _client.vs;
			var urlRequest:URLRequest = new URLRequest(stringURL);
			navigateToURL(urlRequest , '_self');
		}
	}
}