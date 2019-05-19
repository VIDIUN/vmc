package com.vidiun.vmc.modules.admin.control.commands
{
	import com.adobe.cairngorm.control.CairngormEvent;
	import com.vidiun.commands.user.UserUpdate;
	import com.vidiun.events.VidiunEvent;
	import com.vidiun.vmc.modules.admin.control.events.UserEvent;
	import com.vidiun.vmc.modules.admin.model.DrilldownMode;
	import com.vidiun.vo.VidiunUser;
	
	import mx.controls.Alert;
	import mx.resources.ResourceManager;

	public class UpdateUserCommand extends BaseCommand {
		
		override public function execute(event:CairngormEvent):void {
			var user:VidiunUser = (event as UserEvent).user;
			user.setUpdatedFieldsOnly(true);
			var userId:String = _model.usersModel.selectedUser.id;
			if (!userId) {
				// will happen if upgrading an end user via "add user"
				userId = user.id;
			}
			var uu:UserUpdate = new UserUpdate(userId, user);
			uu.addEventListener(VidiunEvent.COMPLETE, result);
			uu.addEventListener(VidiunEvent.FAILED, fault);
			_model.increaseLoadCounter();
			_model.vc.post(uu);
		}
		
		override protected function result(data:Object):void {
			super.result(data);
			if (data.success) {
				_model.usersModel.drilldownMode = DrilldownMode.NONE;
			}
			_model.decreaseLoadCounter();
			Alert.show(ResourceManager.getInstance().getString('admin', 'after_user_edit')); 
		}
	}
}