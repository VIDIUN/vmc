package com.vidiun.edw.control.commands.dist
{
	import com.vidiun.commands.MultiRequest;
	import com.vidiun.commands.entryDistribution.EntryDistributionAdd;
	import com.vidiun.commands.entryDistribution.EntryDistributionDelete;
	import com.vidiun.commands.entryDistribution.EntryDistributionList;
	import com.vidiun.commands.entryDistribution.EntryDistributionSubmitAdd;
	import com.vidiun.commands.entryDistribution.EntryDistributionSubmitDelete;
	import com.vidiun.edw.control.commands.VedCommand;
	import com.vidiun.edw.control.events.EntryDistributionEvent;
	import com.vidiun.edw.model.EntryDistributionWithProfile;
	import com.vidiun.edw.model.datapacks.EntryDataPack;
	import com.vidiun.events.VidiunEvent;
	import com.vidiun.vmvc.control.VMvCEvent;
	import com.vidiun.types.VidiunEntryDistributionStatus;
	import com.vidiun.vo.VidiunEntryDistribution;
	import com.vidiun.vo.VidiunEntryDistributionFilter;
	import com.vidiun.vo.VidiunEntryDistributionListResponse;

	public class UpdateEntryDistributionsCommand extends VedCommand
	{
		override public function execute(event:VMvCEvent):void 
		{
			var entryDistributionEvent:EntryDistributionEvent = event as EntryDistributionEvent;
			var distributionsToAdd:Array = entryDistributionEvent.distributionsWithProfilesToAddArray;
			var distributionsToRemove:Array = entryDistributionEvent.distributionsToRemoveArray;
			if (distributionsToAdd.length == 0 && distributionsToRemove.length == 0)
				return;
			
			_model.increaseLoadCounter();
			var mr:MultiRequest = new MultiRequest();
			//all entry distributions to add
			var requestsIndex:int = 1;
			for each (var distribution:EntryDistributionWithProfile in distributionsToAdd) {
				//first delete old leftovers, create new entryDistribution if needed
				var addEntryDistribution:EntryDistributionAdd;
				if (distribution.vidiunEntryDistribution.status== VidiunEntryDistributionStatus.REMOVED) {
					var deleteEntryDistribution:EntryDistributionDelete = new EntryDistributionDelete(distribution.vidiunEntryDistribution.id);
					mr.addAction(deleteEntryDistribution);
					var newEntryDistribution:VidiunEntryDistribution = new VidiunEntryDistribution();
					newEntryDistribution.entryId = distribution.vidiunEntryDistribution.entryId;
					newEntryDistribution.distributionProfileId = distribution.vidiunEntryDistribution.distributionProfileId;
					addEntryDistribution = new EntryDistributionAdd(newEntryDistribution);
				}
				else {
					addEntryDistribution = new EntryDistributionAdd(distribution.vidiunEntryDistribution);
				}
				mr.addAction(addEntryDistribution);
				
				//if submitAdd action is required
				if (!distribution.manualQualityControl) {
					requestsIndex++;
					var submitEntry:EntryDistributionSubmitAdd = new EntryDistributionSubmitAdd(0, true);
					mr.addAction(submitEntry);
//					mr.addRequestParam(requestsIndex + ":id","{" + (requestsIndex-1) + ":result:id}");
					mr.mapMultiRequestParam(requestsIndex-1, "id", requestsIndex, "id");
				}
				requestsIndex++;
			}
			
			//all entry distributions to delete
			for each (var removeDistribution:VidiunEntryDistribution in distributionsToRemove) {
				//remove from destination
				if (removeDistribution.status == VidiunEntryDistributionStatus.READY ||
					removeDistribution.status == VidiunEntryDistributionStatus.ERROR_UPDATING) {
					var removeSubmitEntryDistribution:EntryDistributionSubmitDelete = new EntryDistributionSubmitDelete(removeDistribution.id);
					mr.addAction(removeSubmitEntryDistribution);	
				}
				//if entry wasn't submitted yet, delete it
				else if (removeDistribution.status == VidiunEntryDistributionStatus.QUEUED ||
						 removeDistribution.status == VidiunEntryDistributionStatus.PENDING ||
						 removeDistribution.status == VidiunEntryDistributionStatus.ERROR_SUBMITTING)
				{
					var deleteDistribution:EntryDistributionDelete = new EntryDistributionDelete(removeDistribution.id);
					mr.addAction(deleteDistribution);
				}
			}
			//get the new entry distributions list
			var entryDistributionFilter:VidiunEntryDistributionFilter = new VidiunEntryDistributionFilter();
			var edp:EntryDataPack = _model.getDataPack(EntryDataPack) as EntryDataPack;
			entryDistributionFilter.entryIdEqual = edp.selectedEntry.id;	
			var listDistributions:EntryDistributionList = new EntryDistributionList(entryDistributionFilter);
			mr.addAction(listDistributions);
			
			mr.addEventListener(VidiunEvent.COMPLETE, result);
			mr.addEventListener(VidiunEvent.FAILED, fault);
			_client.post(mr);
		}
		
		override public function result(data:Object):void
		{
			_model.decreaseLoadCounter();
			super.result(data);
			var resultArray:Array = data.data as Array;
			var listDistributionsCommand:ListEntryDistributionCommand = new ListEntryDistributionCommand();
			listDistributionsCommand.handleEntryDistributionResult(resultArray[resultArray.length - 1] as VidiunEntryDistributionListResponse);
		}
	}
}