package com.vidiun.edw.control
{
	import com.vidiun.edw.control.commands.thumb.*;
	import com.vidiun.edw.control.events.GenerateThumbAssetEvent;
	import com.vidiun.edw.control.events.ThumbnailAssetEvent;
	import com.vidiun.edw.control.events.UploadFromImageThumbAssetEvent;
	import com.vidiun.vmvc.control.VMvCController;
	
	public class ThumbTabController extends VMvCController {
		
		public function ThumbTabController()
		{
			initializeCommands();
		}
		
		public function initializeCommands():void {
			addCommand(ThumbnailAssetEvent.LIST, ListThumbnailAssetCommand);
			addCommand(UploadFromImageThumbAssetEvent.ADD_FROM_IMAGE, AddFromImageThumbnailAssetCommand);
			addCommand(ThumbnailAssetEvent.DELETE, DeleteThumbnailAssetCommand);
			addCommand(ThumbnailAssetEvent.SET_AS_DEFAULT, SetAsDefaultThumbnailAsset);
			addCommand(GenerateThumbAssetEvent.GENERATE, GenerateThumbAssetCommand);
			
		}
	}
}