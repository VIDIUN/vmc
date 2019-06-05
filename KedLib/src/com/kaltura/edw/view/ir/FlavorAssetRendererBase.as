package com.vidiun.edw.view.ir
{
	import com.vidiun.edw.vo.FlavorAssetWithParamsVO;
	import com.vidiun.managers.FileUploadManager;
	import com.vidiun.vo.FileUploadVO;
	import com.vidiun.vo.VidiunFlavorAssetWithParams;
	
	import mx.containers.HBox;
	import mx.events.FlexEvent;

	public class FlavorAssetRendererBase extends HBox
	{
		public function FlavorAssetRendererBase()
		{
			super();
			addEventListener(FlexEvent.CREATION_COMPLETE, onCreatoinComplete);
		}
		
		protected function onCreatoinComplete(e:FlexEvent):void
		{
			/* var obj:FlavorAssetWithParamsVO = data as FlavorAssetWithParamsVO;
			var bgColor:String = (obj.vidiunFlavorAssetWithParams.flavorAsset != null) ? '#FFFFFF' : '#DED2D2';
			
			this.setStyle("backgroundColor", bgColor); */
			
			horizontalScrollPolicy = "off";
			verticalScrollPolicy = "off";
		}	
				
	}
}