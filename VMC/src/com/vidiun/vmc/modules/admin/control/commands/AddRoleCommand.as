package com.vidiun.vmc.modules.admin.control.commands
{
	import com.adobe.cairngorm.control.CairngormEvent;
	import com.vidiun.commands.userRole.UserRoleAdd;
	import com.vidiun.events.VidiunEvent;
	import com.vidiun.vmc.modules.admin.control.events.RoleEvent;
	import com.vidiun.vmc.modules.admin.model.DrilldownMode;

	public class AddRoleCommand extends BaseCommand {
		
		override public function execute(event:CairngormEvent):void {
			var ua:UserRoleAdd = new UserRoleAdd((event as RoleEvent).role);
			ua.addEventListener(VidiunEvent.COMPLETE, result);
			ua.addEventListener(VidiunEvent.FAILED, fault);
			_model.increaseLoadCounter();
			_model.vc.post(ua);
		}
		
		override protected function result(data:Object):void {
			super.result(data);
			if (data.success) {
				_model.rolesModel.drilldownMode = DrilldownMode.NONE;
			}
			_model.decreaseLoadCounter();
		}
	}
}