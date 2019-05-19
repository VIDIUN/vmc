package com.vidiun.edw.control.commands
{
	import com.vidiun.commands.liveStream.LiveStreamIsLive;
	import com.vidiun.edw.control.events.VedEntryEvent;
	import com.vidiun.edw.model.datapacks.EntryDataPack;
	import com.vidiun.events.VidiunEvent;
	import com.vidiun.vmvc.control.VMvCEvent;
	import com.vidiun.types.VidiunNullableBoolean;
	import com.vidiun.types.VidiunPlaybackProtocol;

	public class GetLivestreamStatusCommand extends VedCommand {
		
		override public function execute(event:VMvCEvent):void {
			if (event.type == VedEntryEvent.GET_LIVESTREAM_STATUS) {
				_model.increaseLoadCounter();
				var getStat:LiveStreamIsLive = new LiveStreamIsLive((event as VedEntryEvent).entryVo.id, VidiunPlaybackProtocol.HDS); 
				getStat.addEventListener(VidiunEvent.COMPLETE, result);
				getStat.addEventListener(VidiunEvent.FAILED, fault);
				_client.post(getStat);
			}
			else if (event.type == VedEntryEvent.RESET_LIVESTREAM_STATUS) {
				var edp:EntryDataPack = _model.getDataPack(EntryDataPack) as EntryDataPack;
				edp.selectedLiveEntryIsLive = VidiunNullableBoolean.NULL_VALUE;
			}
		}
		
		
		override public function result(data:Object):void {
			_model.decreaseLoadCounter();
			super.result(data); // look for server errors
			var edp:EntryDataPack = _model.getDataPack(EntryDataPack) as EntryDataPack;
			//data.data is "0" | "1"  
			edp.selectedLiveEntryIsLive = data.data;
		}
	}
}