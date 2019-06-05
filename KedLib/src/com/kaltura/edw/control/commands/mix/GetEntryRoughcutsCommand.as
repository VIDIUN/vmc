package com.vidiun.edw.control.commands.mix
{
	import com.vidiun.commands.mixing.MixingGetMixesByMediaId;
	import com.vidiun.edw.control.events.VedEntryEvent;
	import com.vidiun.edw.model.datapacks.ContentDataPack;
	import com.vidiun.events.VidiunEvent;
	import com.vidiun.vmvc.control.VMvCEvent;
	import com.vidiun.edw.control.commands.VedCommand;

	public class GetEntryRoughcutsCommand extends VedCommand 
	{
		override public function execute(event:VMvCEvent):void
		{
			_model.increaseLoadCounter();		
			var cdp:ContentDataPack = _model.getDataPack(ContentDataPack) as ContentDataPack;
			cdp.contentParts = null;
			
			var e : VedEntryEvent = event as VedEntryEvent;
			var getMixUsingEntry:MixingGetMixesByMediaId = new MixingGetMixesByMediaId(e.entryVo.id);
			
			getMixUsingEntry.addEventListener(VidiunEvent.COMPLETE, result);
			getMixUsingEntry.addEventListener(VidiunEvent.FAILED, fault);
			
			_client.post(getMixUsingEntry);
		}
		
		override public function result(data:Object):void
		{
			super.result(data);
			_model.decreaseLoadCounter();
			
			if(data.data && data.data is Array) {
				var cdp:ContentDataPack = _model.getDataPack(ContentDataPack) as ContentDataPack;
				cdp.contentParts = data.data;
			}
			else
				trace("Error getting the list of roughcut entries");
		}
	}
}