package com.vidiun.edw.control.commands.dist
{
	import com.vidiun.commands.entryDistribution.EntryDistributionSubmitAdd;
	import com.vidiun.edw.control.commands.VedCommand;
	import com.vidiun.edw.control.events.EntryDistributionEvent;
	import com.vidiun.edw.model.datapacks.DistributionDataPack;
	import com.vidiun.events.VidiunEvent;
	import com.vidiun.vmvc.control.VMvCEvent;
	import com.vidiun.vo.VidiunEntryDistribution;


	public class SubmitEntryDistributionCommand extends VedCommand
	{
		private var _entryDis:VidiunEntryDistribution;
		
		override public function execute(event:VMvCEvent):void
		{
			_model.increaseLoadCounter();
			_entryDis = (event as EntryDistributionEvent).entryDistribution;
			var submit:EntryDistributionSubmitAdd = new EntryDistributionSubmitAdd(_entryDis.id);
			submit.addEventListener(VidiunEvent.COMPLETE, result);
			submit.addEventListener(VidiunEvent.FAILED, fault);
			
			_client.post(submit);
		}
		
		override public function result(data:Object):void 
		{
			_model.decreaseLoadCounter();
			super.result(data);
			var resultEntry:VidiunEntryDistribution = data.data as VidiunEntryDistribution;
			_entryDis.status =  resultEntry.status;
			_entryDis.dirtyStatus = resultEntry.dirtyStatus;
			//for data binding
			var ddp:DistributionDataPack = _model.getDataPack(DistributionDataPack) as DistributionDataPack;
			ddp.distributionInfo.entryDistributions = ddp.distributionInfo.entryDistributions.concat();
		}
	}
}