package com.vidiun.vmc.modules.account.control.command {
	import com.adobe.cairngorm.commands.ICommand;
	import com.adobe.cairngorm.control.CairngormEvent;
	import com.vidiun.commands.accessControl.AccessControlList;
	import com.vidiun.events.VidiunEvent;
	import com.vidiun.vmc.business.JSGate;
	import com.vidiun.vmc.modules.account.model.AccountModelLocator;
	import com.vidiun.vo.AccessControlProfileVO;
	import com.vidiun.vo.VidiunAccessControl;
	import com.vidiun.vo.VidiunAccessControlListResponse;
	import com.vidiun.vo.VidiunBaseRestriction;

	import mx.collections.ArrayCollection;
	import mx.controls.Alert;
	import mx.resources.ResourceManager;
	import mx.rpc.IResponder;

	public class ListAccessControlsCommand implements ICommand, IResponder {
		private var _model:AccountModelLocator = AccountModelLocator.getInstance();


		public function execute(event:CairngormEvent):void {
			if (_model.filterPager) {
				var getListAccessControlProfiles:AccessControlList = new AccessControlList(_model.acpFilter, _model.filterPager);
				getListAccessControlProfiles.addEventListener(VidiunEvent.COMPLETE, result);
				getListAccessControlProfiles.addEventListener(VidiunEvent.FAILED, fault);
				_model.context.vc.post(getListAccessControlProfiles);
			}
		}


		public function result(data:Object):void {
			_model.loadingFlag = false;

			if (data.success) {
				var tempArr:ArrayCollection = new ArrayCollection();
				var response:VidiunAccessControlListResponse = data.data as VidiunAccessControlListResponse;
				_model.accessControlProfilesTotalCount = response.totalCount;
				_model.accessControls = new ArrayCollection();
				for each (var vac:VidiunAccessControl in response.objects) {
					var acVo:AccessControlProfileVO = new AccessControlProfileVO();
					acVo.profile = vac;
					acVo.id = vac.id;
					if (vac.restrictions) {
						// remove unknown objects
						// if any restriction is unknown, we remove it from the list.
						// this means access control profiles with unknown restrictions CANNOT be edited in VMC,
						// as editing hem will delete the unknown restriction.
						for (var i:int = 0; i < vac.restrictions.length; i++) {
							if (!(vac.restrictions[i] is VidiunBaseRestriction)) {
								vac.restrictions.splice(i, 1);
							}
						}
					}
					if (acVo.profile.isDefault) {
						tempArr.addItemAt(acVo, 0);
					}
					else {
						tempArr.addItem(acVo);
					}
				}
				_model.accessControls = tempArr;
			}
			else {
				Alert.show(data.error, ResourceManager.getInstance().getString('account', 'error'));
			}

			//_model.partnerInfoLoaded = true;
		}


		public function fault(info:Object):void {
			if (info && info.error && info.error.errorMsg && info.error.errorMsg.toString().indexOf("Invalid VS") > -1) {
				JSGate.expired();
				return;
			}
			_model.loadingFlag = false;
			Alert.show(ResourceManager.getInstance().getString('account', 'notLoadAccessControl') + "\n\t" + info.error.errorMsg, ResourceManager.getInstance().getString('account', 'error'));
		}


	}
}
