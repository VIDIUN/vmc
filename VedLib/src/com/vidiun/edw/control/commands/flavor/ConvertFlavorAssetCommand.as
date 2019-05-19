package com.vidiun.edw.control.commands.flavor
{
	import com.vidiun.commands.flavorAsset.FlavorAssetConvert;
	import com.vidiun.edw.control.commands.VedCommand;
	import com.vidiun.edw.control.events.VedEntryEvent;
	import com.vidiun.events.VidiunEvent;
	import com.vidiun.vmvc.control.VMvCEvent;
	import com.vidiun.vo.VidiunBaseEntry;
	import com.vidiun.vo.VidiunFlavorAssetWithParams;
	
	public class ConvertFlavorAssetCommand extends VedCommand
	{
		private var selectedEntryId:String;
		override public function execute(event:VMvCEvent):void
		{	
			_dispatcher = event.dispatcher;
			_model.increaseLoadCounter();
			var obj:VidiunFlavorAssetWithParams = event.data as VidiunFlavorAssetWithParams;
			selectedEntryId = obj.entryId;
			var convertCommand:FlavorAssetConvert = new FlavorAssetConvert(selectedEntryId, obj.flavorParams.id);
            convertCommand.addEventListener(VidiunEvent.COMPLETE, result);
	        convertCommand.addEventListener(VidiunEvent.FAILED, fault);
    	    _client.post(convertCommand);
		}
		
		override public function result(event:Object):void
		{
			super.result(event);
 			_model.decreaseLoadCounter();
 			var entry:VidiunBaseEntry = new VidiunBaseEntry();
 			entry.id = selectedEntryId;
 			var cgEvent : VedEntryEvent = new VedEntryEvent(VedEntryEvent.GET_FLAVOR_ASSETS, entry);
			_dispatcher.dispatch(cgEvent);
		}
	}
}