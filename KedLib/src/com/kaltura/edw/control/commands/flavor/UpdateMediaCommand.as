package com.vidiun.edw.control.commands.flavor
{
	import com.vidiun.commands.media.MediaUpdateContent;
	import com.vidiun.edw.control.events.VedEntryEvent;
	import com.vidiun.edw.control.events.MediaEvent;
	import com.vidiun.edw.model.datapacks.EntryDataPack;
	import com.vidiun.events.VidiunEvent;
	import com.vidiun.vmvc.control.VMvCEvent;
	import com.vidiun.vo.VidiunBaseEntry;
	import com.vidiun.edw.control.commands.VedCommand;

	public class UpdateMediaCommand extends VedCommand {
		
		override public function execute(event:VMvCEvent):void {
			_model.increaseLoadCounter();
			_dispatcher = event.dispatcher;
			var e:MediaEvent = event as MediaEvent;
			// e.data here is {conversionProfileId, resource}
			var mu:MediaUpdateContent = new MediaUpdateContent(e.entry.id, e.data.resource, e.data.conversionProfileId);
			mu.addEventListener(VidiunEvent.COMPLETE, result);
			mu.addEventListener(VidiunEvent.FAILED, fault);
			_client.post(mu);
		}
		
		override public function result(data:Object):void {
			super.result(data);
			_model.decreaseLoadCounter();
			// to update the flavors tab, we re-load flavors data
			var selectedEntry:VidiunBaseEntry = (_model.getDataPack(EntryDataPack) as EntryDataPack).selectedEntry;
			if(selectedEntry != null) {
				var cgEvent : VedEntryEvent = new VedEntryEvent(VedEntryEvent.GET_FLAVOR_ASSETS, selectedEntry);
				_dispatcher.dispatch(cgEvent);
				cgEvent = new VedEntryEvent(VedEntryEvent.UPDATE_SELECTED_ENTRY_REPLACEMENT_STATUS, null,selectedEntry.id);
				_dispatcher.dispatch(cgEvent);
			}
		}
	}
}