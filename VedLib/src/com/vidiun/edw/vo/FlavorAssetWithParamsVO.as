package com.vidiun.edw.vo
{
	import com.adobe.cairngorm.vo.IValueObject;
	import com.vidiun.vo.VidiunFlavorAssetWithParams;
	
	public class FlavorAssetWithParamsVO implements IValueObject
	{
		public var hasOriginal:Boolean = false;
		public var vidiunFlavorAssetWithParams:VidiunFlavorAssetWithParams;
		
		/**
		 * list of flavors (VidiunFlavorParams) that contribute to a multi bitrate flavor
		 */
		public var sources:Array;
		
		public function FlavorAssetWithParamsVO()
		{
		}

	}
}