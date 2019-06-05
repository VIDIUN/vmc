package com.vidiun.edw.control.commands.dist
{
	import com.vidiun.commands.entryDistribution.EntryDistributionSubmitUpdate;
	import com.vidiun.edw.control.commands.VedCommand;
	import com.vidiun.edw.control.events.EntryDistributionEvent;
	import com.vidiun.edw.model.datapacks.DistributionDataPack;
	import com.vidiun.events.VidiunEvent;
	import com.vidiun.vmvc.control.VMvCEvent;
	import com.vidiun.vo.VidiunEntryDistribution;

	public class SubmitUpdateEntryDistributionCommand extends VedCommand
	{
		private var _entryDis:VidiunEntryDistribution;
		
		override public function execute(event:VMvCEvent):void {
			_model.increaseLoadCounter();
			_entryDis = (event as EntryDistributionEvent).entryDistribution;
			var update:EntryDistributionSubmitUpdate = new EntryDistributionSubmitUpdate(_entryDis.id);
			update.addEventListener(VidiunEvent.COMPLETE, result);
			update.addEventListener(VidiunEvent.FAILED, fault);
			
			_client.post(update);
		}
		
		override public function result(data:Object):void {
			_model.decreaseLoadCounter();
			super.result(data);
			var updateResult:VidiunEntryDistribution = data.data as VidiunEntryDistribution;
			_entryDis.status = updateResult.status;
			_entryDis.dirtyStatus = updateResult.dirtyStatus;
			//for data binding
			var ddp:DistributionDataPack = _model.getDataPack(DistributionDataPack) as DistributionDataPack;
			ddp.distributionInfo.entryDistributions = ddp.distributionInfo.entryDistributions.concat();
		}
	}
}