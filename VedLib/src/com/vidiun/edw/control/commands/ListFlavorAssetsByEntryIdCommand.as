package com.vidiun.edw.control.commands {
	import com.vidiun.commands.flavorAsset.FlavorAssetGetFlavorAssetsWithParams;
	import com.vidiun.edw.control.events.VedEntryEvent;
	import com.vidiun.edw.model.datapacks.DistributionDataPack;
	import com.vidiun.edw.model.datapacks.EntryDataPack;
	import com.vidiun.edw.model.types.APIErrorCode;
	import com.vidiun.edw.vo.FlavorAssetWithParamsVO;
	import com.vidiun.errors.VidiunError;
	import com.vidiun.events.VidiunEvent;
	import com.vidiun.vmvc.control.VMvCEvent;
	import com.vidiun.types.VidiunFlavorAssetStatus;
	import com.vidiun.vo.VidiunBaseEntry;
	import com.vidiun.vo.VidiunFlavorAssetWithParams;
	import com.vidiun.vo.VidiunLiveParams;
	
	import mx.collections.ArrayCollection;
	import mx.controls.Alert;
	import mx.resources.ResourceManager;

	public class ListFlavorAssetsByEntryIdCommand extends VedCommand {
		override public function execute(event:VMvCEvent):void {
			_model.increaseLoadCounter();
			(_model.getDataPack(DistributionDataPack) as DistributionDataPack).flavorsLoaded = false;
			var entryId:String = (event as VedEntryEvent).entryVo.id;
			var getAssetsAndFlavorsByEntryId:FlavorAssetGetFlavorAssetsWithParams = new FlavorAssetGetFlavorAssetsWithParams(entryId);
			getAssetsAndFlavorsByEntryId.addEventListener(VidiunEvent.COMPLETE, result);
			getAssetsAndFlavorsByEntryId.addEventListener(VidiunEvent.FAILED, fault);
			_client.post(getAssetsAndFlavorsByEntryId);
		}


		override public function fault(info:Object):void {
			_model.decreaseLoadCounter();
			var entry:VidiunBaseEntry = (_model.getDataPack(EntryDataPack) as EntryDataPack).selectedEntry;
			// if this is a replacement entry
			if (entry.replacedEntryId) {
				var er:VidiunError = (info as VidiunEvent).error;
				if (er.errorCode == APIErrorCode.ENTRY_ID_NOT_FOUND) {
					Alert.show(ResourceManager.getInstance().getString('cms','replacementNotExistMsg'),ResourceManager.getInstance().getString('cms','replacementNotExistTitle'));
				}		
				else {
					Alert.show(ResourceManager.getInstance().getString('cms', 'flavorAssetsErrorMsg') + ":\n" + er.errorMsg, ResourceManager.getInstance().getString('cms', 'error'));
				}
			}
			else {
				Alert.show(ResourceManager.getInstance().getString('cms', 'flavorAssetsErrorMsg') + ":\n" + info.error.errorMsg, ResourceManager.getInstance().getString('cms', 'error'));
			}
		}


		override public function result(event:Object):void {
			super.result(event);
			setDataInModel((event as VidiunEvent).data as Array);
			(_model.getDataPack(DistributionDataPack) as DistributionDataPack).flavorsLoaded = true;
			_model.decreaseLoadCounter();
		}


		private function setDataInModel(arrCol:Array):void {
			var flavorParamsAndAssetsByEntryId:ArrayCollection = new ArrayCollection();
			var tempAc:ArrayCollection = new ArrayCollection();
			var foundIsOriginal:Boolean = false;
			for each (var assetWithParam:VidiunFlavorAssetWithParams in arrCol) {
				if (assetWithParam.flavorAsset && assetWithParam.flavorAsset.status == VidiunFlavorAssetStatus.TEMP) {
					// flavor assets will have status temp if it's source of conversion 
					// profile that has no source, during transcoding. we don't want to 
					// show these.
					continue;
				}
				if ((assetWithParam.flavorAsset != null) && (assetWithParam.flavorAsset.isOriginal)) {
					foundIsOriginal = true;
				}
				var vawp:FlavorAssetWithParamsVO = new FlavorAssetWithParamsVO();
				vawp.vidiunFlavorAssetWithParams = assetWithParam;
				if (assetWithParam.flavorAsset != null) {
					// first we add the ones with assets
					flavorParamsAndAssetsByEntryId.addItem(vawp);
					if (assetWithParam.flavorAsset.actualSourceAssetParamsIds) {
						// get the list of sources on the VO
						vawp.sources = getFlavorsByIds(assetWithParam.flavorAsset.actualSourceAssetParamsIds, arrCol);
					}
				}
				else if (assetWithParam.flavorParams && !(assetWithParam.flavorParams is VidiunLiveParams)) {
					// only keep non-live flavor params 
					tempAc.addItem(vawp);
				}
			}

			// then we add the ones without asset
			for each (var tmpObj:FlavorAssetWithParamsVO in tempAc) {
				flavorParamsAndAssetsByEntryId.addItem(tmpObj);
			}

			if (foundIsOriginal) {
				// let all flavors know we have original
				for each (var afwps:FlavorAssetWithParamsVO in flavorParamsAndAssetsByEntryId) {
					afwps.hasOriginal = true;
				}
			}
			(_model.getDataPack(DistributionDataPack) as DistributionDataPack).flavorParamsAndAssetsByEntryId = flavorParamsAndAssetsByEntryId;
		}
		
		private function getFlavorsByIds(sourceAssetParamsIds:String, allFlavors:Array):Array {
			allFlavors = allFlavors.slice();
			var result:Array = [];
			var required:Array = sourceAssetParamsIds.split(',');
			var assetWithParam:VidiunFlavorAssetWithParams; 
			for each (var source:int in required) {
				for (var i:int = 0; i<allFlavors.length; i++) {
					assetWithParam = allFlavors[i];
					if (assetWithParam.flavorParams.id == source) {
						result.push(assetWithParam.flavorParams);
						allFlavors.splice(i, 1);
						break;
					}
				}
			}
			return result;
		}
	}
}