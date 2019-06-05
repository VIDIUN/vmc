package com.vidiun.vmc.modules.admin.control.commands
{
	import com.adobe.cairngorm.control.CairngormEvent;
	import com.vidiun.commands.userRole.UserRoleUpdate;
	import com.vidiun.events.VidiunEvent;
	import com.vidiun.vmc.modules.admin.control.events.RoleEvent;
	import com.vidiun.vmc.modules.admin.model.DrilldownMode;
	import com.vidiun.vo.VidiunUserRole;
	
	import mx.controls.Alert;
	import mx.resources.ResourceManager;

	/**
	 * update a role after editing it. 
	 * @author Atar
	 * 
	 */	
	public class UpdateRoleCommand extends BaseCommand {
		
		override public function execute(event:CairngormEvent):void {
			var role:VidiunUserRole = (event as RoleEvent).role;
			role.setUpdatedFieldsOnly(true);
			var uu:UserRoleUpdate = new UserRoleUpdate(role.id, role);
			uu.addEventListener(VidiunEvent.COMPLETE, result);
			uu.addEventListener(VidiunEvent.FAILED, fault);
			_model.increaseLoadCounter();
			_model.vc.post(uu);
		}
		
		
		override protected function result(data:Object):void {
			super.result(data);
			if (data.success) {
				// no need to explicitly call list roles, as 
				// data is refreshed when the window closes. 
				_model.rolesModel.drilldownMode = DrilldownMode.NONE;
			}
			_model.decreaseLoadCounter();
			Alert.show(ResourceManager.getInstance().getString('admin', 'after_role_edit'));
		}
	}
}