package com.vidiun.vmc.modules.content.vo
{
	import com.adobe.cairngorm.vo.IValueObject;
	import com.vidiun.vo.VidiunFlavorAsset;
	
	import mx.utils.ObjectProxy;
	
	public class FlavorAssetVO extends ObjectProxy implements IValueObject
	{
		public var asset:VidiunFlavorAsset;
		public function FlavorAssetVO()
		{
			asset = new VidiunFlavorAsset();
		}

	}
}