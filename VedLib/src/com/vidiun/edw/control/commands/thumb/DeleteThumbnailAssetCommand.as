package com.vidiun.edw.control.commands.thumb
{
	import com.vidiun.commands.thumbAsset.ThumbAssetDelete;
	import com.vidiun.edw.control.commands.VedCommand;
	import com.vidiun.edw.control.events.ThumbnailAssetEvent;
	import com.vidiun.edw.model.datapacks.DistributionDataPack;
	import com.vidiun.edw.vo.ThumbnailWithDimensions;
	import com.vidiun.events.VidiunEvent;
	import com.vidiun.vmvc.control.VMvCEvent;
	
	import mx.collections.ArrayCollection;

	public class DeleteThumbnailAssetCommand extends VedCommand
	{
		private var _thumbToRemove:ThumbnailWithDimensions;
		
		override public function execute(event:VMvCEvent):void
		{
			_model.increaseLoadCounter();
			_thumbToRemove = (event as ThumbnailAssetEvent).thumbnailAsset;
			var deleteThumb:ThumbAssetDelete = new ThumbAssetDelete(_thumbToRemove.thumbAsset.id);
			deleteThumb.addEventListener(VidiunEvent.COMPLETE, result);
			deleteThumb.addEventListener(VidiunEvent.FAILED, fault);
			_client.post(deleteThumb);
		}
		
		override public function result(data:Object):void {
			_model.decreaseLoadCounter();
			super.result(data);
			var ddp:DistributionDataPack = _model.getDataPack(DistributionDataPack) as DistributionDataPack;
			var thumbsArray:Array = ddp.distributionInfo.thumbnailDimensions;
			for (var i:int = 0; i<thumbsArray.length; i++) {
				var currentThumb:ThumbnailWithDimensions = thumbsArray[i] as ThumbnailWithDimensions;
				if (currentThumb==_thumbToRemove) {
					if (currentThumb.usedDistributionProfilesArray.length > 0) {
						currentThumb.thumbAsset = null;
						currentThumb.thumbUrl = "";
					}
					else 
						thumbsArray.splice(i, 1);
					
					ddp.distributionInfo.thumbnailDimensions = thumbsArray.concat();
					return;
				}
			}			
		}
	}
}