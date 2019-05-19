package com.vidiun.vmc.modules.admin.control.commands
{
	import com.adobe.cairngorm.control.CairngormEvent;
	import com.vidiun.commands.MultiRequest;
	import com.vidiun.commands.userRole.UserRoleDelete;
	import com.vidiun.commands.userRole.UserRoleList;
	import com.vidiun.events.VidiunEvent;
	import com.vidiun.vmc.modules.admin.control.events.RoleEvent;
	import com.vidiun.net.VidiunCall;
	import com.vidiun.vo.VidiunUserRoleListResponse;
	
	import mx.collections.ArrayCollection;
	import mx.controls.Alert;
	import mx.resources.IResourceManager;
	import mx.resources.ResourceManager;

	public class DeleteRoleCommand extends BaseCommand {
		
		override public function execute(event:CairngormEvent):void {
			var mr:MultiRequest = new MultiRequest();
			// delete
			var call:VidiunCall = new UserRoleDelete((event as RoleEvent).role.id);
			mr.addAction(call);
			// list
			call = new UserRoleList(_model.rolesModel.rolesFilter);
			mr.addAction(call);
			
			// post
			mr.addEventListener(VidiunEvent.COMPLETE, result);
			mr.addEventListener(VidiunEvent.FAILED, fault);
			_model.increaseLoadCounter();
			_model.vc.post(mr);
		}
		
		override protected function result(data:Object):void {
			// note the optional response of "still have users associated with role"
			super.result(data);
			
			if (data.data[0].error && data.data[0].error.code == "ROLE_IS_BEING_USED") {
				var rm:IResourceManager = ResourceManager.getInstance(); 
				Alert.show(rm.getString('admin', 'role_in_use'), rm.getString('admin', 'error')) ;
			}
			
			var response:VidiunUserRoleListResponse = data.data[1] as VidiunUserRoleListResponse;
			_model.rolesModel.roles = new ArrayCollection(response.objects);
			_model.decreaseLoadCounter();
		}
	}
}