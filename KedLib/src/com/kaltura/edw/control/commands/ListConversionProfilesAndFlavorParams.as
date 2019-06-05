package com.vidiun.edw.control.commands {
	import com.vidiun.commands.MultiRequest;
	import com.vidiun.commands.conversionProfile.ConversionProfileList;
	import com.vidiun.commands.conversionProfileAssetParams.ConversionProfileAssetParamsList;
	import com.vidiun.commands.flavorParams.FlavorParamsList;
	import com.vidiun.edw.model.datapacks.FlavorsDataPack;
	import com.vidiun.edw.model.util.FlavorParamsUtil;
	import com.vidiun.edw.vo.ConversionProfileWithFlavorParamsVo;
	import com.vidiun.errors.VidiunError;
	import com.vidiun.events.VidiunEvent;
	import com.vidiun.vmvc.control.VMvCEvent;
	import com.vidiun.types.VidiunAssetParamsOrigin;
	import com.vidiun.types.VidiunConversionProfileOrderBy;
	import com.vidiun.types.VidiunConversionProfileType;
	import com.vidiun.vo.VidiunConversionProfile;
	import com.vidiun.vo.VidiunConversionProfileAssetParams;
	import com.vidiun.vo.VidiunConversionProfileAssetParamsFilter;
	import com.vidiun.vo.VidiunConversionProfileAssetParamsListResponse;
	import com.vidiun.vo.VidiunConversionProfileFilter;
	import com.vidiun.vo.VidiunConversionProfileListResponse;
	import com.vidiun.vo.VidiunFilterPager;
	import com.vidiun.vo.VidiunFlavorParams;
	import com.vidiun.vo.VidiunFlavorParamsListResponse;
	import com.vidiun.vo.VidiunLiveParams;
	
	import mx.collections.ArrayCollection;
	import mx.controls.Alert;

	public class ListConversionProfilesAndFlavorParams extends VedCommand {

		override public function execute(event:VMvCEvent):void {
			_model.increaseLoadCounter();
			var p:VidiunFilterPager = new VidiunFilterPager();
			p.pageSize = 1000;	// this is a very large number that should be enough to get all items

			var fdp:FlavorsDataPack = _model.getDataPack(FlavorsDataPack) as FlavorsDataPack;
			
			var mr:MultiRequest = new MultiRequest();
			if (!fdp.conversionProfileLoaded) {
				var cpFilter:VidiunConversionProfileFilter = new VidiunConversionProfileFilter();
				cpFilter.orderBy = VidiunConversionProfileOrderBy.CREATED_AT_DESC;
				cpFilter.typeEqual = VidiunConversionProfileType.MEDIA;
				var listConversionProfiles:ConversionProfileList = new ConversionProfileList(cpFilter, p);
				mr.addAction(listConversionProfiles);
				
				var listFlavorParams:FlavorParamsList = new FlavorParamsList(null, p);
				mr.addAction(listFlavorParams);
			}

			
			var f:VidiunConversionProfileAssetParamsFilter = new VidiunConversionProfileAssetParamsFilter();
			f.originIn = VidiunAssetParamsOrigin.INGEST + "," + VidiunAssetParamsOrigin.CONVERT_WHEN_MISSING;
			var listcpaps:ConversionProfileAssetParamsList = new ConversionProfileAssetParamsList(f, p);
			mr.addAction(listcpaps);

			mr.addEventListener(VidiunEvent.COMPLETE, result);
			mr.addEventListener(VidiunEvent.FAILED, fault);
			_client.post(mr);
		}


		override public function result(event:Object):void {
			// error handling
			var er:VidiunError ;
			if (event.error) {
				er = event.error as VidiunError;
				if (er) {
					Alert.show(er.errorMsg, "Error");
				}
			}
			else {
				for (var i:int = 0; i<event.data.length; i++) {
					if (event.data[i].error) {
						er = event.data[i].error as VidiunError;
						if (er) {
							Alert.show(er.errorMsg, "Error");
						}
					}
				}
			}
			
			// result
			if (!er) {
				var startIndex:int; 
				var profs:Array;
				var params:Array;
				var fdp:FlavorsDataPack = _model.getDataPack(FlavorsDataPack) as FlavorsDataPack;
				// conversion profiles, flavor params
				if (fdp.conversionProfileLoaded) {
					startIndex = 0;
					profs = fdp.conversionProfiles;
					params = fdp.flavorParams;
				}
				else {
					startIndex = 2;
					profs = (event.data[0] as VidiunConversionProfileListResponse).objects;
					fdp.conversionProfiles = profs;
					var temp:Array = FlavorParamsUtil.makeManyFlavorParams((event.data[1] as VidiunFlavorParamsListResponse).objects); 
					params = new Array();
					for each (var fp:VidiunFlavorParams in temp) {
						if (!(fp is VidiunLiveParams)) {
							params.push(fp);
						}
					}
					fdp.flavorParams = params;
					fdp.conversionProfileLoaded = true;
				}
				
				var cpaps:Array = (event.data[startIndex] as VidiunConversionProfileAssetParamsListResponse).objects;
				
				var tempArrCol:ArrayCollection = new ArrayCollection();

				for each (var cProfile:Object in profs) {
					if (cProfile is VidiunConversionProfile) {
						var cp:ConversionProfileWithFlavorParamsVo = new ConversionProfileWithFlavorParamsVo();
						cp.profile = cProfile as VidiunConversionProfile;
						addFlavorParams(cp, cpaps, params);
						tempArrCol.addItem(cp);
					}
				}
				fdp.conversionProfsWFlavorParams = tempArrCol;
			}	
			_model.decreaseLoadCounter();
		}
			
		/**
		 * create a list of <code>VidiunConversionProfileAssetParams</code> that belong to 
		 * the conversion profile on the given VO, and add it to the VO.
		 * @param cp		VO to be updated
		 * @param cpaps		objects to filter
		 * @param params	flavor params objects, used for their names.
		 * 
		 */
		protected function addFlavorParams(cp:ConversionProfileWithFlavorParamsVo, cpaps:Array, params:Array):void {
			var profid:int = cp.profile.id;
			for each (var cpap:VidiunConversionProfileAssetParams in cpaps) {
				if (cpap && cpap.conversionProfileId == profid && cpap.origin != VidiunAssetParamsOrigin.CONVERT) {
					for each (var ap:VidiunFlavorParams in params) {
						if (ap && ap.id == cpap.assetParamsId) {
							// add flavor name to the cpap, to be used in dropdown in IR
							cpap.name = ap.name;
							cp.flavors.addItem(cpap);
							break;
						}
					}
				}
			}
		}
		
		
		/**
		 * get cpap by keys 
		 * @param cpid	conversion profile id
		 * @param apid	asset params id
		 * @return 
		 */
		protected function getCpap(cpid:int, apid:int, cpaps:Array):VidiunConversionProfileAssetParams {
			for each (var cpap:VidiunConversionProfileAssetParams in cpaps) {
				if (cpap.assetParamsId == apid && cpap.conversionProfileId == cpid) {
					return cpap;
				}
			}
			return null;
		}
	}
}