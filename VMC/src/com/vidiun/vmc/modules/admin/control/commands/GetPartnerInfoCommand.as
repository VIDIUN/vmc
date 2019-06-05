package com.vidiun.vmc.modules.admin.control.commands
{
	import com.adobe.cairngorm.control.CairngormEvent;
	import com.vidiun.commands.partner.PartnerGetInfo;
	import com.vidiun.events.VidiunEvent;
	import com.vidiun.vo.VidiunPartner;

	public class GetPartnerInfoCommand extends BaseCommand {
		
		override public function execute(event:CairngormEvent):void {
			var getPartnerInfo:PartnerGetInfo = new PartnerGetInfo();
			getPartnerInfo.addEventListener(VidiunEvent.COMPLETE, result);
			getPartnerInfo.addEventListener(VidiunEvent.FAILED, fault);
			_model.increaseLoadCounter();
			_model.vc.post(getPartnerInfo);	
		}
		
		override protected function result(data:Object):void {
			super.result(data);
			if (data.success) {
				_model.usersModel.loginUsersQuota = (data.data as VidiunPartner).adminLoginUsersQuota;
				_model.usersModel.adminUserId = (data.data as VidiunPartner).adminUserId;
				_model.usersModel.crippledUsers = [(data.data as VidiunPartner).adminUserId, _model.usersModel.currentUserInfo.user.id]; 
			}
			_model.decreaseLoadCounter();
		}
		
	}
}