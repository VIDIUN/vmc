package com.vidiun.vmc.modules.account.control.command {
	import com.adobe.cairngorm.commands.ICommand;
	import com.adobe.cairngorm.control.CairngormEvent;
	import com.vidiun.commands.MultiRequest;
	import com.vidiun.commands.conversionProfile.ConversionProfileDelete;
	import com.vidiun.events.VidiunEvent;
	import com.vidiun.vmc.business.JSGate;
	import com.vidiun.vmc.modules.account.control.events.ConversionSettingsEvent;
	import com.vidiun.vmc.modules.account.model.AccountModelLocator;
	import com.vidiun.vmc.modules.account.vo.ConversionProfileVO;
	
	import mx.controls.Alert;
	import mx.events.CloseEvent;
	import mx.resources.IResourceManager;
	import mx.resources.ResourceManager;
	import mx.rpc.IResponder;

	public class DeleteConversionProfileCommand implements ICommand, IResponder {
		private var _model:AccountModelLocator = AccountModelLocator.getInstance();

		private var _nextEvent:CairngormEvent;
		
		private var _profs:Array;

		public function execute(event:CairngormEvent):void {
			_nextEvent = (event as ConversionSettingsEvent).nextEvent;
			
			_profs = event.data;
			var rm:IResourceManager = ResourceManager.getInstance();
			
			if (_profs.length == 0) {
				Alert.show(rm.getString('account', 'noProfilesSelected'));
			}
			else {
				var delStr:String = "";
				for each (var cp:ConversionProfileVO in _profs) {
					if (!cp.profile.isDefault) {
						delStr += '\n' + cp.profile.name;
					}
				}
				
				var msg:String = rm.getString('account', 'deleteAlertMsg') + delStr + " ?";
				var title:String = rm.getString('account', 'deleteAlertTitle');
				
				Alert.show(msg, title, Alert.YES | Alert.NO, null, deleteProfiles);
			}
		}
		
		
		private function deleteProfiles(evt:CloseEvent):void {
			if (evt.detail == Alert.YES) {
				
				var mr:MultiRequest = new MultiRequest();
				for each (var cp:ConversionProfileVO in _profs) {
					var deleteConversions:ConversionProfileDelete = new ConversionProfileDelete(cp.profile.id);
					mr.addAction(deleteConversions);
				}
				
				
				mr.addEventListener(VidiunEvent.COMPLETE, result);
				mr.addEventListener(VidiunEvent.FAILED, fault);
				_model.context.vc.post(mr);
			}
		}

		public function result(data:Object):void {
			_model.loadingFlag = false;
			if (data.success) {
				Alert.show(ResourceManager.getInstance().getString('account', 'deleteConvProfilesDoneMsg'));
				if (_nextEvent) {
					_nextEvent.dispatch();
				}
			}
			else {
				Alert.show(data.error, ResourceManager.getInstance().getString('account', 'error'));
			}

		}


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
