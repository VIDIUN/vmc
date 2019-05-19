package com.vidiun.edw.control.commands.mix
{
	import com.vidiun.edw.control.commands.VedCommand;
	import com.vidiun.edw.model.datapacks.ContentDataPack;
	import com.vidiun.vmvc.control.VMvCEvent;
	
	public class ResetContentPartsCommand extends VedCommand {
		
		override public function execute(event:VMvCEvent):void
		{
//			_model.increaseLoadCounter();		
			var cdp:ContentDataPack = _model.getDataPack(ContentDataPack) as ContentDataPack;
			cdp.contentParts = null;
//			
//			var e : VedEntryEvent = event as VedEntryEvent;
//			var getMixUsingEntry:MixingGetMixesByMediaId = new MixingGetMixesByMediaId(e.entryVo.id);
//			
//			getMixUsingEntry.addEventListener(VidiunEvent.COMPLETE, result);
//			getMixUsingEntry.addEventListener(VidiunEvent.FAILED, fault);
//			
//			_client.post(getMixUsingEntry);
		}
	}
}