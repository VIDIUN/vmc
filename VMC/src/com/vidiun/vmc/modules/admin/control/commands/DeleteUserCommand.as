package com.vidiun.vmc.modules.admin.control.commands
{
	import com.adobe.cairngorm.control.CairngormEvent;
	import com.vidiun.commands.MultiRequest;
	import com.vidiun.commands.user.UserDelete;
	import com.vidiun.commands.user.UserList;
	import com.vidiun.events.VidiunEvent;
	import com.vidiun.vmc.modules.admin.control.events.UserEvent;
	import com.vidiun.net.VidiunCall;
	import com.vidiun.vo.VidiunUserListResponse;
	
	import mx.collections.ArrayCollection;

	public class DeleteUserCommand extends BaseCommand {
		
		override public function execute(event:CairngormEvent):void {
			var mr:MultiRequest = new MultiRequest();
			// delete
			var call:VidiunCall = new UserDelete((event as UserEvent).user.id);
			mr.addAction(call);
			// list
			call = new UserList(_model.usersModel.usersFilter);
			mr.addAction(call);
			// post
			mr.addEventListener(VidiunEvent.COMPLETE, result);
			mr.addEventListener(VidiunEvent.FAILED, fault);
			_model.increaseLoadCounter();
			_model.vc.post(mr);
		}
		
		override protected function result(data:Object):void {
			super.result(data);
			var response:VidiunUserListResponse = data.data[1] as VidiunUserListResponse;
			_model.usersModel.users = new ArrayCollection(response.objects);
			// users quota
			_model.usersModel.totalUsers = response.totalCount;
			_model.decreaseLoadCounter();
		}
	}
}