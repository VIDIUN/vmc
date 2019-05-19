package com.vidiun.vmc.modules.analytics.commands {
	import com.adobe.cairngorm.commands.ICommand;
	import com.adobe.cairngorm.control.CairngormEvent;
	import com.vidiun.commands.partner.PartnerGetInfo;
	import com.vidiun.events.VidiunEvent;
	import com.vidiun.vmc.modules.analytics.model.AnalyticsModelLocator;
	import com.vidiun.vmc.modules.analytics.vo.NotificationVO;
	import com.vidiun.vmc.modules.analytics.vo.PartnerVO;
	import com.vidiun.vo.VidiunPartner;
	
	import mx.collections.ArrayCollection;
	import mx.controls.Alert;
	import mx.resources.ResourceManager;
	import mx.rpc.IResponder;

	public class GetPartnerInfoCommand implements ICommand, IResponder {
		private var _model:AnalyticsModelLocator = AnalyticsModelLocator.getInstance();


		public function execute(event:CairngormEvent):void {
			//we only load the partner info 1 time in this app
			if (_model.partnerInfoLoaded)
				return;

			_model.loadingFlag = true;
			_model.loadingPartnerInfo = true;

			var getPartnerInfo:PartnerGetInfo = new PartnerGetInfo();
			getPartnerInfo.addEventListener(VidiunEvent.COMPLETE, result);
			getPartnerInfo.addEventListener(VidiunEvent.FAILED, fault);
			_model.vc.post(getPartnerInfo);
		}


		public function result(data:Object):void {
			_model.loadingPartnerInfo = false;
			_model.checkLoading();
			if (data.data is VidiunPartner) {
				var resultVp:VidiunPartner = data.data as VidiunPartner;
				var pvo:PartnerVO = new PartnerVO;
				pvo.subPId = _model.context.subpId;

				pvo.adminEmail = resultVp.adminEmail;
				pvo.adminName = resultVp.adminName;
				pvo.adultContent = resultVp.adultContent;
				//		pvo.allowEmptyField = resultVp.;
				//		pvo.allowMultiNotification = resultVp.;
				pvo.allowQuickEdit = resultVp.allowQuickEdit == 1;
				pvo.appearInSearch = resultVp.appearInSearch;
				pvo.commercialUse = int(resultVp.commercialUse);
				pvo.contentCategories = (resultVp.contentCategories == null) ? '' : resultVp.contentCategories;
				pvo.createdAt = resultVp.createdAt;

				//var dateArr : Array = (pvo.createdAt).split('-');
				var date:Date = new Date((pvo.createdAt) * 1000);

				pvo.createdYear = date.fullYear;
				pvo.createdMonth = date.month;
				pvo.createdDay = date.date;

				pvo.defConversionProfileType = resultVp.defConversionProfileType;
				pvo.describeYourself = resultVp.describeYourself;
				pvo.description = resultVp.description;
				pvo.landingPage = resultVp.landingPage;
				pvo.maxUploadSize = resultVp.maxUploadSize;
				pvo.mergeEntryLists = resultVp.mergeEntryLists == 1;
				pvo.name = resultVp.name;
				pvo.notificationsConfig = resultVp.notificationsConfig;
				//pvo.notifications  
				createNotificationArray(resultVp.notificationsConfig, pvo.notifications);
				pvo.notify = resultVp.notify == 1;
				pvo.partnerPackage = resultVp.partnerPackage;
				pvo.phone = resultVp.phone;
				pvo.pId = _model.vc.partnerId;
				pvo.secret = resultVp.secret;
				pvo.status = resultVp.status;
				pvo.type = resultVp.type;
				pvo.url1 = resultVp.website;
				pvo.url2 = resultVp.notificationUrl;
				pvo.userLandingPage = resultVp.userLandingPage;

				_model.partnerData = pvo;
			}
			_model.partnerInfoLoaded = true;
		}


		public function fault(info:Object):void {
			Alert.show(ResourceManager.getInstance().getString('analytics', 'notLoadPartnerData'), ResourceManager.getInstance().getString('analytics', 'error'));
			_model.loadingPartnerInfo = false;
			_model.checkLoading();
		}


		private function createNotificationArray(str:String, arrCol:ArrayCollection):void {
			if (str == null) {
				return;
			}

			str = (str == null) ? '' : str;

			var tempNotiArray:Array = str.split(";");
			var i:int = 0;
			switch (tempNotiArray[0]) //set the notification to *=0 and make the changes needed
			{
				case "*=0":
					for (i = 0; i < arrCol.length; i++) {
						(arrCol[i] as NotificationVO).availableInClient = false;
						(arrCol[i] as NotificationVO).availableInServer = false;
					}
					break; //all off
				case "*=1": //all server on
					for (i = 0; i < arrCol.length; i++) {
						(arrCol[i] as NotificationVO).availableInClient = false;
						(arrCol[i] as NotificationVO).availableInServer = true;
					}
					break;
				case "*=2": //all client on
					for (i = 0; i < arrCol.length; i++) {
						(arrCol[i] as NotificationVO).availableInClient = false;
						(arrCol[i] as NotificationVO).availableInServer = true;
					}
					break;
				case "*=3":
					for (i = 0; i < arrCol.length; i++) {
						(arrCol[i] as NotificationVO).availableInClient = true;
						(arrCol[i] as NotificationVO).availableInServer = true;
					}
					break; //all on
			}

			for (i = 1; i < tempNotiArray.length; i++) {
				var keyValArr:Array = tempNotiArray[i].split("=");
				for (var j:int = 0; j < arrCol.length; j++) {
					if ((arrCol[j] as NotificationVO).nId == keyValArr[0]) {
						switch (keyValArr[1]) {
							case "0":
								(arrCol[j] as NotificationVO).availableInClient = false;
								(arrCol[j] as NotificationVO).availableInServer = false;
								break;
							case "1":
								(arrCol[j] as NotificationVO).availableInClient = false;
								(arrCol[j] as NotificationVO).availableInServer = true;
								break;
							case "2":
								(arrCol[j] as NotificationVO).availableInClient = true;
								(arrCol[j] as NotificationVO).availableInServer = false;
								break;
							case "3":
								(arrCol[j] as NotificationVO).availableInClient = true;
								(arrCol[j] as NotificationVO).availableInServer = true;
								break;
						}
					}
				}
			}
		}


	}
}
