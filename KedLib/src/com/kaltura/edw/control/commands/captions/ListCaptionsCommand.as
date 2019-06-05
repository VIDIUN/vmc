package com.vidiun.edw.control.commands.captions {
	import com.vidiun.commands.MultiRequest;
	import com.vidiun.commands.captionAsset.CaptionAssetGetUrl;
	import com.vidiun.commands.captionAsset.CaptionAssetList;
	import com.vidiun.edw.control.commands.VedCommand;
	import com.vidiun.edw.model.datapacks.CaptionsDataPack;
	import com.vidiun.edw.model.datapacks.EntryDataPack;
	import com.vidiun.edw.vo.EntryCaptionVO;
	import com.vidiun.events.VidiunEvent;
	import com.vidiun.vmvc.control.VMvCEvent;
	import com.vidiun.types.VidiunCaptionAssetStatus;
	import com.vidiun.types.VidiunFlavorAssetStatus;
	import com.vidiun.types.VidiunNullableBoolean;
	import com.vidiun.vo.VidiunAssetFilter;
	import com.vidiun.vo.VidiunCaptionAsset;
	import com.vidiun.vo.VidiunCaptionAssetListResponse;
	import com.vidiun.vo.VidiunFilterPager;

	public class ListCaptionsCommand extends VedCommand {
		private var _captionsArray:Array;
		/**
		 * array of captions in status ready, request download url only for these captions
		 * */
		private var _readyCaptionsArray:Array;


		override public function execute(event:VMvCEvent):void {
			_model.increaseLoadCounter();
			var filter:VidiunAssetFilter = new VidiunAssetFilter();
			filter.entryIdEqual = (_model.getDataPack(EntryDataPack) as EntryDataPack).selectedEntry.id;
			var pager:VidiunFilterPager = new VidiunFilterPager();
			pager.pageSize = 100;
			var listCaptions:CaptionAssetList = new CaptionAssetList(filter, pager);
			listCaptions.addEventListener(VidiunEvent.COMPLETE, listResult);
			listCaptions.addEventListener(VidiunEvent.FAILED, fault);

			_client.post(listCaptions);
		}


		private function listResult(data:Object):void {
			var listResponse:VidiunCaptionAssetListResponse = data.data as VidiunCaptionAssetListResponse;
			if (listResponse) {
				var mr:MultiRequest = new MultiRequest();
				_captionsArray = new Array();
				_readyCaptionsArray = new Array();
				for each (var caption:VidiunCaptionAsset in listResponse.objects) {
					var entryCaption:EntryCaptionVO = new EntryCaptionVO();
					entryCaption.caption = caption;
					entryCaption.vmcStatus = getVMCStatus(caption);
					entryCaption.serveUrl = _client.protocol + _client.domain + EntryCaptionVO.generalServeURL + "/vs/" + _client.vs + "/captionAssetId/" + caption.id;
					if (caption.isDefault == VidiunNullableBoolean.TRUE_VALUE) {
						entryCaption.isVmcDefault = true;
					}
					_captionsArray.push(entryCaption);
					if (caption.status == VidiunFlavorAssetStatus.READY) {
						var getUrl:CaptionAssetGetUrl = new CaptionAssetGetUrl(caption.id);
						mr.addAction(getUrl);
						_readyCaptionsArray.push(entryCaption);
					}
				}

				if (_readyCaptionsArray.length) {
					mr.addEventListener(VidiunEvent.COMPLETE, handleDownloadUrls);
					mr.addEventListener(VidiunEvent.FAILED, fault);
					_client.post(mr);
				}
				else //go strait to result
					result(data);
			}
		}


		private function getVMCStatus(caption:VidiunCaptionAsset):String {
			var result:String;
			switch (caption.status) {
				case VidiunCaptionAssetStatus.ERROR:
					result = EntryCaptionVO.ERROR;
					break;
				case VidiunCaptionAssetStatus.READY:
					result = EntryCaptionVO.SAVED;
					break;
//				case VidiunCaptionAssetStatus.DELETED:
//				case VidiunCaptionAssetStatus.IMPORTING:
//				case VidiunCaptionAssetStatus.QUEUED:
				default:
					result = EntryCaptionVO.PROCESSING;
					break;
				
			}
			return result;
		}


		private function handleDownloadUrls(data:Object):void {
			var urlResult:Array = data.data as Array;
			for (var i:int = 0; i < urlResult.length; i++) {
				if (urlResult[i] is String)
					(_readyCaptionsArray[i] as EntryCaptionVO).downloadUrl = urlResult[i] as String;
			}
			result(data);
		}


		override public function result(data:Object):void {
			super.result(data);
			
			(_model.getDataPack(CaptionsDataPack) as CaptionsDataPack).captionsArray = _captionsArray;
			_model.decreaseLoadCounter();
		}

	}
}