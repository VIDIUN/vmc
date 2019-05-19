package com.vidiun.edw.control.commands.captions
{
	import com.vidiun.commands.captionAsset.CaptionAssetGet;
	import com.vidiun.commands.captionAsset.CaptionAssetGetUrl;
	import com.vidiun.edw.control.commands.VedCommand;
	import com.vidiun.edw.control.events.CaptionsEvent;
	import com.vidiun.edw.vo.EntryCaptionVO;
	import com.vidiun.events.VidiunEvent;
	import com.vidiun.vmvc.control.VMvCEvent;
	import com.vidiun.types.VidiunFlavorAssetStatus;
	import com.vidiun.vo.VidiunCaptionAsset;
	
	
	public class GetCaptionDownloadUrl extends VedCommand
	{
		private var _captionVo:EntryCaptionVO;
		
		/**
		 * Will get the captionAsset, if its status=ready will ask for the updated donwload URL 
		 * @param event
		 * 
		 */		
		override public function execute(event:VMvCEvent):void {
			_captionVo = (event as CaptionsEvent).captionVo;
			if (_captionVo.caption && _captionVo.caption.id) {
				_model.increaseLoadCounter();
				
				var getCaption:CaptionAssetGet = new CaptionAssetGet(_captionVo.caption.id);
				getCaption.addEventListener(VidiunEvent.COMPLETE, captionRecieved);
				getCaption.addEventListener(VidiunEvent.FAILED, fault);
				
				_client.post(getCaption);
			}
		}
		
		/**
		 * On captionAsset result, will call getDownloadUrl if in status ready 
		 * @param event
		 * 
		 */		
		private function captionRecieved(event:VidiunEvent):void {
			if (event.data is VidiunCaptionAsset) {
				var resultCaption:VidiunCaptionAsset = event.data as VidiunCaptionAsset;
				_captionVo.caption.status = resultCaption.status;
				if (_captionVo.caption.status == VidiunFlavorAssetStatus.READY) {
//					var getUrl:CaptionAssetGetDownloadUrl = new CaptionAssetGetDownloadUrl(_captionVo.caption.id);
					var getUrl:CaptionAssetGetUrl = new CaptionAssetGetUrl(_captionVo.caption.id);
					getUrl.addEventListener(VidiunEvent.COMPLETE, result);
					getUrl.addEventListener(VidiunEvent.FAILED, fault);
					_client.post(getUrl);
				}
				else {
					_model.decreaseLoadCounter();
				}
			}
		}
		
		/**
		 * will reset the upload token id since upload has finished
		 * */
		override public function result(data:Object):void {
			super.result(data);
			_captionVo.downloadUrl = data.data as String;
			_captionVo.uploadTokenId = null;
			_model.decreaseLoadCounter();
		}
	}
}