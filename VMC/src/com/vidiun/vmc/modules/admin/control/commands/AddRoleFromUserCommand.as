package com.vidiun.vmc.modules.admin.control.commands
{
	import com.adobe.cairngorm.control.CairngormEvent;
	import com.vidiun.commands.MultiRequest;
	import com.vidiun.commands.userRole.UserRoleAdd;
	import com.vidiun.commands.userRole.UserRoleList;
	import com.vidiun.events.VidiunEvent;
	import com.vidiun.vmc.modules.admin.control.events.RoleEvent;
	import com.vidiun.vmc.modules.admin.model.DrilldownMode;
	import com.vidiun.net.VidiunCall;
	import com.vidiun.vo.VidiunUserRole;
	
	import mx.collections.ArrayCollection;

	public class AddRoleFromUserCommand extends BaseCommand {
		
		override public function execute(event:CairngormEvent):void {
			var mr:MultiRequest = new MultiRequest();
			mr.addEventListener(VidiunEvent.COMPLETE, result);
			mr.addEventListener(VidiunEvent.FAILED, fault);
			var call:VidiunCall = new UserRoleAdd((event as RoleEvent).role);
			mr.addAction(call);
			call = new UserRoleList(_model.rolesModel.rolesFilter);
			mr.addAction(call);
			_model.increaseLoadCounter();
			_model.vc.post(mr);
		}
		
		override protected function result(data:Object):void {
			super.result(data);
			if (data.success) {
				// change the flag to close the role drilldown
				// update the roles combobox dataprovider 
				_model.rolesModel.roles = new ArrayCollection(data.data[1].objects);
				// trigger the setter to use the returned object as the role for current user
				_model.usersModel.newRole = data.data[0] as VidiunUserRole;
				// just to trigger the closing:
				_model.usersModel.roleDrilldownMode = DrilldownMode.ADD;
				_model.usersModel.roleDrilldownMode = DrilldownMode.NONE;
			}
			_model.decreaseLoadCounter();
		}
	}
}