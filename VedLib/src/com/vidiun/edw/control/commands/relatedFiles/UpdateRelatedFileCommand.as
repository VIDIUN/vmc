package com.vidiun.edw.control.commands.relatedFiles
{
	import com.vidiun.commands.attachmentAsset.AttachmentAssetUpdate;
	import com.vidiun.edw.control.commands.VedCommand;
	import com.vidiun.edw.control.events.RelatedFileEvent;
	import com.vidiun.events.VidiunEvent;
	import com.vidiun.vmvc.control.VMvCEvent;
	import com.vidiun.vo.VidiunAttachmentAsset;
	
	public class UpdateRelatedFileCommand extends VedCommand
	{
		override public function execute(event:VMvCEvent):void {
			_model.increaseLoadCounter();
			var file:VidiunAttachmentAsset = (event as RelatedFileEvent).attachmentAsset;
			file.setUpdatedFieldsOnly(true);
			
			var updateAsset:AttachmentAssetUpdate = new AttachmentAssetUpdate(file.id, file);
			updateAsset.addEventListener(VidiunEvent.COMPLETE, result);
			updateAsset.addEventListener(VidiunEvent.FAILED, fault);
			
			_client.post(updateAsset);
		}
		
		override public function result(data:Object):void {
			super.result(data);
			
			_model.decreaseLoadCounter();
		}
	}
}