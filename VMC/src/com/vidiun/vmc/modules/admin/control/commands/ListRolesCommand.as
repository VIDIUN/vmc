package com.vidiun.vmc.modules.admin.control.commands
{
	import com.adobe.cairngorm.control.CairngormEvent;
	import com.vidiun.commands.userRole.UserRoleList;
	import com.vidiun.events.VidiunEvent;
	import com.vidiun.vmc.modules.admin.control.events.ListItemsEvent;
	import com.vidiun.vo.VidiunUserRoleFilter;
	import com.vidiun.vo.VidiunUserRoleListResponse;
	
	import mx.collections.ArrayCollection;

	public class ListRolesCommand extends BaseCommand {
		
		/**
		 * @inheritDocs
		 */
		override public function execute(event:CairngormEvent):void {
			var e:ListItemsEvent = event as ListItemsEvent;
			var ul:UserRoleList = new UserRoleList(e.filter as VidiunUserRoleFilter, e.pager);
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
			var response:VidiunUserRoleListResponse = data.data as VidiunUserRoleListResponse;
			_model.rolesModel.roles = new ArrayCollection(response.objects);
			_model.rolesModel.totalRoles = response.totalCount;
			_model.decreaseLoadCounter();
		}
		
	}
}