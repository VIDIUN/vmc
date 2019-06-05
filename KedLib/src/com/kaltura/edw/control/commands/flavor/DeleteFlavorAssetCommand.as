package com.vidiun.edw.control.commands.flavor
{
	import com.vidiun.commands.flavorAsset.FlavorAssetDelete;
	import com.vidiun.edw.control.commands.VedCommand;
	import com.vidiun.edw.control.events.VedEntryEvent;
	import com.vidiun.events.VidiunEvent;
	import com.vidiun.vmvc.control.VMvCEvent;
	import com.vidiun.vo.VidiunBaseEntry;
	import com.vidiun.vo.VidiunFlavorAssetWithParams;
	
	import mx.controls.Alert;
	import mx.events.CloseEvent;
	import mx.resources.ResourceManager;
	
	public class DeleteFlavorAssetCommand extends VedCommand
	{
		private var fap:VidiunFlavorAssetWithParams;
		override public function execute(event:VMvCEvent):void
		{		
			_dispatcher = event.dispatcher;
			fap = event.data as VidiunFlavorAssetWithParams;
			Alert.show(ResourceManager.getInstance().getString('cms', 'deleteAssetMsg') + fap.flavorAsset.id + " ?", 
					   ResourceManager.getInstance().getString('cms', 'deleteAssetTitle'), Alert.YES | Alert.NO, null, handleUserResponse);
		
		}
		
		private function handleUserResponse(event:CloseEvent):void
		{
			if(event.detail == Alert.YES)
			{
				_model.increaseLoadCounter();
				var deleteCommand:FlavorAssetDelete = new FlavorAssetDelete(fap.flavorAsset.id);
	            deleteCommand.addEventListener(VidiunEvent.COMPLETE, result);
		        deleteCommand.addEventListener(VidiunEvent.FAILED, fault);
	    	    _client.post(deleteCommand); 
			}
		}
		
		override public function result(event:Object):void
		{
			super.result(event);
 			_model.decreaseLoadCounter();
 			Alert.show(ResourceManager.getInstance().getString('cms', 'assetDeletedMsg'), '', Alert.OK);
 			var entry:VidiunBaseEntry = new VidiunBaseEntry();
 			entry.id = fap.entryId;
 			var cgEvent : VedEntryEvent = new VedEntryEvent(VedEntryEvent.GET_FLAVOR_ASSETS, entry);
			_dispatcher.dispatch(cgEvent);
		}
	}
}