package com.vidiun.edw.control.commands.mix {
	import com.vidiun.commands.mixing.MixingGetReadyMediaEntries;
	import com.vidiun.edw.control.events.VedEntryEvent;
	import com.vidiun.edw.model.datapacks.ContentDataPack;
	import com.vidiun.edw.model.datapacks.EntryDataPack;
	import com.vidiun.events.VidiunEvent;
	import com.vidiun.vmvc.control.VMvCEvent;
	import com.vidiun.vo.VidiunBaseEntry;
	
	import mx.collections.ArrayCollection;
	import com.vidiun.edw.control.commands.VedCommand;

	public class GetAllEntriesCommand extends VedCommand {
		override public function execute(event:VMvCEvent):void {
			_model.increaseLoadCounter();
			var cdp:ContentDataPack = _model.getDataPack(ContentDataPack) as ContentDataPack;
			cdp.contentParts = null;
			
			var e:VedEntryEvent = event as VedEntryEvent;
			var getMediaReadyMix:MixingGetReadyMediaEntries = new MixingGetReadyMediaEntries(e.entryVo.id);

			getMediaReadyMix.addEventListener(VidiunEvent.COMPLETE, result);
			getMediaReadyMix.addEventListener(VidiunEvent.FAILED, fault);

			_client.post(getMediaReadyMix);
		}


		override public function result(data:Object):void {
			super.result(data);
			_model.decreaseLoadCounter();
			if (data.data && data.data is Array) {
				var cdp:ContentDataPack = _model.getDataPack(ContentDataPack) as ContentDataPack;
				cdp.contentParts = data.data;
			}
			else
				trace("Error getting the list of roughcut entries");
		}
	}
}