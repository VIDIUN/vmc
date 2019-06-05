package com.vidiun.vmc.modules.account.control.command {
	import com.adobe.cairngorm.commands.ICommand;
	import com.adobe.cairngorm.control.CairngormEvent;
	import com.vidiun.VidiunClient;
	import com.vidiun.commands.MultiRequest;
	import com.vidiun.commands.conversionProfile.ConversionProfileUpdate;
	import com.vidiun.commands.conversionProfileAssetParams.ConversionProfileAssetParamsUpdate;
	import com.vidiun.errors.VidiunError;
	import com.vidiun.events.VidiunEvent;
	import com.vidiun.vmc.business.JSGate;
	import com.vidiun.vmc.modules.account.control.events.ConversionSettingsEvent;
	import com.vidiun.vmc.modules.account.model.AccountModelLocator;
	import com.vidiun.vmc.modules.account.vo.ConversionProfileVO;
	import com.vidiun.vo.VidiunConversionProfile;
	import com.vidiun.vo.VidiunConversionProfileAssetParams;
	
	import mx.controls.Alert;
	import mx.resources.ResourceManager;
	import mx.rpc.IResponder;

	public class UpdateConversionProfileCommand implements ICommand, IResponder {
		private var _model:AccountModelLocator = AccountModelLocator.getInstance();
		
		private var _nextEvent:CairngormEvent;


		public function execute(event:CairngormEvent):void {
			_nextEvent = (event as ConversionSettingsEvent).nextEvent;
			
			var cProfile:ConversionProfileVO = event.data as ConversionProfileVO;

			var mr:MultiRequest = new MultiRequest();

			var id:int = cProfile.profile.id;
			var updateProfile:VidiunConversionProfile = cProfile.profile; //prepareForUpdate(profileVo.profile);
			if (updateProfile.flavorParamsIds == null) {
				updateProfile.flavorParamsIds = VidiunClient.NULL_STRING;
			}
			updateProfile.setUpdatedFieldsOnly(true);
			var cpu:ConversionProfileUpdate = new ConversionProfileUpdate(cProfile.profile.id, updateProfile);
			mr.addAction(cpu);

			var cpapu:ConversionProfileAssetParamsUpdate;
			// see if any conversion flavours need to be updated:
			for each (var cpap:VidiunConversionProfileAssetParams in cProfile.flavors) {
				if (cpap.dirty) {
					cpap.setUpdatedFieldsOnly(true);
					cpapu = new ConversionProfileAssetParamsUpdate(id, cpap.assetParamsId, cpap);
					mr.addAction(cpapu);
				}
			}


			mr.addEventListener(VidiunEvent.COMPLETE, result);
			mr.addEventListener(VidiunEvent.FAILED, fault);
			_model.context.vc.post(mr);
		}


		public function result(event:Object):void {
			_model.loadingFlag = false;

			var er:Object;
			for (var i:int = 0; i < event.data.length; i++) {
				er = event.data[i].error;
				if (er) {
					Alert.show(er.message, ResourceManager.getInstance().getString('account', 'error'));
					break;
				}
			}
			if (!er) {
				Alert.show(ResourceManager.getInstance().getString('account', 'changesSaved'));
			}

			if (_nextEvent) {
				_nextEvent.dispatch();
			}
		}


		public function fault(info:Object):void {
			_model.loadingFlag = false;
			if (info && info.error && info.error.errorMsg) {
				if (info.error.errorMsg.toString().indexOf("Invalid VS") > -1) {
					JSGate.expired();
				} 
				else {
					Alert.show(info && info.error && info.error.errorMsg);
					var getAllProfilesEvent:ConversionSettingsEvent = new ConversionSettingsEvent(ConversionSettingsEvent.LIST_CONVERSION_PROFILES);
					getAllProfilesEvent.dispatch();
				}
			}
		}

	}
}