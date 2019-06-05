package com.vidiun.edw.control.commands.thumb
{
	import com.vidiun.commands.thumbAsset.ThumbAssetGenerate;
	import com.vidiun.edw.control.commands.VedCommand;
	import com.vidiun.edw.control.events.GenerateThumbAssetEvent;
	import com.vidiun.edw.control.events.ThumbnailAssetEvent;
	import com.vidiun.edw.model.datapacks.DistributionDataPack;
	import com.vidiun.edw.model.datapacks.EntryDataPack;
	import com.vidiun.edw.vo.ThumbnailWithDimensions;
	import com.vidiun.events.VidiunEvent;
	import com.vidiun.vmvc.control.VMvCEvent;
	import com.vidiun.vo.VidiunThumbAsset;
	import com.vidiun.vo.VidiunThumbParams;
	
	import mx.controls.Alert;
	import mx.events.CloseEvent;
	import mx.resources.ResourceManager;
	
	public class GenerateThumbAssetCommand extends VedCommand
	{
		private var _thumbsArray:Array;
		
		private var _ddp:DistributionDataPack;
		
		override public function execute(event:VMvCEvent):void
		{
			_model.increaseLoadCounter();
			var generateThumbEvent:GenerateThumbAssetEvent = event as GenerateThumbAssetEvent;
			var generateThumbAsset:ThumbAssetGenerate = new ThumbAssetGenerate((_model.getDataPack(EntryDataPack) as EntryDataPack).selectedEntry.id, generateThumbEvent.thumbParams, generateThumbEvent.thumbSourceId);
			generateThumbAsset.addEventListener(VidiunEvent.COMPLETE, result);
			generateThumbAsset.addEventListener(VidiunEvent.FAILED, fault);
			
			_client.post(generateThumbAsset);
		}
		
		override public function result(data:Object):void {
			_model.decreaseLoadCounter();
			super.result(data);
			_ddp = _model.getDataPack(DistributionDataPack) as DistributionDataPack;
			var newThumb:VidiunThumbAsset =  data.data as VidiunThumbAsset;
			_thumbsArray = _ddp.distributionInfo.thumbnailDimensions;
			var curUsedProfiles:Array = new Array();
			var thumbExist:Boolean = false;
			for each (var thumb:ThumbnailWithDimensions in _thumbsArray) {
				if ((newThumb.width == thumb.width) && (newThumb.height == thumb.height)) {
					if (!thumb.thumbAsset) {
						thumb.thumbAsset = newThumb;
						thumb.thumbUrl = thumb.buildThumbUrl(_client);
						thumbExist = true;
						break;
					}
					curUsedProfiles = thumb.usedDistributionProfilesArray;
				}
			}
			if (!thumbExist) {
				var thumbToAdd:ThumbnailWithDimensions = new ThumbnailWithDimensions(newThumb.width, newThumb.height, newThumb);
				thumbToAdd.thumbUrl = thumbToAdd.buildThumbUrl(_client);
				thumbToAdd.usedDistributionProfilesArray = curUsedProfiles;
				//add last
				_thumbsArray.splice(_thumbsArray.length,0,thumbToAdd);
			}
			
			Alert.show(ResourceManager.getInstance().getString('cms','savedMessage'),ResourceManager.getInstance().getString('cms','savedTitle'), Alert.OK, null, onUserOK);
			
		}
		
		/**
		 * only after user approval for the new thumbnail alert, the model will reload the thumbs
		 * */
		private function onUserOK(event:CloseEvent):void {
			_ddp.distributionInfo.thumbnailDimensions = _thumbsArray.concat();
		}
		
	}
}