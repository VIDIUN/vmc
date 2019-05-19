package com.vidiun.vmc.modules.account.control.command {
	import com.adobe.cairngorm.commands.ICommand;
	import com.adobe.cairngorm.control.CairngormEvent;
	import com.vidiun.commands.partner.PartnerGetInfo;
	import com.vidiun.events.VidiunEvent;
	import com.vidiun.vmc.business.JSGate;
	import com.vidiun.vmc.modules.account.business.PartnerInfoUtil;
	import com.vidiun.vmc.modules.account.model.AccountModelLocator;
	import com.vidiun.vmc.modules.account.vo.NotificationVO;
	import com.vidiun.vmc.modules.account.vo.PartnerVO;
	import com.vidiun.vo.VidiunPartner;
	
	import mx.collections.ArrayCollection;
	import mx.controls.Alert;
	import mx.resources.ResourceManager;
	import mx.rpc.IResponder;

	public class GetPartnerInfoCommand implements ICommand, IResponder {
		private var _model:AccountModelLocator = AccountModelLocator.getInstance();


		public function execute(event:CairngormEvent):void {
			//we only load the partner info 1 time in this app
			if (_model.partnerInfoLoaded)
				return;

			_model.loadingFlag = true;

			var getPartnerInfo:PartnerGetInfo = new PartnerGetInfo();
			getPartnerInfo.addEventListener(VidiunEvent.COMPLETE, result);
			getPartnerInfo.addEventListener(VidiunEvent.FAILED, fault);
			_model.context.vc.post(getPartnerInfo);
		}


		public function result(data:Object):void {
			_model.loadingFlag = false;
			if (data.data is VidiunPartner) {
				var resultVp:VidiunPartner = data.data as VidiunPartner;
				var pvo:PartnerVO = new PartnerVO;
				pvo.partner = resultVp;

				pvo.partnerId = _model.context.vc.partnerId;
				pvo.subPId = _model.context.subpId;

				PartnerInfoUtil.createNotificationArray(resultVp.notificationsConfig, pvo.notifications);

				_model.partnerData = pvo;
			}
			_model.partnerInfoLoaded = true;
		}


		public function fault(info:Object):void {
			if (info && info.error && info.error.errorMsg && info.error.errorMsg.toString().indexOf("Invalid VS") > -1) {
				JSGate.expired();
				return;
			}
			Alert.show(ResourceManager.getInstance().getString('account', 'notLoadPartnerData'), ResourceManager.getInstance().getString('account', 'error'));
			_model.loadingFlag = false;
		}


	}
}
