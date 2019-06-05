package com.vidiun.vmc.modules.content.commands
{
	import com.adobe.cairngorm.commands.ICommand;
	import com.adobe.cairngorm.control.CairngormEvent;
	import com.vidiun.vmc.modules.content.events.DownloadEvent;
	import com.vidiun.vmc.modules.content.model.CmsModelLocator;
	import com.vidiun.commands.*;
	import com.vidiun.commands.xInternal.XInternalXAddBulkDownload;
	import com.vidiun.events.VidiunEvent;
	
	import mx.controls.Alert;
	import mx.resources.ResourceManager;
	import mx.rpc.IResponder;

	public class AddDownloadCommand extends VidiunCommand
	{
		
		override public function execute(event:CairngormEvent):void
		{
			_model.increaseLoadCounter();
			var de:DownloadEvent = event as DownloadEvent;
			
		 	var addDownload:XInternalXAddBulkDownload = new XInternalXAddBulkDownload(de.entriesIds, de.flavorParamId);
		 	addDownload.addEventListener(VidiunEvent.COMPLETE, result);
			addDownload.addEventListener(VidiunEvent.FAILED, fault);
			_model.context.vc.post(addDownload);	   
		}
		
		override public function result(data:Object):void
		{
			super.result(data);
			_model.decreaseLoadCounter();												// partner's email
			Alert.show( ResourceManager.getInstance().getString('cms', 'entryDownloadAlert', [data.data]) );
		}
		
		override public function fault(event:Object):void
		{
			_model.decreaseLoadCounter();
			Alert.show( ResourceManager.getInstance().getString('cms', 'entryDownloadErrorAlert') );
		}
	}
}