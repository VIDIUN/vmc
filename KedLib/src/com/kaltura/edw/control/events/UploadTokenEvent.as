package com.vidiun.edw.control.events
{
	import com.vidiun.edw.vo.AssetVO;
	import com.vidiun.vmvc.control.VMvCEvent;
	
	import flash.net.FileReference;
	
	public class UploadTokenEvent extends VMvCEvent
	{
		public static const UPLOAD_TOKEN:String = "uploadToken";
		
		public var fileReference:FileReference;
		public var assetVo:AssetVO;
		
		public function UploadTokenEvent(type:String, file_reference:FileReference, asset_vo:AssetVO, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			fileReference = file_reference;
			assetVo = asset_vo;
			super(type, bubbles, cancelable);
		}
	}
}