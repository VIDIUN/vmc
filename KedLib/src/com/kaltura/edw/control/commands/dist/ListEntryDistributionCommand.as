package com.vidiun.edw.control.commands.dist
{
	import com.vidiun.commands.entryDistribution.EntryDistributionList;
	import com.vidiun.edw.control.commands.VedCommand;
	import com.vidiun.edw.model.EntryDistributionWithProfile;
	import com.vidiun.edw.model.datapacks.DistributionDataPack;
	import com.vidiun.edw.model.datapacks.EntryDataPack;
	import com.vidiun.events.VidiunEvent;
	import com.vidiun.vmvc.control.VMvCEvent;
	import com.vidiun.types.VidiunEntryDistributionStatus;
	import com.vidiun.vo.VidiunDistributionProfile;
	import com.vidiun.vo.VidiunEntryDistribution;
	import com.vidiun.vo.VidiunEntryDistributionFilter;
	import com.vidiun.vo.VidiunEntryDistributionListResponse;
	
	public class ListEntryDistributionCommand extends VedCommand
	{
		override public function execute(event:VMvCEvent):void
		{
			_model.increaseLoadCounter();
			var entryDistributionFilter:VidiunEntryDistributionFilter = new VidiunEntryDistributionFilter();
			entryDistributionFilter.entryIdEqual = (_model.getDataPack(EntryDataPack) as EntryDataPack).selectedEntry.id;	
			var listEntryDistribution:EntryDistributionList = new EntryDistributionList(entryDistributionFilter);
			listEntryDistribution.addEventListener(VidiunEvent.COMPLETE, result);
			listEntryDistribution.addEventListener(VidiunEvent.FAILED, fault);
			_client.post(listEntryDistribution);

		}
		
		override public function result(data:Object):void
		{
			_model.decreaseLoadCounter();	
			super.result(data);

			var result:VidiunEntryDistributionListResponse = data.data as VidiunEntryDistributionListResponse;
			handleEntryDistributionResult(result);	
		}
		
		public function handleEntryDistributionResult(result:VidiunEntryDistributionListResponse):void 
		{
			var ddp:DistributionDataPack = _model.getDataPack(DistributionDataPack) as DistributionDataPack;
			var distributionArray:Array = [];
			var profilesArray:Array = ddp.distributionInfo.distributionProfiles;
			for each (var distribution:VidiunEntryDistribution in result.objects) {
				if (distribution.status != VidiunEntryDistributionStatus.DELETED) {
					for each (var profile:VidiunDistributionProfile in profilesArray) {
						if (distribution.distributionProfileId == profile.id) {
							var newEntryDistribution:EntryDistributionWithProfile = new EntryDistributionWithProfile();
							newEntryDistribution.vidiunDistributionProfile = profile;
							newEntryDistribution.vidiunEntryDistribution = distribution;
							distributionArray.push(newEntryDistribution);
						} 
					}
				}
			}
			
			ddp.distributionInfo.entryDistributions = distributionArray;
		}
	}
}