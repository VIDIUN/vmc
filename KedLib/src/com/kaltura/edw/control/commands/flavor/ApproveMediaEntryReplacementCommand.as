package com.vidiun.edw.control.commands.flavor
{
	import com.vidiun.commands.media.MediaApproveReplace;
	import com.vidiun.edw.business.EntryUtil;
	import com.vidiun.edw.control.events.MediaEvent;
	import com.vidiun.edw.events.VedDataEvent;
	import com.vidiun.edw.model.datapacks.ContextDataPack;
	import com.vidiun.edw.model.datapacks.EntryDataPack;
	import com.vidiun.events.VidiunEvent;
	import com.vidiun.vmvc.control.VMvCEvent;
	import com.vidiun.vo.VidiunBaseEntry;
	import com.vidiun.vo.VidiunMediaEntry;
	
	import flash.events.IEventDispatcher;
	import com.vidiun.edw.control.commands.VedCommand;

	public class ApproveMediaEntryReplacementCommand extends VedCommand
	{
		override public function execute(event:VMvCEvent):void {
			_model.increaseLoadCounter();
			var approveReplacement:MediaApproveReplace = new MediaApproveReplace((event as MediaEvent).entry.id);
			approveReplacement.addEventListener(VidiunEvent.COMPLETE, result);
			approveReplacement.addEventListener(VidiunEvent.FAILED, fault);
			
			_client.post(approveReplacement);
		}
		
		override public function result(data:Object):void {
			super.result(data);
			
			if (data.data && (data.data is VidiunMediaEntry)) {
				var entry:VidiunBaseEntry = (_model.getDataPack(EntryDataPack) as EntryDataPack).selectedEntry;
				EntryUtil.updateChangebleFieldsOnly(data.data as VidiunMediaEntry, entry);
				
				var dsp:IEventDispatcher = (_model.getDataPack(ContextDataPack) as ContextDataPack).dispatcher;
				var e:VedDataEvent = new VedDataEvent(VedDataEvent.ENTRY_RELOADED);
				e.data = entry; 
				dsp.dispatchEvent(e);
			}
			else {
				trace ("error in approve replacement");
			}
			
			_model.decreaseLoadCounter();
		}
	}
}