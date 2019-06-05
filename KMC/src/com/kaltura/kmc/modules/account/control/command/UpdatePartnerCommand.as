package com.vidiun.vmc.modules.account.control.command {
	import com.adobe.cairngorm.commands.ICommand;
	import com.adobe.cairngorm.control.CairngormEvent;
	import com.vidiun.commands.partner.PartnerUpdate;
	import com.vidiun.events.VidiunEvent;
	import com.vidiun.vmc.business.JSGate;
	import com.vidiun.vmc.modules.account.business.PartnerInfoUtil;
	import com.vidiun.vmc.modules.account.model.AccountModelLocator;
	import com.vidiun.vmc.modules.account.vo.NotificationVO;
	import com.vidiun.vo.VidiunPartner;
	
	import mx.collections.ArrayCollection;
	import mx.controls.Alert;
	import mx.resources.ResourceManager;

	public class UpdatePartnerCommand implements ICommand {
		private var _model:AccountModelLocator = AccountModelLocator.getInstance();


		public function execute(event:CairngormEvent):void {
			_model.loadingFlag = true;

			var vp:VidiunPartner = _model.partnerData.partner;
			vp.notificationsConfig = PartnerInfoUtil.getNotificationsConfig(_model.partnerData.notifications);
			vp.setUpdatedFieldsOnly(true);
			var updatePartner:PartnerUpdate = new PartnerUpdate(vp, true);
			updatePartner.addEventListener(VidiunEvent.COMPLETE, result);
			updatePartner.addEventListener(VidiunEvent.FAILED, fault);
			_model.context.vc.post(updatePartner);
		}


		private function result(data:Object):void {
			_model.loadingFlag = false;
			_model.partnerData.partner = data.data as VidiunPartner; 
//			PartnerInfoUtil.createNotificationArray(resultVp.notificationsConfig, pvo.notifications);
			Alert.show(ResourceManager.getInstance().getString('account', 'changesSaved'));
		}


		private function fault(info:Object):void {
			_model.loadingFlag = false;
			if (info && info.error && info.error.errorMsg && info.error.errorMsg.toString().indexOf("Invalid VS") > -1) {
				JSGate.expired();
				return;
			}
			Alert.show(info.error.errorMsg, ResourceManager.getInstance().getString('account', 'error'));
		}
	}
}
