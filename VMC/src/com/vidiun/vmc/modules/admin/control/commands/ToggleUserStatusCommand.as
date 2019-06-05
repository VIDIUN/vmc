package com.vidiun.vmc.modules.admin.control.commands
{
	import com.adobe.cairngorm.control.CairngormEvent;
	import com.vidiun.analytics.GoogleAnalyticsConsts;
	import com.vidiun.analytics.GoogleAnalyticsTracker;
	import com.vidiun.commands.MultiRequest;
	import com.vidiun.commands.user.UserList;
	import com.vidiun.commands.user.UserUpdate;
	import com.vidiun.events.VidiunEvent;
	import com.vidiun.vmc.modules.admin.control.events.UserEvent;
	import com.vidiun.net.VidiunCall;
	import com.vidiun.types.VidiunUserStatus;
	import com.vidiun.vo.VidiunUser;
	import com.vidiun.vo.VidiunUserListResponse;
	
	import mx.collections.ArrayCollection;

	public class ToggleUserStatusCommand extends BaseCommand {
		
		override public function execute(event:CairngormEvent):void {
			var mr:MultiRequest = new MultiRequest();
			// toggle
			var gaEvent:String;
			var usr:VidiunUser = (event as UserEvent).user;
			usr.setUpdatedFieldsOnly(true);
			if (usr.status == VidiunUserStatus.ACTIVE) {
				usr.status = VidiunUserStatus.BLOCKED;
				gaEvent = GoogleAnalyticsConsts.ADMIN_USER_BLOCK;
			}
			else if(usr.status == VidiunUserStatus.BLOCKED) {
				usr.status = VidiunUserStatus.ACTIVE;
				gaEvent = GoogleAnalyticsConsts.ADMIN_USER_UNBLOCK;
			}
			var call:VidiunCall = new UserUpdate(usr.id, usr);
			mr.addAction(call);
			// list
			call = new UserList(_model.usersModel.usersFilter);
			mr.addAction(call);
			// post
			mr.addEventListener(VidiunEvent.COMPLETE, result);
			mr.addEventListener(VidiunEvent.FAILED, fault);
			_model.increaseLoadCounter();
			_model.vc.post(mr);
			GoogleAnalyticsTracker.getInstance().sendToGA(GoogleAnalyticsConsts.PAGE_VIEW + gaEvent);
		}
		
		override protected function result(data:Object):void {
			super.result(data);
			var response:VidiunUserListResponse = data.data[1] as VidiunUserListResponse;
			_model.usersModel.users = new ArrayCollection(response.objects);
			_model.decreaseLoadCounter();
		}
	}
}