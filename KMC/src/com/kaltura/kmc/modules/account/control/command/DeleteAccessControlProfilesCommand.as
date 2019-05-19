package com.vidiun.vmc.modules.account.control.command {
	import com.adobe.cairngorm.commands.ICommand;
	import com.adobe.cairngorm.control.CairngormEvent;
	import com.vidiun.analytics.GoogleAnalyticsConsts;
	import com.vidiun.analytics.GoogleAnalyticsTracker;
	import com.vidiun.analytics.VAnalyticsTracker;
	import com.vidiun.analytics.VAnalyticsTrackerConsts;
	import com.vidiun.commands.MultiRequest;
	import com.vidiun.commands.accessControl.AccessControlDelete;
	import com.vidiun.events.VidiunEvent;
	import com.vidiun.vmc.business.JSGate;
	import com.vidiun.vmc.modules.account.control.events.AccessControlEvent;
	import com.vidiun.vmc.modules.account.model.AccountModelLocator;
	import com.vidiun.types.VidiunStatsVmcEventType;
	import com.vidiun.vo.AccessControlProfileVO;
	
	import mx.controls.Alert;
	import mx.events.CloseEvent;
	import mx.resources.IResourceManager;
	import mx.resources.ResourceManager;
	import mx.rpc.IResponder;

	public class DeleteAccessControlProfilesCommand implements ICommand, IResponder {
		private var _model:AccountModelLocator = AccountModelLocator.getInstance();

		private var _profiles:Array;

		public function execute(event:CairngormEvent):void {
			var rm:IResourceManager = ResourceManager.getInstance(); 
			_profiles = event.data;
			
			if (_profiles.length == 0) {
				Alert.show(rm.getString('account', 'noProfilesSelected'));
				return;
			}
			
			var delStr:String = '';
			for each (var acp:AccessControlProfileVO in _profiles) {
				if (!acp.profile.isDefault) {
					delStr += '\n' + acp.profile.name;
				}
			}
			
			var msg:String = rm.getString('account', 'deleteAccessControlAlertMsg', [delStr]);
			var title:String = rm.getString('account', 'deleteAccessControlAlertTitle');
			Alert.show(msg, title, Alert.YES | Alert.NO, null, deleteSelectedProfiles);
		}
		
		
		private function deleteSelectedProfiles(evt:CloseEvent):void {
			if (evt.detail == Alert.YES) {
				var mr:MultiRequest = new MultiRequest();
				for each (var prof:AccessControlProfileVO in _profiles) {
					var deleteProf:AccessControlDelete = new AccessControlDelete(prof.profile.id);
					mr.addAction(deleteProf);
				}
				
				mr.addEventListener(VidiunEvent.COMPLETE, result);
				mr.addEventListener(VidiunEvent.FAILED, fault);
				_model.context.vc.post(mr);
				
				VAnalyticsTracker.getInstance().sendEvent(VAnalyticsTrackerConsts.ACCOUNT, VidiunStatsVmcEventType.ACCOUNT_ACCESS_CONTROL_DELETE, "Account>Access Control Delete");
				GoogleAnalyticsTracker.getInstance().sendToGA(GoogleAnalyticsConsts.ACCOUNT_ACCESS_CONTROL_DELETE, GoogleAnalyticsConsts.ACCOUNT);
			}
		}



		public function result(data:Object):void {
			_model.loadingFlag = false;
			if (data.success) {
				if (_profiles.length > 1) {
					Alert.show(ResourceManager.getInstance().getString('account', 'deleteAccessProfilesDoneMsg'));
				}
				else {
					Alert.show(ResourceManager.getInstance().getString('account', 'deleteAccessProfileDoneMsg'));
				}
				var getAllProfilesEvent:AccessControlEvent = new AccessControlEvent(AccessControlEvent.ACCOUNT_LIST_ACCESS_CONTROLS_PROFILES);
				getAllProfilesEvent.dispatch();
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
