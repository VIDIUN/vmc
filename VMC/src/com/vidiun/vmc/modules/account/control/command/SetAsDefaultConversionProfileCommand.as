package com.vidiun.vmc.modules.account.control.command
{
	import com.adobe.cairngorm.commands.ICommand;
	import com.adobe.cairngorm.control.CairngormEvent;
	import com.vidiun.commands.MultiRequest;
	import com.vidiun.commands.conversionProfile.ConversionProfileList;
	import com.vidiun.commands.conversionProfile.ConversionProfileSetAsDefault;
	import com.vidiun.commands.conversionProfileAssetParams.ConversionProfileAssetParamsList;
	import com.vidiun.errors.VidiunError;
	import com.vidiun.events.VidiunEvent;
	import com.vidiun.vmc.business.JSGate;
	import com.vidiun.vmc.modules.account.control.events.ConversionSettingsEvent;
	import com.vidiun.vmc.modules.account.model.AccountModelLocator;
	import com.vidiun.vmc.modules.account.utils.ListConversionProfilesUtil;
	import com.vidiun.vmc.modules.account.vo.ConversionProfileVO;
	import com.vidiun.types.VidiunConversionProfileType;
	import com.vidiun.vo.VidiunConversionProfile;
	import com.vidiun.vo.VidiunConversionProfileAssetParamsListResponse;
	import com.vidiun.vo.VidiunConversionProfileFilter;
	import com.vidiun.vo.VidiunConversionProfileListResponse;
	import com.vidiun.vo.VidiunFilterPager;
	
	import mx.controls.Alert;
	import mx.resources.ResourceManager;
	import mx.rpc.IResponder;
	
	public class SetAsDefaultConversionProfileCommand implements ICommand, IResponder
	{
		private var _model : AccountModelLocator = AccountModelLocator.getInstance();
		
		private var _nextEvent:CairngormEvent;
		
		public function execute(event:CairngormEvent):void {
			_model.loadingFlag = true;
			
			_nextEvent = (event as ConversionSettingsEvent).nextEvent;
			
			var cp:VidiunConversionProfile = event.data as VidiunConversionProfile;
			var setDefault:ConversionProfileSetAsDefault = new ConversionProfileSetAsDefault(cp.id);
			
			setDefault.addEventListener(VidiunEvent.COMPLETE, result);
			setDefault.addEventListener(VidiunEvent.FAILED, fault);
			
			_model.context.vc.post(setDefault);
		}
		
		
		public function result(event:Object):void {
			_model.loadingFlag = false;
			var er:VidiunError;
			if (event.error) {
				er = event.error as VidiunError;
				if (er) {
					Alert.show(er.errorMsg, ResourceManager.getInstance().getString('account', 'error'));
				}
			}
			if (_nextEvent) {
				_nextEvent.dispatch();
			}
		}
		
		
		public function fault(info:Object):void
		{
			_model.loadingFlag = false;
			if (info && info.error && info.error.errorMsg) {
				if (info.error.errorMsg.toString().indexOf("Invalid VS") > -1 ) {
					JSGate.expired();
				} 
				else {
					Alert.show(info && info.error && info.error.errorMsg);
					
				}
			}
		}
	}
}