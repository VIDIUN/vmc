package com.vidiun.vmc.modules.account.control.command {
	import com.adobe.cairngorm.commands.ICommand;
	import com.adobe.cairngorm.control.CairngormEvent;
	import com.vidiun.commands.MultiRequest;
	import com.vidiun.commands.conversionProfile.ConversionProfileList;
	import com.vidiun.commands.conversionProfileAssetParams.ConversionProfileAssetParamsList;
	import com.vidiun.commands.flavorParams.FlavorParamsList;
	import com.vidiun.commands.thumbParams.ThumbParamsList;
	import com.vidiun.controls.Paging;
	import com.vidiun.edw.model.types.APIErrorCode;
	import com.vidiun.edw.model.util.FlavorParamsUtil;
	import com.vidiun.events.VidiunEvent;
	import com.vidiun.vmc.modules.account.control.events.ConversionSettingsEvent;
	import com.vidiun.vmc.modules.account.model.AccountModelLocator;
	import com.vidiun.vmc.modules.account.utils.ListConversionProfilesUtil;
	import com.vidiun.vmc.modules.account.vo.ConversionProfileVO;
	import com.vidiun.vo.FlavorVO;
	import com.vidiun.vo.VidiunConversionProfile;
	import com.vidiun.vo.VidiunConversionProfileAssetParamsFilter;
	import com.vidiun.vo.VidiunConversionProfileAssetParamsListResponse;
	import com.vidiun.vo.VidiunConversionProfileListResponse;
	import com.vidiun.vo.VidiunFilterPager;
	import com.vidiun.vo.VidiunFlavorParams;
	import com.vidiun.vo.VidiunFlavorParamsListResponse;
	import com.vidiun.vo.VidiunLiveParams;
	import com.vidiun.vo.VidiunThumbParams;
	import com.vidiun.vo.VidiunThumbParamsListResponse;
	
	import mx.collections.ArrayCollection;
	import mx.controls.Alert;
	import mx.resources.IResourceManager;
	import mx.resources.ResourceManager;
	import mx.rpc.IResponder;

	public class ListConversionProfilesAndFlavorParamsCommand implements ICommand, IResponder {
		private var _model:AccountModelLocator = AccountModelLocator.getInstance();


		public function execute(event:CairngormEvent):void {
			var mr:MultiRequest = new MultiRequest();

			_model.loadingFlag = true;

			if (!_model.mediaCPPager) {
				_model.mediaCPPager = new VidiunFilterPager();
			}
			if (event.data) {
				_model.mediaCPPager.pageIndex = event.data[0];
				_model.mediaCPPager.pageSize = event.data[1];
			}
			var listConversionProfiles:ConversionProfileList = new ConversionProfileList(_model.mediaCPFilter, _model.mediaCPPager);
			mr.addAction(listConversionProfiles);
			
			var p:VidiunFilterPager = new VidiunFilterPager();
			p.pageSize = 1000;	// this is a very large number that should be enough to get all items
			var cpapFilter:VidiunConversionProfileAssetParamsFilter = new VidiunConversionProfileAssetParamsFilter();
			cpapFilter.conversionProfileIdFilter = _model.mediaCPFilter;
			var cpaplist:ConversionProfileAssetParamsList = new ConversionProfileAssetParamsList(cpapFilter, p);
			mr.addAction(cpaplist);

			if (_model.mediaFlavorsData.length == 0) {
				// assume this means flavors were not yet loaded, let's load:
				var pager:VidiunFilterPager = new VidiunFilterPager();
				pager.pageSize = ListFlavorsParamsCommand.DEFAULT_PAGE_SIZE;
				var listFlavorParams:FlavorParamsList = new FlavorParamsList(null, pager);
				mr.addAction(listFlavorParams);
			}
			
			mr.addEventListener(VidiunEvent.COMPLETE, result);
			mr.addEventListener(VidiunEvent.FAILED, fault);
			_model.context.vc.post(mr);
		}


		public function result(event:Object):void {
			var vEvent:VidiunEvent = event as VidiunEvent;
			// error handling
			if (vEvent.data && vEvent.data.length > 0) {
				for (var i:int = 0; i < vEvent.data.length; i++) {
					if (vEvent.data[i].error) {
						var rm:IResourceManager = ResourceManager.getInstance();
						if (vEvent.data[i].error.code == APIErrorCode.SERVICE_FORBIDDEN) {
							Alert.show(rm.getString('common', 'forbiddenError', [vEvent.data[i].error.message]), rm.getString('common', 'forbiden_error_title'));
						}
						else {
							Alert.show(vEvent.data[i].error.message, rm.getString('common', 'forbiden_error_title'));
						}
						_model.loadingFlag = false;
						return;
					}
				}
			}

			// conversion profs
			var convProfilesTmpArrCol:ArrayCollection = new ArrayCollection();
			var convsProfilesRespones:VidiunConversionProfileListResponse = (vEvent.data as Array)[0] as VidiunConversionProfileListResponse;
			for each (var cProfile:VidiunConversionProfile in convsProfilesRespones.objects) {
				var cp:ConversionProfileVO = new ConversionProfileVO();
				cp.profile = cProfile;
				cp.id = cProfile.id.toString();

				if (cp.profile.isDefault) {
					convProfilesTmpArrCol.addItemAt(cp, 0);
				}
				else {
					convProfilesTmpArrCol.addItem(cp);
				}
			}
			
			// conversionProfileAssetParams
			_model.mediaCPAPs = (vEvent.data[1] as VidiunConversionProfileAssetParamsListResponse).objects;
			ListConversionProfilesUtil.addAssetParams(convProfilesTmpArrCol, _model.mediaCPAPs);
			
			// flavors
			var flvorsTmpArrCol:ArrayCollection;
			var liveFlvorsTmpArrCol:ArrayCollection;
			if (_model.mediaFlavorsData.length == 0) {
				flvorsTmpArrCol = new ArrayCollection();
				liveFlvorsTmpArrCol = new ArrayCollection();
				var flavorsResponse:VidiunFlavorParamsListResponse = (vEvent.data as Array)[2] as VidiunFlavorParamsListResponse;
				var flavor:FlavorVO;
				for each (var vFlavor:VidiunFlavorParams in flavorsResponse.objects) {
					// separate live flavorparams from all other flavor params, keep both
					flavor = new FlavorVO();
					flavor.vFlavor = vFlavor as VidiunFlavorParams;
					if (vFlavor is VidiunLiveParams) {
						liveFlvorsTmpArrCol.addItem(flavor);
					}
					else {
						flvorsTmpArrCol.addItem(flavor);
					}
				}
				// save live (regular is saved later)
				_model.liveFlavorsData = liveFlvorsTmpArrCol;
			}
			else {
				// take from model
				flvorsTmpArrCol = _model.mediaFlavorsData;
				_model.mediaFlavorsData = null; // refresh
			}
			
			// mark flavors of first profile
			var selectedItems:Array;
			if ((convProfilesTmpArrCol[0] as ConversionProfileVO).profile.flavorParamsIds) {
				// some partner managed to remove all flavors from his default profile, so VMC crashed on this line.
				selectedItems = (convProfilesTmpArrCol[0] as ConversionProfileVO).profile.flavorParamsIds.split(",");
			}
			else {
				selectedItems = new Array();
			}
			
			ListConversionProfilesUtil.selectFlavorParamsByIds(flvorsTmpArrCol, selectedItems);

			_model.mediaFlavorsData = flvorsTmpArrCol;
			_model.totalMediaConversionProfiles = convsProfilesRespones.totalCount; 
			_model.mediaConversionProfiles = convProfilesTmpArrCol;
			_model.loadingFlag = false;
		}


		public function fault(event:Object):void {
			Alert.show(ResourceManager.getInstance().getString('account', 'notLoadConversionProfiles') + "\n\t" + event.error.errorMsg, ResourceManager.getInstance().getString('account', 'error'));
			_model.loadingFlag = false;
		}


	}
}