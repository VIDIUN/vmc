package com.vidiun.edw.control.commands
{
	import com.vidiun.commands.baseEntry.BaseEntryGet;
	import com.vidiun.edw.business.EntryUtil;
	import com.vidiun.edw.control.events.VedEntryEvent;
	import com.vidiun.edw.events.VedDataEvent;
	import com.vidiun.edw.model.datapacks.ContextDataPack;
	import com.vidiun.edw.model.datapacks.EntryDataPack;
	import com.vidiun.events.VidiunEvent;
	import com.vidiun.vmvc.control.VMvCEvent;
	import com.vidiun.vo.VidiunBaseEntry;

	public class SetSelectedEntryCommand extends VedCommand
	{
		private var _edp:EntryDataPack;
		
		override public function execute(event:VMvCEvent):void
		{	
			_edp = _model.getDataPack(EntryDataPack) as EntryDataPack;
			_edp.selectedIndex = (event as VedEntryEvent).entryIndex;
			if ((event as VedEntryEvent).reloadEntry) {
				_model.increaseLoadCounter();
				var getEntry:BaseEntryGet = new BaseEntryGet((event as VedEntryEvent).entryVo.id);
				
				getEntry.addEventListener(VidiunEvent.COMPLETE, result);
				getEntry.addEventListener(VidiunEvent.FAILED, fault);
				
				_client.post(getEntry);
			}

			_edp.selectedEntry = (event as VedEntryEvent).entryVo;	
		}
		
		override public function result(data:Object):void {
			super.result(data);
			
			if (data.data && data.data is VidiunBaseEntry) {
				// update values on the existing entry in the list
				var e:VedDataEvent = new VedDataEvent(VedDataEvent.ENTRY_UPDATED);
				e.data = data.data as VidiunBaseEntry; // send the updated entry as event data
				(_model.getDataPack(ContextDataPack) as ContextDataPack).dispatcher.dispatchEvent(e);
			}
			_model.decreaseLoadCounter();
		}
	}
}