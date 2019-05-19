package com.vidiun.edw.control.commands
{
	import com.vidiun.commands.baseEntry.BaseEntryList;
	import com.vidiun.edw.control.events.VedEntryEvent;
	import com.vidiun.edw.model.datapacks.EntryDataPack;
	import com.vidiun.events.VidiunEvent;
	import com.vidiun.vmvc.control.VMvCEvent;
	import com.vidiun.vo.VidiunBaseEntryFilter;
	import com.vidiun.vo.VidiunBaseEntryListResponse;

	public class ListEntriesByRefidCommand extends VedCommand {
		
		/**
		 * @inheritDoc
		 */		
		override public function execute(event:VMvCEvent):void
		{
			_model.increaseLoadCounter();
			var f:VidiunBaseEntryFilter = new VidiunBaseEntryFilter();
			f.referenceIdEqual = (event as VedEntryEvent).entryVo.referenceId;
			var getMediaList:BaseEntryList = new BaseEntryList(f);
			getMediaList.addEventListener(VidiunEvent.COMPLETE, result);
			getMediaList.addEventListener(VidiunEvent.FAILED, fault);
			_client.post(getMediaList);	  
		}
		
		/**
		 * @inheritDoc
		 */
		override public function result(data:Object):void
		{
			super.result(data);
			var recievedData:VidiunBaseEntryListResponse = VidiunBaseEntryListResponse(data.data);
			var edp:EntryDataPack = _model.getDataPack(EntryDataPack) as EntryDataPack;
			edp.entriesWSameRefidAsSelected = recievedData.objects;
			_model.decreaseLoadCounter();
		}
	}
}