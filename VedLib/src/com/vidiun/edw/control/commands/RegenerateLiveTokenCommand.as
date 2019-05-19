package com.vidiun.edw.control.commands {
	import com.vidiun.commands.liveStream.LiveStreamRegenerateStreamToken;
	import com.vidiun.edw.events.VedDataEvent;
	import com.vidiun.edw.model.datapacks.ContextDataPack;
	import com.vidiun.events.VidiunEvent;
	import com.vidiun.vmvc.control.VMvCEvent;

	[ResourceBundle("live")]
	
	public class RegenerateLiveTokenCommand extends VedCommand {

		override public function execute(event:VMvCEvent):void {
			var regenerate:LiveStreamRegenerateStreamToken = new LiveStreamRegenerateStreamToken(event.data);
			regenerate.addEventListener(VidiunEvent.COMPLETE, result);
			regenerate.addEventListener(VidiunEvent.FAILED, fault);
			_model.increaseLoadCounter();
			_client.post(regenerate);
		}


		override public function result(data:Object):void {
			super.result(data);
			// update the new entry on the model (so in view)
			var e:VedDataEvent = new VedDataEvent(VedDataEvent.ENTRY_UPDATED);
			e.data = data.data; // send the updated entry as event data
			(_model.getDataPack(ContextDataPack) as ContextDataPack).dispatcher.dispatchEvent(e);
			
			_model.decreaseLoadCounter();

		}
	}
}
