package com.vidiun.edw.control.commands.dist
{
	import com.vidiun.commands.entryDistribution.EntryDistributionRetrySubmit;
	import com.vidiun.edw.control.commands.VedCommand;
	import com.vidiun.edw.control.events.EntryDistributionEvent;
	import com.vidiun.edw.model.datapacks.DistributionDataPack;
	import com.vidiun.events.VidiunEvent;
	import com.vidiun.vmvc.control.VMvCEvent;
	import com.vidiun.vo.VidiunEntryDistribution;

	public class RetryEntryDistributionCommand extends VedCommand
	{
		private var _entryDis:VidiunEntryDistribution;
		
		override public function execute(event:VMvCEvent):void {
			_model.increaseLoadCounter();
			_entryDis = (event as EntryDistributionEvent).entryDistribution;
			var retry:EntryDistributionRetrySubmit = new EntryDistributionRetrySubmit(_entryDis.id);
			retry.addEventListener(VidiunEvent.COMPLETE, result);
			retry.addEventListener(VidiunEvent.FAILED, fault);
			
			_client.post(retry);
		}
		
		override public function result(data:Object):void {
			_model.decreaseLoadCounter();
			super.result(data);
			var updateResult:VidiunEntryDistribution = data.data as VidiunEntryDistribution;
			_entryDis.status = updateResult.status;

			//for data binding
			
			var ddp:DistributionDataPack = _model.getDataPack(DistributionDataPack) as DistributionDataPack;
			ddp.distributionInfo.entryDistributions = ddp.distributionInfo.entryDistributions.concat();
		}
	}
}