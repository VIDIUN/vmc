package com.vidiun.edw.control.commands.flavor
{
	import com.vidiun.commands.flavorAsset.FlavorAssetSetContent;
	import com.vidiun.edw.control.events.VedEntryEvent;
	import com.vidiun.edw.control.events.MediaEvent;
	import com.vidiun.edw.model.datapacks.EntryDataPack;
	import com.vidiun.events.VidiunEvent;
	import com.vidiun.vmvc.control.VMvCEvent;
	import com.vidiun.vo.VidiunContentResource;
	import com.vidiun.edw.control.commands.VedCommand;
	
	public class UpdateFlavorCommand extends VedCommand {
		
		override public function execute(event:VMvCEvent):void
		{
			_dispatcher = event.dispatcher;
			_model.increaseLoadCounter();
			var e:MediaEvent = event as MediaEvent;
			var fau:FlavorAssetSetContent = new FlavorAssetSetContent(e.data.flavorAssetId, e.data.resource as VidiunContentResource);
			fau.addEventListener(VidiunEvent.COMPLETE, result);
			fau.addEventListener(VidiunEvent.FAILED, fault);
			_client.post(fau);
		}
		
		override public function result(data:Object):void
		{
			super.result(data);
			_model.decreaseLoadCounter();
			
			// to update the flavors tab, we re-load flavors data
			var edp:EntryDataPack = _model.getDataPack(EntryDataPack) as EntryDataPack;
			if(edp.selectedEntry != null) {
				var cgEvent : VedEntryEvent = new VedEntryEvent(VedEntryEvent.GET_FLAVOR_ASSETS, edp.selectedEntry);
				_dispatcher.dispatch(cgEvent);
			}
		}
	}
}