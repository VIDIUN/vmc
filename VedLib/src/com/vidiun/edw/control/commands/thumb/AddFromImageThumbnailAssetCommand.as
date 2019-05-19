package com.vidiun.edw.control.commands.thumb
{
	import com.vidiun.commands.thumbAsset.ThumbAssetAddFromImage;
	import com.vidiun.edw.control.commands.VedCommand;
	import com.vidiun.edw.control.events.UploadFromImageThumbAssetEvent;
	import com.vidiun.edw.model.datapacks.DistributionDataPack;
	import com.vidiun.edw.vo.ThumbnailWithDimensions;
	import com.vidiun.events.VidiunEvent;
	import com.vidiun.vmvc.control.VMvCEvent;
	import com.vidiun.vo.VidiunThumbAsset;

	public class AddFromImageThumbnailAssetCommand extends VedCommand
	{
		override public function execute(event:VMvCEvent):void
		{
			_model.increaseLoadCounter();
			var uploadEvent:UploadFromImageThumbAssetEvent = event as UploadFromImageThumbAssetEvent;
			var uploadFromImage:ThumbAssetAddFromImage = new ThumbAssetAddFromImage(uploadEvent.entryId, uploadEvent.thumbnailFileReference);
			uploadFromImage.addEventListener(VidiunEvent.COMPLETE, result);
			uploadFromImage.addEventListener(VidiunEvent.FAILED, fault);
			uploadFromImage.queued = false;
			_client.post(uploadFromImage);
		}
		
		override public function result(data:Object):void {
			_model.decreaseLoadCounter();
			super.result(data);
			insertToThumbsArray(data.data as VidiunThumbAsset);
		}
		
		
		private function insertToThumbsArray(thumbAsset:VidiunThumbAsset):void {
			var distDp:DistributionDataPack = _model.getDataPack(DistributionDataPack) as DistributionDataPack;
			var thumbsArray:Array = distDp.distributionInfo.thumbnailDimensions;
			var newThumb:ThumbnailWithDimensions = new ThumbnailWithDimensions(thumbAsset.width, thumbAsset.height, thumbAsset);
			newThumb.thumbUrl = newThumb.buildThumbUrl(_client);
			for each (var thumb:ThumbnailWithDimensions in thumbsArray) {
				if ((thumb.width==thumbAsset.width) && (thumb.height==thumbAsset.height)) {
					if (!thumb.thumbAsset) {
						thumb.thumbAsset = thumbAsset;
						thumb.thumbUrl = thumb.buildThumbUrl(_client)
						//no need to add a new thumbnailWithDimensions object in this case
						return;
					}
					else {
						//since they have the same dimensions: same distribution profiles use them
						newThumb.usedDistributionProfilesArray = thumb.usedDistributionProfilesArray.concat();
					}
					
					break;
				}
			}
			//add last
			thumbsArray.splice(thumbsArray.length, 0, newThumb); 
			//for data binding
			distDp.distributionInfo.thumbnailDimensions = thumbsArray.concat();	
		}
		
	}
}