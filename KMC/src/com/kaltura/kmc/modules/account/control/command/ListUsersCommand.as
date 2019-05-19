package com.vidiun.vmc.modules.account.control.command {
	import com.adobe.cairngorm.commands.ICommand;
	import com.adobe.cairngorm.control.CairngormEvent;
	import com.vidiun.commands.MultiRequest;
	import com.vidiun.commands.user.UserList;
	import com.vidiun.commands.userRole.UserRoleList;
	import com.vidiun.edw.model.types.APIErrorCode;
	import com.vidiun.events.VidiunEvent;
	import com.vidiun.vmc.business.JSGate;
	import com.vidiun.vmc.modules.account.model.AccountModelLocator;
	import com.vidiun.types.VidiunNullableBoolean;
	import com.vidiun.types.VidiunUserRoleStatus;
	import com.vidiun.types.VidiunUserStatus;
	import com.vidiun.vo.VidiunUser;
	import com.vidiun.vo.VidiunUserFilter;
	import com.vidiun.vo.VidiunUserListResponse;
	import com.vidiun.vo.VidiunUserRoleFilter;
	import com.vidiun.vo.VidiunUserRoleListResponse;
	
	import flash.display.Graphics;
	
	import mx.collections.ArrayCollection;
	import mx.controls.Alert;
	import mx.core.Application;
	import mx.core.FlexSprite;
	import mx.resources.ResourceManager;
	import mx.rpc.IResponder;
	import mx.states.AddChild;

	public class ListUsersCommand implements ICommand {
		
		private var _model:AccountModelLocator = AccountModelLocator.getInstance();


		public function execute(event:CairngormEvent):void {
			var mr:MultiRequest = new MultiRequest();
			// roles
			var rfilter:VidiunUserRoleFilter = new VidiunUserRoleFilter();
			rfilter.tagsMultiLikeOr = 'partner_admin';
			rfilter.statusEqual = VidiunUserRoleStatus.ACTIVE;
			var rl:UserRoleList = new UserRoleList(rfilter);
			mr.addAction(rl);
			// users
			var ufilter:VidiunUserFilter = new VidiunUserFilter();
			ufilter.isAdminEqual = VidiunNullableBoolean.TRUE_VALUE;
			ufilter.loginEnabledEqual = VidiunNullableBoolean.TRUE_VALUE;
			ufilter.statusEqual = VidiunUserStatus.ACTIVE;
			ufilter.roleIdsEqual = '0';
			var ul:UserList = new UserList(ufilter);
			mr.addAction(ul);
			mr.mapMultiRequestParam(1, 'objects:0:id', 2, 'filter:roleIdsEqual');
			mr.addEventListener(VidiunEvent.COMPLETE, result);
			mr.addEventListener(VidiunEvent.FAILED, fault);
			mr.queued = false;	// so numbering won't get messed up
			_model.context.vc.post(mr);
		}


		private function result(event:VidiunEvent):void {
			// error handling
			if(event && event.error && event.error.errorMsg && event.error.errorCode == APIErrorCode.INVALID_VS){
				JSGate.expired();
				return;
			}
			
			if (event.data && event.data.length > 0) {
				var l:int = event.data.length ;
				for(var i:int = 0; i<l; i++) {
					if (event.data[i].error && event.data[i].error.code) {
						Alert.show(event.data[i].error.message, ResourceManager.getInstance().getString('account', 'error'));
						return;
					}
				}
			}
			_model.usersList = new ArrayCollection((event.data[1] as VidiunUserListResponse).objects);
		}


		private function fault(event:VidiunEvent):void {
			if (event.error) {
				Alert.show(event.error.errorMsg, ResourceManager.getInstance().getString('account', 'error'));
			}
		}
	}
}