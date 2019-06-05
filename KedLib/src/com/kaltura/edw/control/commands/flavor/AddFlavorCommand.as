package com.vidiun.edw.control.commands.flavor
{
	import com.vidiun.commands.flavorAsset.FlavorAssetAdd;
	import com.vidiun.commands.flavorAsset.FlavorAssetSetContent;
	import com.vidiun.edw.control.events.VedEntryEvent;
	import com.vidiun.edw.control.events.MediaEvent;
	import com.vidiun.edw.model.datapacks.EntryDataPack;
	import com.vidiun.events.VidiunEvent;
	import com.vidiun.vmvc.control.VMvCEvent;
	import com.vidiun.vo.VidiunContentResource;
	import com.vidiun.vo.VidiunFlavorAsset;
	import com.vidiun.edw.control.commands.VedCommand;
	
	public class AddFlavorCommand extends VedCommand {
		
		private var _resource:VidiunContentResource;
		
		override public function execute(event:VMvCEvent):void
		{
			_dispatcher = event.dispatcher;
			_model.increaseLoadCounter();
			var e:MediaEvent = event as MediaEvent;
			_resource = e.data.resource as VidiunContentResource;
			var flavorAsset:VidiunFlavorAsset = new VidiunFlavorAsset()
			flavorAsset.flavorParamsId = e.data.flavorParamsId;
			flavorAsset.setUpdatedFieldsOnly(true);
			flavorAsset.setInsertedFields(true);
			var fau:FlavorAssetAdd = new FlavorAssetAdd(e.entry.id, flavorAsset);
			fau.addEventListener(VidiunEvent.COMPLETE, setResourceContent);
			fau.addEventListener(VidiunEvent.FAILED, fault);
			_client.post(fau);
		}
		
		protected function setResourceContent(e:VidiunEvent):void {
			super.result(e);
			var fasc:FlavorAssetSetContent = new FlavorAssetSetContent(e.data.id, _resource);
			fasc.addEventListener(VidiunEvent.COMPLETE, result);
			fasc.addEventListener(VidiunEvent.FAILED, fault);
			_client.post(fasc);
		} 
		
		override public function result(data:Object):void {
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