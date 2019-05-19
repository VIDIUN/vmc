package com.vidiun.vmc.modules.account.control.command {
	import com.adobe.cairngorm.commands.ICommand;
	import com.adobe.cairngorm.control.CairngormEvent;
	import com.vidiun.commands.MultiRequest;
	import com.vidiun.commands.conversionProfile.ConversionProfileList;
	import com.vidiun.commands.conversionProfileAssetParams.ConversionProfileAssetParamsList;
	import com.vidiun.errors.VidiunError;
	import com.vidiun.events.VidiunEvent;
	import com.vidiun.vmc.modules.account.model.AccountModelLocator;
	import com.vidiun.vmc.modules.account.utils.ListConversionProfilesUtil;
	import com.vidiun.vmc.modules.account.vo.ConversionProfileVO;
	import com.vidiun.vo.VidiunConversionProfile;
	import com.vidiun.vo.VidiunConversionProfileAssetParamsFilter;
	import com.vidiun.vo.VidiunConversionProfileAssetParamsListResponse;
	import com.vidiun.vo.VidiunConversionProfileListResponse;
	import com.vidiun.vo.VidiunFilterPager;
	
	import mx.collections.ArrayCollection;
	import mx.controls.Alert;
	import mx.resources.ResourceManager;
	import mx.rpc.IResponder;

	public class ListLiveConversionProfilesCommand implements ICommand, IResponder {
		
		private var _model:AccountModelLocator = AccountModelLocator.getInstance();


		public function execute(event:CairngormEvent):void {
			_model.loadingFlag = true;
			var mr:MultiRequest = new MultiRequest();
			if (_model.liveCPPager) {
				// here we always want the first page
				_model.liveCPPager.pageIndex = 1;
			}
			var lcp:ConversionProfileList = new ConversionProfileList(_model.liveCPFilter, _model.liveCPPager);
			mr.addAction(lcp);
			
			var p:VidiunFilterPager = new VidiunFilterPager();
			p.pageSize = 1000;	// this is a very large number that should be enough to get all items
			var cpapFilter:VidiunConversionProfileAssetParamsFilter = new VidiunConversionProfileAssetParamsFilter();
			cpapFilter.conversionProfileIdFilter = _model.liveCPFilter;
			var cpaplist:ConversionProfileAssetParamsList = new ConversionProfileAssetParamsList(cpapFilter, p);
			mr.addAction(cpaplist);
			
			mr.addEventListener(VidiunEvent.COMPLETE, result);
			mr.addEventListener(VidiunEvent.FAILED, fault);
			_model.context.vc.post(mr);
		}


		public function result(event:Object):void {
			var er:VidiunError;
			if (event.data[0].error) {
				er = event.data[0].error as VidiunError;
				if (er) {
					Alert.show(er.errorMsg, ResourceManager.getInstance().getString('account', 'error'));
				}
			}
			else if (event.data[1].error) {
				er = event.data[1].error as VidiunError;
				if (er) {
					Alert.show(er.errorMsg, ResourceManager.getInstance().getString('account', 'error'));
				}
			}
			else {
				var response:VidiunConversionProfileListResponse = event.data[0] as VidiunConversionProfileListResponse;
				var ac:ArrayCollection = ListConversionProfilesUtil.handleConversionProfilesList(response.objects);
				_model.liveCPAPs = (event.data[1] as VidiunConversionProfileAssetParamsListResponse).objects;
				ListConversionProfilesUtil.addAssetParams(ac, _model.liveCPAPs);
				_model.liveConversionProfiles = ac;
				_model.totalLiveConversionProfiles = ac.length; 
			}
			_model.loadingFlag = false;
		}


		public function fault(event:Object):void {
			Alert.show(ResourceManager.getInstance().getString('account', 'notLoadConversionProfiles') + "\n\t" + event.error.errorMsg, ResourceManager.getInstance().getString('account', 'error'));
			_model.loadingFlag = false;
		}
	}
}