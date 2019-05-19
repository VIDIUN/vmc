package com.vidiun.vmc.modules.account.control.command
{
	import com.adobe.cairngorm.commands.ICommand;
	import com.adobe.cairngorm.control.CairngormEvent;
	import com.vidiun.commands.accessControl.AccessControlAdd;
	import com.vidiun.events.VidiunEvent;
	import com.vidiun.vmc.modules.account.control.events.AccessControlEvent;
	import com.vidiun.vmc.modules.account.model.AccountModelLocator;
	import com.vidiun.vo.AccessControlProfileVO;
	
	import flash.external.ExternalInterface;
	
	import mx.controls.Alert;
	import mx.resources.ResourceManager;
	import mx.rpc.IResponder;
	
	public class AddNewAccessControlProfileCommand implements ICommand, IResponder
	{
		private var _model : AccountModelLocator = AccountModelLocator.getInstance();
		
		public function execute(event:CairngormEvent):void
		{
			var accessControl:AccessControlProfileVO = event.data;
			var addNewAccessControl:AccessControlAdd = new AccessControlAdd(accessControl.profile);
		 	addNewAccessControl.addEventListener(VidiunEvent.COMPLETE, result);
			addNewAccessControl.addEventListener(VidiunEvent.FAILED, fault);
			_model.context.vc.post(addNewAccessControl);
		}
		
		public function result(data:Object):void
		{
			_model.loadingFlag = false;
			
			if(data.success)
			{
				Alert.show(ResourceManager.getInstance().getString('account', 'addNewAccessControlDoneMsg'));
				var getAllProfilesEvent:AccessControlEvent = new AccessControlEvent(AccessControlEvent.ACCOUNT_LIST_ACCESS_CONTROLS_PROFILES);
				getAllProfilesEvent.dispatch();
			}
			else
			{
				Alert.show(data.error, ResourceManager.getInstance().getString('account', 'error'));
			}

			//_model.partnerInfoLoaded = true;
		}
		
		public function fault(event:Object):void
		{
			_model.loadingFlag = false;
			Alert.show(ResourceManager.getInstance().getString('account', 'notAddedNewAccessControlMsg') + ':\n' + event.error.errorMsg, 
					   ResourceManager.getInstance().getString('account', 'error'));
		}
		

	}
}