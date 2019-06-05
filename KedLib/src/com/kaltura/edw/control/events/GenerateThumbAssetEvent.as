package com.vidiun.edw.control.events
{
	import com.vidiun.vmvc.control.VMvCEvent;
	import com.vidiun.vo.VidiunThumbParams;

	public class GenerateThumbAssetEvent extends VMvCEvent
	{
		public static const GENERATE:String = "content_generateThumbAsset";
		public var thumbParams:VidiunThumbParams;
		public var thumbSourceId:String;
		
		public function GenerateThumbAssetEvent(type:String, thumbParams:VidiunThumbParams, thumbSourceId:String , bubbles:Boolean=false, cancelable:Boolean=false)
		{
			this.thumbParams = thumbParams;
			this.thumbSourceId = thumbSourceId;
			super(type, bubbles, cancelable);
		}
	}
}