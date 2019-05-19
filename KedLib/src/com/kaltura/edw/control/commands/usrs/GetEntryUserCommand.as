package com.vidiun.edw.control.commands.usrs
{
	import com.vidiun.commands.user.UserGet;
	import com.vidiun.edw.control.commands.VedCommand;
	import com.vidiun.edw.control.events.UsersEvent;
	import com.vidiun.edw.model.datapacks.EntryDataPack;
	import com.vidiun.errors.VidiunError;
	import com.vidiun.events.VidiunEvent;
	import com.vidiun.vmvc.control.VMvCEvent;
	import com.vidiun.vo.VidiunUser;
	
	import mx.controls.Alert;
	import mx.resources.ResourceManager;

	public class GetEntryUserCommand extends VedCommand {
		
		private var _type:String;
		private var _userId:String;
		
		override public function execute(event:VMvCEvent):void {
			
			if (event.type == UsersEvent.RESET_ENTRY_USERS) {
				var edp:EntryDataPack = _model.getDataPack(EntryDataPack) as EntryDataPack;
				edp.selectedEntryCreator = null;
				edp.selectedEntryOwner = null;
				edp.entryEditors = null;
				edp.entryPublishers = null;
				return;
			}
			
			// otherwise, get the required user
			_type = event.type;
			_userId = event.data;
			
			_model.increaseLoadCounter();
			
			var getUser:UserGet = new UserGet(event.data);
			
			getUser.addEventListener(VidiunEvent.COMPLETE, result);
			getUser.addEventListener(VidiunEvent.FAILED, result);	// intentionally so
			
			_client.post(getUser);
		}
		
		
		
		override public function result(data:Object):void {
			super.result(data);
			
			var edp:EntryDataPack = _model.getDataPack(EntryDataPack) as EntryDataPack;
			if (data.data && data.data is VidiunUser) {
				switch (_type) {
					case UsersEvent.GET_ENTRY_CREATOR:
						edp.selectedEntryCreator = data.data as VidiunUser;
						break;
					
					case UsersEvent.GET_ENTRY_OWNER:
						edp.selectedEntryOwner = data.data as VidiunUser;
						break;
				}
			}
			else if (data.error) {
				var er:VidiunError = data.error;
				if (er.errorCode == "INVALID_USER_ID") {
					// the user is probably deleted, create a dummy user:
					var usr:VidiunUser = new VidiunUser();
					usr.id = _userId;
					usr.screenName = _userId;
					switch (_type) {
						case UsersEvent.GET_ENTRY_CREATOR:
							edp.selectedEntryCreator = usr;
							break;
						
						case UsersEvent.GET_ENTRY_OWNER:
							edp.selectedEntryOwner = usr;
							break;
					}
				}
				else {
					Alert.show(getErrorText(er), ResourceManager.getInstance().getString('drilldown', 'error'));
				}
			}
			_model.decreaseLoadCounter();
		}
	}
}