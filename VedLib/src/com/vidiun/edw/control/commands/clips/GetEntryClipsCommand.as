package com.vidiun.edw.control.commands.clips
{
	import com.vidiun.commands.baseEntry.BaseEntryList;
	import com.vidiun.edw.control.commands.VedCommand;
	import com.vidiun.edw.model.datapacks.ClipsDataPack;
	import com.vidiun.events.VidiunEvent;
	import com.vidiun.vmvc.control.VMvCEvent;
	import com.vidiun.vo.VidiunBaseEntryFilter;
	import com.vidiun.vo.VidiunBaseEntryListResponse;
	import com.vidiun.vo.VidiunMediaEntryFilter;
	
	public class GetEntryClipsCommand extends VedCommand {
		
		
		
		override public function execute(event:VMvCEvent):void {
			_model.increaseLoadCounter();
			var f:VidiunBaseEntryFilter = new VidiunMediaEntryFilter();
			f.rootEntryIdEqual = event.data.id;
			f.orderBy = event.data.orderBy;
			
			var list:BaseEntryList = new BaseEntryList(f, event.data.pager);
			list.addEventListener(VidiunEvent.COMPLETE, result);
			list.addEventListener(VidiunEvent.FAILED, fault);
			_client.post(list);
		}
		
		override public function result(data:Object):void {
			super.result(data);
			var res:Array = (data.data as VidiunBaseEntryListResponse).objects;
			if (res) {
				(_model.getDataPack(ClipsDataPack) as ClipsDataPack).clips = res;
			}
			else {
				// if the server returned nothing, use an empty array for the tab to remove itself.
				(_model.getDataPack(ClipsDataPack) as ClipsDataPack).clips = new Array();
			}
			_model.decreaseLoadCounter();
		}
	}
}