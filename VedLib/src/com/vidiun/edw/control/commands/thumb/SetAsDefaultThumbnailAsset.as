package com.vidiun.edw.control.commands.thumb
{
	import com.vidiun.commands.MultiRequest;
	import com.vidiun.commands.thumbAsset.ThumbAssetGetByEntryId;
	import com.vidiun.commands.thumbAsset.ThumbAssetSetAsDefault;
	import com.vidiun.edw.control.commands.VedCommand;
	import com.vidiun.edw.control.events.ThumbnailAssetEvent;
	import com.vidiun.edw.model.datapacks.DistributionDataPack;
	import com.vidiun.edw.model.datapacks.EntryDataPack;
	import com.vidiun.edw.vo.ThumbnailWithDimensions;
	import com.vidiun.events.VidiunEvent;
	import com.vidiun.vmvc.control.VMvCEvent;
	import com.vidiun.vo.VidiunThumbAsset;

	public class SetAsDefaultThumbnailAsset extends VedCommand
	{
		private var _defaultThumb:ThumbnailWithDimensions;
		
		override public function execute(event:VMvCEvent):void
		{
			_model.increaseLoadCounter();
			_defaultThumb = (event as ThumbnailAssetEvent).thumbnailAsset;
			var multiRequest:MultiRequest = new MultiRequest();
			var setDefault:ThumbAssetSetAsDefault = new ThumbAssetSetAsDefault(_defaultThumb.thumbAsset.id);
			multiRequest.addAction(setDefault);
			var listThumbs:ThumbAssetGetByEntryId = new ThumbAssetGetByEntryId((_model.getDataPack(EntryDataPack) as EntryDataPack).selectedEntry.id);
			multiRequest.addAction(listThumbs);
			
			multiRequest.addEventListener(VidiunEvent.COMPLETE, result);
			multiRequest.addEventListener(VidiunEvent.FAILED, fault);
			
			_client.post(multiRequest);
		}
		
		override public function result(data:Object):void {
			_model.decreaseLoadCounter();
			var resultArray:Array = data.data as Array;
			updateThumbnailsState(resultArray[1] as Array);
		}
		
		/**
		 * update our saved array with the updated array arrived from the server 
		 * @param thumbsArray the updated array
		 * 
		 */		
		private function updateThumbnailsState(thumbsArray:Array):void {
			var ddp:DistributionDataPack = _model.getDataPack(DistributionDataPack) as DistributionDataPack;
			var currentThumbsArray:Array = ddp.distributionInfo.thumbnailDimensions;
			for (var i:int=0; i<thumbsArray.length; i++) {
				var thumbAsset:VidiunThumbAsset = thumbsArray[i] as VidiunThumbAsset;
				for (var j:int=0; j<currentThumbsArray.length; j++) {
					var thumbWithDimensions:ThumbnailWithDimensions = currentThumbsArray[j] as ThumbnailWithDimensions;
					if (thumbWithDimensions.thumbAsset && (thumbWithDimensions.thumbAsset.id == thumbAsset.id)) {
						thumbWithDimensions.thumbAsset = thumbAsset;
						break;
					}
				}
			}
			
			//for data binding
			ddp.distributionInfo.thumbnailDimensions = currentThumbsArray.concat();
		}
	}
}