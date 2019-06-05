package com.vidiun.edw.control.commands
{
	import com.vidiun.vmvc.control.VMvCEvent;
	import com.vidiun.commands.uploadToken.UploadTokenAdd;
	import com.vidiun.commands.uploadToken.UploadTokenUpload;
	import com.vidiun.events.VidiunEvent;
	import com.vidiun.edw.control.events.UploadTokenEvent;
	import com.vidiun.edw.vo.AssetVO;
	import com.vidiun.vo.VidiunUploadToken;
	
	import flash.net.FileReference;
	import com.vidiun.edw.control.commands.VedCommand;

	/**
	 * This class will start an upload using uploadToken service. will save the token
	 * on the given object 
	 * @author Michal
	 * 
	 */	
	public class UploadTokenCommand extends VedCommand
	{
		private var _fr:FileReference;
		private var _asset:AssetVO;
		
		override public function execute(event:VMvCEvent):void {
			_model.increaseLoadCounter();
			_fr = (event as UploadTokenEvent).fileReference
			_asset = (event as UploadTokenEvent).assetVo;
			
			var uploadToken:VidiunUploadToken = new VidiunUploadToken();
			var uploadTokenAdd:UploadTokenAdd = new UploadTokenAdd(uploadToken);
			
			uploadTokenAdd.addEventListener(VidiunEvent.COMPLETE, uploadTokenAddHandler);
			uploadTokenAdd.addEventListener(VidiunEvent.FAILED, fault);
			_client.post(uploadTokenAdd);
		}
		
		private function uploadTokenAddHandler(event:VidiunEvent):void {
			var result:VidiunUploadToken = event.data as VidiunUploadToken;
			if (result) {
				_asset.uploadTokenId = result.id;
				//_caption.downloadUrl = null;
				var uploadTokenUpload:UploadTokenUpload = new UploadTokenUpload(result.id, _fr);
				uploadTokenUpload.queued = false;
				uploadTokenUpload.useTimeout = false;
				uploadTokenUpload.addEventListener(VidiunEvent.FAILED, fault);
				
				_client.post(uploadTokenUpload);
			}
			_model.decreaseLoadCounter();
		}
	}
}