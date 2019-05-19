package com.vidiun.edw.control.commands.relatedFiles
{
	import com.vidiun.commands.MultiRequest;
	import com.vidiun.commands.attachmentAsset.AttachmentAssetAdd;
	import com.vidiun.commands.attachmentAsset.AttachmentAssetDelete;
	import com.vidiun.commands.attachmentAsset.AttachmentAssetSetContent;
	import com.vidiun.commands.attachmentAsset.AttachmentAssetUpdate;
	import com.vidiun.edw.control.commands.VedCommand;
	import com.vidiun.edw.control.events.RelatedFileEvent;
	import com.vidiun.edw.model.datapacks.EntryDataPack;
	import com.vidiun.edw.vo.RelatedFileVO;
	import com.vidiun.events.VidiunEvent;
	import com.vidiun.vmvc.control.VMvCEvent;
	import com.vidiun.vo.VidiunUploadedFileTokenResource;
	
	public class SaveRelatedFilesCommand extends VedCommand
	{
		override public function execute(event:VMvCEvent):void {
			var evt:RelatedFileEvent = event as RelatedFileEvent;

			var mr:MultiRequest = new MultiRequest();
			var requestIndex:int = 1;
			//add assets
			if (evt.relatedToAdd) {
				for each (var relatedFile:RelatedFileVO in evt.relatedToAdd) {
					//add asset
					var addFile:AttachmentAssetAdd = new AttachmentAssetAdd((_model.getDataPack(EntryDataPack) as EntryDataPack).selectedEntry.id, relatedFile.file);
					mr.addAction(addFile);
					requestIndex++;
					//set its content
					var resource:VidiunUploadedFileTokenResource = new VidiunUploadedFileTokenResource();
					resource.token = relatedFile.uploadTokenId;
					var addContent:AttachmentAssetSetContent = new AttachmentAssetSetContent('0', resource);
					mr.mapMultiRequestParam(requestIndex-1, "id", requestIndex, "id");
					mr.addAction(addContent);
					requestIndex++;	
				}
			}
			//update assets
			if (evt.relatedToUpdate) {
				for each (var updateRelated:RelatedFileVO in evt.relatedToUpdate) {
					updateRelated.file.setUpdatedFieldsOnly(true);
					var updateAsset:AttachmentAssetUpdate = new AttachmentAssetUpdate(updateRelated.file.id, updateRelated.file);
					mr.addAction(updateAsset);
					requestIndex++;
				}
			}
			if (evt.relatedToDelete) {
				for each (var deleteRelated:RelatedFileVO in evt.relatedToDelete) {
					var deleteAsset:AttachmentAssetDelete = new AttachmentAssetDelete(deleteRelated.file.id);
					mr.addAction(deleteAsset);
					requestIndex++;
				}
			}
			
			if (requestIndex > 1) {
				_model.increaseLoadCounter();
				mr.addEventListener(VidiunEvent.COMPLETE, result);
				mr.addEventListener(VidiunEvent.FAILED, fault);
				
				_client.post(mr);
			}
		}
		
		override public function result(data:Object):void {
			super.result(data);
			_model.decreaseLoadCounter();
		}
	}
}