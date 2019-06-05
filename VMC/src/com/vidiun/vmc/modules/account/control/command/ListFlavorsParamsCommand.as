package com.vidiun.vmc.modules.account.control.command
{
	import com.adobe.cairngorm.commands.ICommand;
	import com.adobe.cairngorm.control.CairngormEvent;
	import com.vidiun.commands.flavorParams.FlavorParamsList;
	import com.vidiun.edw.model.util.FlavorParamsUtil;
	import com.vidiun.events.VidiunEvent;
	import com.vidiun.vmc.business.JSGate;
	import com.vidiun.vmc.modules.account.model.AccountModelLocator;
	import com.vidiun.vo.FlavorVO;
	import com.vidiun.vo.VidiunFilterPager;
	import com.vidiun.vo.VidiunFlavorParams;
	import com.vidiun.vo.VidiunFlavorParamsListResponse;
	import com.vidiun.vo.VidiunLiveParams;
	
	import mx.collections.ArrayCollection;
	import mx.controls.Alert;
	import mx.resources.ResourceManager;
	import mx.rpc.IResponder;
	
	public class ListFlavorsParamsCommand implements ICommand, IResponder
	{
		private var _model : AccountModelLocator = AccountModelLocator.getInstance();
		public static const DEFAULT_PAGE_SIZE:int = 500;
		
		public function execute(event:CairngormEvent):void
		{
			// only load if we are missing data
			if (_model.liveFlavorsData.length == 0 || _model.mediaFlavorsData.length == 0) {
				var pager:VidiunFilterPager = new VidiunFilterPager();
				pager.pageSize = ListFlavorsParamsCommand.DEFAULT_PAGE_SIZE;
			 	var listFlavorParams:FlavorParamsList = new FlavorParamsList(null, pager);
			 	listFlavorParams.addEventListener(VidiunEvent.COMPLETE, result);
				listFlavorParams.addEventListener(VidiunEvent.FAILED, fault);
				_model.context.vc.post(listFlavorParams);
			}
			else {
				// shortcircuit results - refresh arrays to trigger binding
				var tmp:ArrayCollection = _model.liveFlavorsData;
				_model.liveFlavorsData = null;
				_model.liveFlavorsData = tmp;
					
				tmp = _model.mediaFlavorsData;
				_model.mediaFlavorsData = null;
				_model.mediaFlavorsData = tmp;
			}
		}
		
		
		public function result(event:Object):void
		{
			_model.loadingFlag = false;
			var response:VidiunFlavorParamsListResponse = event.data as VidiunFlavorParamsListResponse;
			var flavorsParams:Array = FlavorParamsUtil.makeManyFlavorParams(response.objects);
			
			var mediaFlvorsTmpArrCol:ArrayCollection = new ArrayCollection();
			var liveFlvorsTmpArrCol:ArrayCollection = new ArrayCollection();
			
			var flavor:FlavorVO;
			for each(var vFlavor:VidiunFlavorParams in flavorsParams) {
				// separate live flavorparams from all other flavor params
				flavor = new FlavorVO();
				flavor.vFlavor = vFlavor;
				if (vFlavor is VidiunLiveParams) {
					liveFlvorsTmpArrCol.addItem(flavor);
				}
				else {
					mediaFlvorsTmpArrCol.addItem(flavor);
				}
			}
			
			_model.mediaFlavorsData = mediaFlvorsTmpArrCol;
			_model.liveFlavorsData = liveFlvorsTmpArrCol;
			
		}
		
		
		public function fault(info:Object):void
		{
			if(info && info.error && info.error.errorMsg && info.error.errorMsg.toString().indexOf("Invalid VS") > -1 )
			{
				JSGate.expired();
				return;
			}
			Alert.show(ResourceManager.getInstance().getString('account', 'notLoadFlavors') + "/n/t"  + info.error.errorMsg, ResourceManager.getInstance().getString('account', 'error'));
			_model.loadingFlag = false;
		}
	}
}