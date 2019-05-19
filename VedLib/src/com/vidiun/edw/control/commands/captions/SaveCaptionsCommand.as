package com.vidiun.edw.control.commands.captions
{
	import com.vidiun.commands.MultiRequest;
	import com.vidiun.commands.captionAsset.CaptionAssetAdd;
	import com.vidiun.commands.captionAsset.CaptionAssetDelete;
	import com.vidiun.commands.captionAsset.CaptionAssetSetAsDefault;
	import com.vidiun.commands.captionAsset.CaptionAssetSetContent;
	import com.vidiun.commands.captionAsset.CaptionAssetUpdate;
	import com.vidiun.edw.control.commands.VedCommand;
	import com.vidiun.edw.control.events.CaptionsEvent;
	import com.vidiun.edw.model.datapacks.EntryDataPack;
	import com.vidiun.edw.vo.EntryCaptionVO;
	import com.vidiun.events.VidiunEvent;
	import com.vidiun.vmvc.control.VMvCEvent;
	import com.vidiun.types.VidiunNullableBoolean;
	import com.vidiun.vo.VidiunContentResource;
	import com.vidiun.vo.VidiunUploadedFileTokenResource;
	import com.vidiun.vo.VidiunUrlResource;
	
	public class SaveCaptionsCommand extends VedCommand
	{
		override public function execute(event:VMvCEvent):void {
			var evt:CaptionsEvent = event as CaptionsEvent;	
			var mr:MultiRequest = new MultiRequest();
			var requestIndex:int = 1;
			//set as default
			if (evt.defaultCaption && evt.defaultCaption.caption.isDefault!=VidiunNullableBoolean.TRUE_VALUE) {
				var setDefault:CaptionAssetSetAsDefault = new CaptionAssetSetAsDefault(evt.defaultCaption.caption.id);
				mr.addAction(setDefault);
				requestIndex++;
			}
			if (evt.captionsToSave) {
				for each (var caption:EntryCaptionVO in evt.captionsToSave) {
					//handle resource
					var resource:VidiunContentResource; 
					if (caption.uploadTokenId) {
						resource = new VidiunUploadedFileTokenResource();
						resource.token = caption.uploadTokenId;
					}
					else if (caption.resourceUrl && (!caption.downloadUrl || (caption.resourceUrl!=caption.downloadUrl))) {
						resource = new VidiunUrlResource();
						resource.url = caption.resourceUrl;
					}
					//new caption
					if (!caption.caption.id) {		
						var addCaption:CaptionAssetAdd = new CaptionAssetAdd((_model.getDataPack(EntryDataPack) as EntryDataPack).selectedEntry.id, caption.caption);
						mr.addAction(addCaption);
						requestIndex++;
						if (resource) {
							var addContent:CaptionAssetSetContent = new CaptionAssetSetContent('0', resource);
							mr.mapMultiRequestParam(requestIndex-1, "id", requestIndex, "id");
							mr.addAction(addContent);
							requestIndex++;
						}
					}
						//update existing one
					else {
						caption.caption.setUpdatedFieldsOnly(true);
						var update:CaptionAssetUpdate = new CaptionAssetUpdate(caption.caption.id, caption.caption);
						mr.addAction(update);
						requestIndex++;
						if (resource) {
							var updateContent:CaptionAssetSetContent = new CaptionAssetSetContent(caption.caption.id, resource);
							mr.addAction(updateContent);
							requestIndex++;
						}
					}
				}
			}
			//delete captions
			if (evt.captionsToRemove) {
				for each (var delCap:EntryCaptionVO in evt.captionsToRemove) {
					var deleteAsset:CaptionAssetDelete = new CaptionAssetDelete(delCap.caption.id);
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