package com.vidiun.edw.control.commands.relatedFiles
{
	import com.vidiun.commands.attachmentAsset.AttachmentAssetList;
	import com.vidiun.edw.control.commands.VedCommand;
	import com.vidiun.edw.model.datapacks.EntryDataPack;
	import com.vidiun.edw.model.datapacks.RelatedFilesDataPack;
	import com.vidiun.edw.vo.RelatedFileVO;
	import com.vidiun.events.VidiunEvent;
	import com.vidiun.vmvc.control.VMvCEvent;
	import com.vidiun.vo.VidiunAssetFilter;
	import com.vidiun.vo.VidiunAttachmentAsset;
	import com.vidiun.vo.VidiunAttachmentAssetListResponse;
	
	import mx.collections.ArrayCollection;

	public class ListRelatedFilesCommand extends VedCommand
	{
		override public function execute(event:VMvCEvent):void {
			_model.increaseLoadCounter();
			var filter:VidiunAssetFilter = new VidiunAssetFilter();
			filter.entryIdEqual = (_model.getDataPack(EntryDataPack) as EntryDataPack).selectedEntry.id;
			var list:AttachmentAssetList = new AttachmentAssetList(filter);
			list.addEventListener(VidiunEvent.COMPLETE, result);
			list.addEventListener(VidiunEvent.FAILED, fault);
			
			_client.post(list);
		}
		
		override public function result(data:Object):void {
			super.result(data);
			var listResult:VidiunAttachmentAssetListResponse = data.data as VidiunAttachmentAssetListResponse;
			if (listResult) {
				var relatedAC:ArrayCollection = new ArrayCollection();
				for each (var asset:VidiunAttachmentAsset in listResult.objects) {
					var relatedVo:RelatedFileVO = new RelatedFileVO();
					relatedVo.file = asset;
					relatedVo.serveUrl = _client.protocol + _client.domain + RelatedFileVO.serveURL + "/vs/" + _client.vs + "/attachmentAssetId/" + asset.id;
					relatedAC.addItem(relatedVo);
				}
				(_model.getDataPack(RelatedFilesDataPack) as RelatedFilesDataPack).relatedFilesAC = relatedAC;
			}
			
			_model.decreaseLoadCounter();
		}
	}
}