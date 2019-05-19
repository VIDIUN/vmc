package com.vidiun.vmc.modules.account.control.command {
	import com.adobe.cairngorm.commands.ICommand;
	import com.adobe.cairngorm.control.CairngormEvent;
	import com.vidiun.commands.MultiRequest;
	import com.vidiun.commands.metadataProfile.MetadataProfileDelete;
	import com.vidiun.commands.metadataProfile.MetadataProfileList;
	import com.vidiun.events.VidiunEvent;
	import com.vidiun.vmc.business.JSGate;
	import com.vidiun.vmc.modules.account.control.events.MetadataProfileEvent;
	import com.vidiun.vmc.modules.account.model.AccountModelLocator;
	import com.vidiun.vmc.utils.ListMetadataProfileUtil;
	import com.vidiun.types.VidiunMetadataObjectType;
	import com.vidiun.types.VidiunMetadataOrderBy;
	import com.vidiun.types.VidiunMetadataProfileCreateMode;
	import com.vidiun.utils.parsers.MetadataProfileParser;
	import com.vidiun.vo.VMCMetadataProfileVO;
	import com.vidiun.vo.VidiunMetadataProfile;
	import com.vidiun.vo.VidiunMetadataProfileFilter;
	import com.vidiun.vo.VidiunMetadataProfileListResponse;
	
	import mx.collections.ArrayCollection;
	import mx.controls.Alert;
	import mx.events.CloseEvent;
	import mx.resources.IResourceManager;
	import mx.resources.ResourceManager;
	import mx.rpc.IResponder;

	/**
	 * This class handles the deletion of a custom data schema
	 * @author Michal
	 *
	 */
	public class DeleteMetadataProfileCommand implements ICommand, IResponder {

		private var _model:AccountModelLocator = AccountModelLocator.getInstance();

		private var _profs:Array;

		public function execute(event:CairngormEvent):void {
			var rm:IResourceManager = ResourceManager.getInstance();
			_profs = (event as MetadataProfileEvent).profilesArray;
		
			if (_profs.length == 0) {
				Alert.show(rm.getString('account', 'customSchemaDeleteError'), rm.getString('account', 'customSchemaDeleteErrorTitle'));
				return;
			}
			
			var delStr:String = '';
			for each (var item:Object in _profs) {
				delStr += '\n' + (item as VMCMetadataProfileVO).profile.name;
			}
			
			Alert.show(rm.getString('account', 'metadataSchemaDeleteAlert', [delStr]), rm.getString('account', 'metadataSchemaDeleteTitle'), Alert.YES | Alert.NO, null, deleteResponseFunc);
		}
		
		
		private function deleteResponseFunc(event:CloseEvent):void {
			if (event.detail == Alert.YES) {
				_model.loadingFlag = true;
				
				var mr:MultiRequest = new MultiRequest();
				
				for each (var profile:VMCMetadataProfileVO in _profs) {
					var deleteSchema:MetadataProfileDelete = new MetadataProfileDelete(profile.profile.id);
					mr.addAction(deleteSchema);
				}
				
				// list the latest metadata profiles (after all deletion is done)s
				var filter:VidiunMetadataProfileFilter = new VidiunMetadataProfileFilter();
				filter.orderBy = VidiunMetadataOrderBy.CREATED_AT_DESC;
				filter.createModeNotEqual = VidiunMetadataProfileCreateMode.APP;
				filter.metadataObjectTypeIn = VidiunMetadataObjectType.ENTRY + "," + VidiunMetadataObjectType.CATEGORY;
				var listMetadataProfile:MetadataProfileList = new MetadataProfileList(filter, _model.metadataFilterPager);
				mr.addAction(listMetadataProfile);
				
				mr.addEventListener(VidiunEvent.COMPLETE, result);
				mr.addEventListener(VidiunEvent.FAILED, fault);
				
				_model.context.vc.post(mr);
			}
		}

		/**
		 * Will be called when the result from the server returns
		 * @param data the data recieved from the server
		 *
		 */
		public function result(data:Object):void {
			_model.loadingFlag = false;
			var responseArray:Array = data.data as Array;
			// last request is always the list request
			var listResult:VidiunMetadataProfileListResponse = responseArray[responseArray.length - 1] as VidiunMetadataProfileListResponse;
			_model.metadataProfilesTotalCount = listResult.totalCount;
			_model.metadataProfilesArray = ListMetadataProfileUtil.handleListMetadataResult(listResult, _model.context);
		}


		/**
		 * Will be called when the request fails
		 * @param info the info from the server
		 *
		 */
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
