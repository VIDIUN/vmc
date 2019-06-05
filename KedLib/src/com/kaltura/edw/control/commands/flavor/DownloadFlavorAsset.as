package com.vidiun.edw.control.commands.flavor
{
	import com.vidiun.commands.flavorAsset.FlavorAssetGetUrl;
	import com.vidiun.edw.control.commands.VedCommand;
	import com.vidiun.events.VidiunEvent;
	import com.vidiun.vmvc.control.VMvCEvent;
	import com.vidiun.vo.VidiunFlavorAssetWithParams;
	
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	
	public class DownloadFlavorAsset extends VedCommand
	{
		override public function execute(event:VMvCEvent):void
		{		
		 	_model.increaseLoadCounter();
		 	var obj:VidiunFlavorAssetWithParams = event.data as VidiunFlavorAssetWithParams;
			var downloadCommand:FlavorAssetGetUrl = new FlavorAssetGetUrl(obj.flavorAsset.id);
            downloadCommand.addEventListener(VidiunEvent.COMPLETE, result);
	        downloadCommand.addEventListener(VidiunEvent.FAILED, fault);
    	    _client.post(downloadCommand);  
		}
		
		override public function result(event:Object):void
		{
			super.result(event);
 			_model.decreaseLoadCounter();
 			var downloadUrl:String = event.data;
			var urlRequest:URLRequest = new URLRequest(downloadUrl);
            navigateToURL(urlRequest, "downloadURL");
		}
	}
}
