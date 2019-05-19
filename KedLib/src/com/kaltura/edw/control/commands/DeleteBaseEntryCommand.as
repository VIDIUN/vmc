package com.vidiun.edw.control.commands
{
	import com.vidiun.commands.baseEntry.BaseEntryDelete;
	import com.vidiun.edw.control.events.VedEntryEvent;
	import com.vidiun.events.VidiunEvent;
	import com.vidiun.vmvc.control.VMvCEvent;

	public class DeleteBaseEntryCommand extends VedCommand
	{
		override public function execute(event:VMvCEvent):void {
			_model.increaseLoadCounter();
			var deleteEntry:BaseEntryDelete = new BaseEntryDelete((event as VedEntryEvent).entryId);
			deleteEntry.addEventListener(VidiunEvent.COMPLETE, result);
			deleteEntry.addEventListener(VidiunEvent.FAILED, fault);
			
			_client.post(deleteEntry);
		}
		
		override public function result(data:Object):void {
			_model.decreaseLoadCounter();
		}
	}
}