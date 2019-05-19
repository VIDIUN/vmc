package com.vidiun.edw.control.commands {
	import com.vidiun.commands.baseEntry.BaseEntryUpdate;
	import com.vidiun.edw.control.events.VedEntryEvent;
	import com.vidiun.edw.events.VedDataEvent;
	import com.vidiun.edw.model.datapacks.ContextDataPack;
	import com.vidiun.events.VidiunEvent;
	import com.vidiun.vmvc.control.VMvCEvent;
	import com.vidiun.types.VidiunEntryStatus;
	import com.vidiun.vo.VidiunBaseEntry;
	import com.vidiun.vo.VidiunLiveStreamEntry;
	import com.vidiun.vo.VidiunStreamContainer;

	public class UpdateSingleEntry extends VedCommand {
		
		private var dummy: VidiunStreamContainer;
		
		private var _event:VedEntryEvent;

		override public function execute(event:VMvCEvent):void {
			_model.increaseLoadCounter();
			
			_event = event as VedEntryEvent;
			var entry:VidiunBaseEntry = _event.entryVo;

			entry.setUpdatedFieldsOnly(true);
			if (entry.status != VidiunEntryStatus.NO_CONTENT && !(entry is VidiunLiveStreamEntry)) {
				entry.conversionProfileId = int.MIN_VALUE;
			}
			// don't send categories - we use categoryEntry service to update them in EntryData panel
			entry.categories = null;
			entry.categoriesIds = null;
			// don't send msDuration, we never have any reason to update it.
			if (entry.msDuration && entry.msDuration != int.MIN_VALUE) {
				entry.msDuration = int.MIN_VALUE;
			}

			var mu:BaseEntryUpdate = new BaseEntryUpdate(entry.id, entry);
			// add listeners and post call
			mu.addEventListener(VidiunEvent.COMPLETE, result);
			mu.addEventListener(VidiunEvent.FAILED, fault);

			_client.post(mu);
		}


		override public function result(data:Object):void {
			super.result(data);
			_model.decreaseLoadCounter();
			
			if (checkErrors(data)) {
				return;
			}
			
			var e:VedDataEvent = new VedDataEvent(VedDataEvent.ENTRY_UPDATED);
			e.data = data.data; // send the updated entry as event data
			(_model.getDataPack(ContextDataPack) as ContextDataPack).dispatcher.dispatchEvent(e);

			// this will handle window closing or entry switching after successful save
			if (_event.onComplete != null) {
				_event.onComplete.call(_event.source);
			}
		}
	}
}