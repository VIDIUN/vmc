package com.vidiun.vmc.modules.account.control.command {
	import com.adobe.cairngorm.commands.ICommand;
	import com.adobe.cairngorm.control.CairngormEvent;
	import com.vidiun.commands.category.CategoryList;
	import com.vidiun.events.VidiunEvent;
	import com.vidiun.vmc.business.JSGate;
	import com.vidiun.vmc.modules.account.model.AccountModelLocator;
	import com.vidiun.vo.VidiunCategory;
	import com.vidiun.vo.VidiunCategoryFilter;
	import com.vidiun.vo.VidiunCategoryListResponse;
	
	import mx.collections.ArrayCollection;
	import mx.controls.Alert;
	import mx.resources.ResourceManager;
	import mx.rpc.IResponder;

	public class ListCategoriesCommand implements ICommand, IResponder {

		private var _model:AccountModelLocator = AccountModelLocator.getInstance();


		public function execute(event:CairngormEvent):void {
			var filter:VidiunCategoryFilter = new VidiunCategoryFilter();
			filter.privacyContextEqual = "*";	
			var list:CategoryList = new CategoryList(filter);
			list.addEventListener(VidiunEvent.COMPLETE, result);
			list.addEventListener(VidiunEvent.FAILED, fault);
			_model.context.vc.post(list);
		}


		public function result(data:Object):void {
			var listResult:VidiunCategoryListResponse = data.data as VidiunCategoryListResponse;
			if (!listResult.objects || listResult.objects.length == 0) {
				var n_a:String = ResourceManager.getInstance().getString('account', 'n_a');
				var dummy:VidiunCategory = new VidiunCategory();
				dummy.name = n_a;
				dummy.privacyContext = n_a;
				dummy.disabled = true;	// will later use this value to disable actions in IR
				_model.categoriesWithPrivacyContext = [dummy];
			} 
			else {
				_model.categoriesWithPrivacyContext = listResult.objects;
			}
		}


		/**
		 * This function handles errors from the server
		 * @param info the error from the server
		 *
		 */
		public function fault(info:Object):void {
			if (info && info.error && info.error.errorMsg && info.error.errorMsg.toString().indexOf("Invalid VS") > -1) {
				JSGate.expired();
				return;
			}
			_model.loadingFlag = false;
			Alert.show(info.error.errorMsg, ResourceManager.getInstance().getString('account', 'error'));

		}
	}
}
