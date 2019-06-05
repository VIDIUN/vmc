package com.vidiun.vmc.modules.content.commands {
	import com.adobe.cairngorm.commands.ICommand;
	import com.adobe.cairngorm.control.CairngormEvent;
	import com.vidiun.commands.flavorParams.FlavorParamsList;
	import com.vidiun.errors.VidiunError;
	import com.vidiun.events.VidiunEvent;
	import com.vidiun.edw.model.types.APIErrorCode;
	import com.vidiun.vo.VidiunFilterPager;
	import com.vidiun.vo.VidiunFlavorParams;
	import com.vidiun.vo.VidiunFlavorParamsListResponse;
	
	import mx.collections.ArrayCollection;
	import mx.controls.Alert;
	import mx.resources.ResourceManager;
	import mx.rpc.IResponder;
	import com.vidiun.edw.model.util.FlavorParamsUtil;

	public class ListFlavorsParamsCommand extends VidiunCommand implements ICommand, IResponder {
		public static const DEFAULT_PAGE_SIZE:int = 500;
		
		override public function execute(event:CairngormEvent):void {
			_model.increaseLoadCounter();
			var flavorsPager:VidiunFilterPager = new VidiunFilterPager();
			flavorsPager.pageSize = DEFAULT_PAGE_SIZE;
			var getListFlavorParams:FlavorParamsList = new FlavorParamsList(null, flavorsPager);
			getListFlavorParams.addEventListener(VidiunEvent.COMPLETE, result);
			getListFlavorParams.addEventListener(VidiunEvent.FAILED, fault);
			_model.context.vc.post(getListFlavorParams);
		}


		override public function result(event:Object):void {
//			super.result(event);
			if (event.error) {
				var er:VidiunError = event.error as VidiunError;
				if (er) {
					Alert.show(er.errorMsg, "Error");
				}
			}
			else {
				clearOldData();
				var tempFlavorParamsArr:ArrayCollection = new ArrayCollection();
				var response:VidiunFlavorParamsListResponse = event.data as VidiunFlavorParamsListResponse;
				// loop on Object and cast to VidiunFlavorParams so we don't crash on unknown types:
				for each (var vFlavor:Object in response.objects) {
					if (vFlavor is VidiunFlavorParams) {
						tempFlavorParamsArr.addItem(vFlavor);
					}
					else {
						tempFlavorParamsArr.addItem(FlavorParamsUtil.makeFlavorParams(vFlavor));
					}
				}
				_model.filterModel.flavorParams = tempFlavorParamsArr;
			}
			_model.decreaseLoadCounter();
		}

//		/**
//		 * This function will be called if the request failed
//		 * @param info the info returned from the server
//		 * 
//		 */		
//		override public function fault(info:Object):void
//		{
//			
//			if(info && info.error && info.error.errorMsg && info.error.errorCode != APIErrorCode.SERVICE_FORBIDDEN)
//			{
//				Alert.show(info.error.errorMsg, ResourceManager.getInstance().getString('cms', 'error'));
//			}
//			_model.decreaseLoadCounter();
//		}

		private function clearOldData():void {
			_model.filterModel.flavorParams.removeAll();
		}
	}
}