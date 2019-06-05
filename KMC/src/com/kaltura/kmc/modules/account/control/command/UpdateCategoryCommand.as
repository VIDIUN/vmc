package com.vidiun.vmc.modules.account.control.command {
	import com.adobe.cairngorm.commands.ICommand;
	import com.adobe.cairngorm.control.CairngormEvent;
	import com.vidiun.commands.category.CategoryUpdate;
	import com.vidiun.events.VidiunEvent;
	import com.vidiun.vmc.business.JSGate;
	import com.vidiun.vmc.modules.account.control.events.IntegrationEvent;
	import com.vidiun.vmc.modules.account.model.AccountModelLocator;
	import com.vidiun.vo.VidiunCategory;
	
	import mx.controls.Alert;
	import mx.resources.ResourceManager;
	import mx.rpc.IResponder;

	public class UpdateCategoryCommand implements ICommand, IResponder {

		private var _model:AccountModelLocator = AccountModelLocator.getInstance();


		public function execute(event:CairngormEvent):void {
			_model.loadingFlag = true;
			var vCat:VidiunCategory = event.data as VidiunCategory;
			vCat.setUpdatedFieldsOnly(true);
			var update:CategoryUpdate = new CategoryUpdate(vCat.id, vCat);
			update.addEventListener(VidiunEvent.COMPLETE, result);
			update.addEventListener(VidiunEvent.FAILED, fault);
			_model.context.vc.post(update);
		}


		public function result(data:Object):void {
			var event:VidiunEvent = data as VidiunEvent;
			_model.loadingFlag = false;
			if (event.success) {
				// list categories with context again
				var list:IntegrationEvent = new IntegrationEvent(IntegrationEvent.LIST_CATEGORIES_WITH_PRIVACY_CONTEXT);
				list.dispatch();
			}
			else {
				Alert.show((data as VidiunEvent).error.errorMsg, ResourceManager.getInstance().getString('account', 'error'));
			}

		}


		public function fault(info:Object):void {
			if (info && info.error && info.error.errorMsg) {
				
			 	if (info.error.errorMsg.toString().indexOf("Invalid VS") > -1) {
					JSGate.expired();
					return;
				}
				else {
					Alert.show(info.error.errorMsg, ResourceManager.getInstance().getString('account', 'error'));	
				}
			}
			_model.loadingFlag = false;
		}

	}
}
