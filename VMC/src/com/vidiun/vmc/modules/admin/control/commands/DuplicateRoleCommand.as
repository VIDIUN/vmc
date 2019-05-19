package com.vidiun.vmc.modules.admin.control.commands
{
	import com.adobe.cairngorm.control.CairngormEvent;
	import com.vidiun.commands.MultiRequest;
	import com.vidiun.commands.userRole.UserRoleClone;
	import com.vidiun.commands.userRole.UserRoleList;
	import com.vidiun.commands.userRole.UserRoleUpdate;
	import com.vidiun.events.VidiunEvent;
	import com.vidiun.vmc.modules.admin.control.events.RoleEvent;
	import com.vidiun.net.VidiunCall;
	import com.vidiun.utils.ObjectUtil;
	import com.vidiun.vo.VidiunUserRole;
	import com.vidiun.vo.VidiunUserRoleListResponse;
	
	import mx.collections.ArrayCollection;
	import mx.resources.ResourceManager;

	public class DuplicateRoleCommand extends BaseCommand {
		
		override public function execute(event:CairngormEvent):void {
			var mr:MultiRequest = new MultiRequest();
			var call:VidiunCall;
			var role:VidiunUserRole = (event as RoleEvent).role; 
			// pass result of first call to second call
//			mr.addRequestParam("2:userRoleId", "{1:result:id}");
			mr.mapMultiRequestParam(1, "id", 2, "userRoleId");
			mr.addRequestParam("2:userRole:name", ResourceManager.getInstance().getString('admin', 'duplicate_name', [role.name]));
			// duplicate the role
			call = new UserRoleClone(role.id);
			mr.addAction(call);
			// edit new role's name (both params are dummy, real value is taken from the first call
			call = new UserRoleUpdate(5, new VidiunUserRole());
			mr.addAction(call);
			
			// list
			call = new UserRoleList(_model.rolesModel.rolesFilter);
			mr.addAction(call);
			// post
			mr.addEventListener(VidiunEvent.COMPLETE, result);
			mr.addEventListener(VidiunEvent.FAILED, fault);
			mr.queued = false;
			_model.increaseLoadCounter();
			_model.vc.post(mr);
		}
		
		override protected function result(data:Object):void {
			super.result(data);
			// select the new role
			_model.rolesModel.selectedRole = data.data[1] as VidiunUserRole;
			// open drilldown for returned VidiunRole
			_model.rolesModel.newRole = data.data[1] as VidiunUserRole;
			_model.rolesModel.newRole = null;
			
			var response:VidiunUserRoleListResponse = data.data[2] as VidiunUserRoleListResponse;
			_model.rolesModel.roles = new ArrayCollection(response.objects);
			_model.decreaseLoadCounter();
		} 
	}
}