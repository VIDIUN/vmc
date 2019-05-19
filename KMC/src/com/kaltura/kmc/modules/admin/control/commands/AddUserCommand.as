package com.vidiun.vmc.modules.admin.control.commands
{
	import com.adobe.cairngorm.control.CairngormEvent;
	import com.vidiun.commands.user.UserAdd;
	import com.vidiun.events.VidiunEvent;
	import com.vidiun.vmc.modules.admin.control.events.ListItemsEvent;
	import com.vidiun.vmc.modules.admin.control.events.UserEvent;
	import com.vidiun.vmc.modules.admin.model.DrilldownMode;
	import com.vidiun.vo.VidiunUser;
	import com.vidiun.commands.user.UserGet;
	import mx.controls.Alert;
	import mx.resources.ResourceManager;
	import mx.events.CloseEvent;
	import com.vidiun.commands.user.UserEnableLogin;

	public class AddUserCommand extends BaseCommand {
		
		private var _user:VidiunUser;
		/**
		 * the email with which we will create the logindata for the user 
		 */
		private var _requiredLoginEmail:String; 
		
		override public function execute(event:CairngormEvent):void {
			// save user for future use
			_user = (event as UserEvent).user;
			// check if the user is listed as end user in the current account (VMS user etc)
			var ua:UserGet = new UserGet((event as UserEvent).user.id);
			ua.addEventListener(VidiunEvent.COMPLETE, getUserResult);
			ua.addEventListener(VidiunEvent.FAILED, getUserFault);
			_model.increaseLoadCounter();
			_model.vc.post(ua);
		}
		
		
		/**
		 * user is not yet listed in the current account, should add. 
		 * */
		private function getUserFault(data:VidiunEvent):void {
			if (data.error.errorCode == "INVALID_USER_ID") {
				addUser();
			}
		}
		
		
		/**
		 * user is already listed in the current account as end user, should update.
		 * */ 
		private function getUserResult(data:VidiunEvent):void {
			var role:String = _user.roleIds;
			_requiredLoginEmail = _user.email; // the email entered on screen
			
			_user = data.data as VidiunUser;
			_user.roleIds = role;
			var str:String = ResourceManager.getInstance().getString('admin', 'user_exists_current_partner', [_user.id]);
			Alert.show(str, ResourceManager.getInstance().getString('admin', 'add_user_title'), Alert.YES|Alert.NO, null, closeHandler);
		}
		
		
		protected function closeHandler(e:CloseEvent):void {
			switch (e.detail) {
				case Alert.YES:
					updateUser();
					break;
				case Alert.NO:
					// do nothing
					break;
			}
			_model.decreaseLoadCounter();
		}
		
		
		/**
		 * update permissions on existing user
		 * */
		private function updateUser():void {
			_user.isAdmin = true;
			var ue:UserEvent = new UserEvent(UserEvent.UPDATE_USER, _user);
			ue.dispatch();
			
			// enable user login
			var ua:UserEnableLogin = new UserEnableLogin(_user.id, _requiredLoginEmail, _user.password);
			ua.addEventListener(VidiunEvent.COMPLETE, enableLoginResult);
			ua.addEventListener(VidiunEvent.FAILED, fault);
			_model.vc.post(ua);
		}
		
		
		private function enableLoginResult(event:VidiunEvent):void {
			// do nothing.
		}
		
		private function addUser():void {
			var ua:UserAdd = new UserAdd(_user);
			ua.addEventListener(VidiunEvent.COMPLETE, addUserResult);
			ua.addEventListener(VidiunEvent.FAILED, fault);
			_model.vc.post(ua);
		}
		
		private function addUserResult(data:Object):void {
			super.result(data);
			if (data.success) {
				_model.usersModel.drilldownMode = DrilldownMode.NONE;
			}
			_model.decreaseLoadCounter();
		}
	}
}