package com.vidiun.edw.control.commands.thumb
{
	import com.vidiun.vmvc.control.VMvCEvent;
	import com.vidiun.commands.thumbAsset.ThumbAssetGet;
	import com.vidiun.events.VidiunEvent;
	import com.vidiun.edw.control.events.ThumbnailAssetEvent;
	import com.vidiun.edw.vo.ThumbnailWithDimensions;
	import com.vidiun.vo.VidiunThumbAsset;
	import com.vidiun.edw.control.commands.VedCommand;

	public class GetThumbAssetCommand extends VedCommand
	{
		private var _thumbnailAsset:ThumbnailWithDimensions;
		
		override public function execute(event:VMvCEvent):void
		{
			_thumbnailAsset = (event as ThumbnailAssetEvent).thumbnailAsset;
			var getThumbAsset:ThumbAssetGet = new ThumbAssetGet(_thumbnailAsset.thumbAsset.id);
			getThumbAsset.addEventListener(VidiunEvent.COMPLETE, result);
			getThumbAsset.addEventListener(VidiunEvent.FAILED, fault);
			
			_client.post(getThumbAsset);
		}
		
		override public function result(data:Object):void {
			_thumbnailAsset.thumbAsset = data.data as VidiunThumbAsset;
		}
	}
}