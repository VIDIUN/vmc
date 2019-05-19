package com.vidiun.vmc.modules.account.control.command
{
	import com.adobe.cairngorm.commands.ICommand;
	import com.adobe.cairngorm.control.CairngormEvent;
	import com.vidiun.commands.metadataProfile.MetadataProfileList;
	import com.vidiun.events.VidiunEvent;
	import com.vidiun.vmc.business.JSGate;
	import com.vidiun.vmc.modules.account.model.AccountModelLocator;
	import com.vidiun.vmc.utils.ListMetadataProfileUtil;
	import com.vidiun.types.VidiunMetadataObjectType;
	import com.vidiun.types.VidiunMetadataOrderBy;
	import com.vidiun.types.VidiunMetadataProfileCreateMode;
	import com.vidiun.utils.parsers.MetadataProfileParser;
	import com.vidiun.vo.VMCMetadataProfileVO;
	import com.vidiun.vo.VidiunFilterPager;
	import com.vidiun.vo.VidiunMetadataProfile;
	import com.vidiun.vo.VidiunMetadataProfileFilter;
	import com.vidiun.vo.VidiunMetadataProfileListResponse;
	
	import mx.collections.ArrayCollection;
	import mx.controls.Alert;
	import mx.resources.ResourceManager;
	import mx.rpc.IResponder;
	
	/**
	 * This class is used for sending MetadataProfileList requests 
	 * @author Michal
	 * 
	 */	
	public class ListMetadataProfileCommand implements ICommand, IResponder {
	
		private var _model:AccountModelLocator = AccountModelLocator.getInstance();
		

		/**
		 * This function sends a MetadataProfileList request, with filter and pager
		 * that will make it recieve only the last created profile 
		 * @param event the event that triggered this command
		 * 
		 */		
		public function execute(event:CairngormEvent):void
		{
			var filter:VidiunMetadataProfileFilter = new VidiunMetadataProfileFilter();
			filter.orderBy = VidiunMetadataOrderBy.CREATED_AT_DESC;
			filter.createModeNotEqual = VidiunMetadataProfileCreateMode.APP;
			filter.metadataObjectTypeIn = VidiunMetadataObjectType.ENTRY + "," + VidiunMetadataObjectType.CATEGORY;
			var listMetadataProfile:MetadataProfileList = new MetadataProfileList(filter, _model.metadataFilterPager);
			listMetadataProfile.addEventListener(VidiunEvent.COMPLETE, result);
			listMetadataProfile.addEventListener(VidiunEvent.FAILED, fault);
			_model.context.vc.post(listMetadataProfile);
		}
		
		/**
		 * This function handles the response from the server
		 * @param data the data returned from the server
		 * 
		 */		
		public function result(data:Object):void
		{
			//last request is always the list request
			var listResult:VidiunMetadataProfileListResponse  = data.data as VidiunMetadataProfileListResponse;
			_model.metadataProfilesTotalCount = listResult.totalCount;
			_model.metadataProfilesArray = ListMetadataProfileUtil.handleListMetadataResult(listResult, _model.context);
		}
		
		/**
		 * This function handles errors from the server 
		 * @param info the error from the server
		 * 
		 */		
		public function fault(info:Object):void
		{
			if(info && info.error && info.error.errorMsg && info.error.errorMsg.toString().indexOf("Invalid VS") > -1 )
			{
				JSGate.expired();
				return;
			}
			_model.loadingFlag = false;
			Alert.show(info.error.errorMsg, ResourceManager.getInstance().getString('account', 'error'));

		}
		
	}
}
