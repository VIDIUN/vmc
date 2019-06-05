package com.vidiun.vmc.modules.admin.control.commands
{
	import com.adobe.cairngorm.control.CairngormEvent;
	import com.vidiun.commands.user.UserList;
	import com.vidiun.events.VidiunEvent;
	import com.vidiun.vmc.modules.admin.control.events.ListItemsEvent;
	import com.vidiun.vo.VidiunUser;
	import com.vidiun.vo.VidiunUserFilter;
	import com.vidiun.vo.VidiunUserListResponse;
	
	import mx.collections.ArrayCollection;

	public class ListUsersCommand extends BaseCommand {
		
		/**
		 * @inheritDocs
		 */
		override public function execute(event:CairngormEvent):void {
			var e:ListItemsEvent = event as ListItemsEvent;
			var ul:UserList = new UserList(e.filter as VidiunUserFilter, e.pager);
			ul.addEventListener(VidiunEvent.COMPLETE, result);
			ul.addEventListener(VidiunEvent.FAILED, fault);
			if (_model.vc) {
				_model.increaseLoadCounter();
				_model.vc.post(ul);
			}
		}
		
		
		
		/**
		 * set received data on model
		 * @param data data returned from server.
		 */
		override protected function result(data:Object):void {
			super.result(data);
			var response:VidiunUserListResponse = data.data as VidiunUserListResponse;
			var resultArray:ArrayCollection = new ArrayCollection(response.objects);
			setOwnerFirstInArray(resultArray);
			_model.usersModel.users = resultArray;
			_model.usersModel.totalUsers = response.totalCount;
			_model.decreaseLoadCounter();
		}
		
		/**
		 * sets the owner user to be the first user
		 * */
		private function setOwnerFirstInArray(arr:ArrayCollection):void {
			for (var i:int = 0; i<arr.length; i++){
				var user:VidiunUser = arr.getItemAt(i) as VidiunUser;
				if (user.isAccountOwner) {
					arr.removeItemAt(i);
					arr.addItemAt(user,0);
					return;
				}
			}
			
		}
	}
}