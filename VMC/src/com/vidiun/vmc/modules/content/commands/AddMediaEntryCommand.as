package com.vidiun.vmc.modules.content.commands
{
	import com.adobe.cairngorm.control.CairngormEvent;
	import com.vidiun.commands.media.MediaAdd;
	import com.vidiun.edw.control.events.MediaEvent;
	import com.vidiun.edw.model.datapacks.EntryDataPack;
	import com.vidiun.edw.model.types.WindowsStates;
	import com.vidiun.events.VidiunEvent;
	import com.vidiun.vmc.modules.content.events.EntriesEvent;
	import com.vidiun.vmc.modules.content.events.WindowEvent;
	import com.vidiun.net.VidiunCall;
	import com.vidiun.vo.VidiunMediaEntry;
	
	import mx.resources.ResourceManager;

	public class AddMediaEntryCommand extends VidiunCommand {
		//whether to open drilldown after media is created
//		private var _openDrilldown:Boolean;
		
		override public function execute(event:CairngormEvent):void 
		{
			_model.increaseLoadCounter();
			var mediaEvent:EntriesEvent = event as EntriesEvent;
//			_openDrilldown = mediaEvent.openDrilldown;
			var addMedia:MediaAdd = new MediaAdd(mediaEvent.data);

			addMedia.addEventListener(VidiunEvent.COMPLETE, result);
			addMedia.addEventListener(VidiunEvent.FAILED, fault);
			_model.context.vc.post(addMedia);
		}
		
		override public function result(data:Object):void {
			super.result(data);
			
			if (data.data && (data.data is VidiunMediaEntry)) {
				(_model.entryDetailsModel.getDataPack(EntryDataPack) as EntryDataPack).selectedEntry = data.data as VidiunMediaEntry;
//				if (_openDrilldown) {	
					var cgEvent:WindowEvent = new WindowEvent(WindowEvent.OPEN, WindowsStates.ENTRY_DETAILS_WINDOW_NEW_ENTRY);
					cgEvent.dispatch();
//				}
			}
			else {
				trace ("error in add media");
			}
			
			_model.decreaseLoadCounter();
		}
		
	}
}