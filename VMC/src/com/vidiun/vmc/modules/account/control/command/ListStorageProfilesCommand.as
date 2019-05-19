package com.vidiun.vmc.modules.account.control.command
{
	import com.adobe.cairngorm.commands.ICommand;
	import com.adobe.cairngorm.control.CairngormEvent;
	import com.vidiun.VidiunClient;
	import com.vidiun.commands.storageProfile.StorageProfileList;
	import com.vidiun.edw.business.ClientUtil;
	import com.vidiun.events.VidiunEvent;
	import com.vidiun.vmc.business.JSGate;
	import com.vidiun.vmc.modules.account.model.AccountModelLocator;
	import com.vidiun.types.VidiunStorageProfileStatus;
	import com.vidiun.vo.VidiunFilter;
	import com.vidiun.vo.VidiunStorageProfile;
	import com.vidiun.vo.VidiunStorageProfileFilter;
	
	import mx.collections.ArrayCollection;
	import mx.controls.Alert;
	import mx.resources.ResourceManager;
	import mx.rpc.IResponder;

	public class ListStorageProfilesCommand implements ICommand, IResponder {
		
		private var _model : AccountModelLocator = AccountModelLocator.getInstance();
		
		public function execute(event:CairngormEvent):void {
			_model.loadingFlag = true;
			var f:VidiunStorageProfileFilter = new VidiunStorageProfileFilter();
			f.statusIn = VidiunStorageProfileStatus.AUTOMATIC + "," + VidiunStorageProfileStatus.MANUAL;
			var list:StorageProfileList = new StorageProfileList(f);
			list.addEventListener(VidiunEvent.COMPLETE, result);
			list.addEventListener(VidiunEvent.FAILED, fault);
			_model.context.vc.post(list);
		}
		
		public function result(event:Object):void {
			_model.loadingFlag = false;
			var temp:Array = new Array();
			// add the "none" object
			var rs:VidiunStorageProfile = new VidiunStorageProfile();
			rs.id = VidiunClient.NULL_INT; // same as "delete value" of the client
			rs.name = ResourceManager.getInstance().getString('account', 'n_a');
			temp.push(rs);
			// add the rest of the storages
			for each (var o:Object in event.data.objects) {
				if (!(o is VidiunStorageProfile)) {
					o = ClientUtil.createClassInstanceFromObject(VidiunStorageProfile, o);
				}
				temp.push(o);
			} 
			
			_model.storageProfiles = new ArrayCollection(temp);
		}
		
		public function fault(event:Object):void {
			_model.loadingFlag = false;
			if(event && event.error && event.error.errorMsg) {
				if(event.error.errorMsg.toString().indexOf("Invalid VS") > -1 ) {
					JSGate.expired();
				} else {
					Alert.show(event && event.error && event.error.errorMsg);
				}
			}
		}
	}
}