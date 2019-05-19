package com.vidiun.vmc.modules.admin.control.commands
{
	import com.adobe.cairngorm.control.CairngormEvent;
	import com.vidiun.commands.permission.PermissionList;
	import com.vidiun.events.VidiunEvent;
	import com.vidiun.vo.VidiunFilterPager;
	import com.vidiun.vo.VidiunPermission;
	import com.vidiun.vo.VidiunPermissionListResponse;
	
	public class ListPartnerPermissionsCommand extends BaseCommand {
		
		/**
		 * @inheritDocs
		 */
		override public function execute(event:CairngormEvent):void {
			var largePager:VidiunFilterPager = new VidiunFilterPager();
			largePager.pageSize = 500;
			var ul:PermissionList = new PermissionList(_model.rolesModel.permissionsFilter, largePager);
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
			var response:VidiunPermissionListResponse = data.data as VidiunPermissionListResponse;
			_model.rolesModel.partnerPermissions = parsePartnerPermissions(response);
			_model.decreaseLoadCounter();
		}
		
		
		/**
		 * parse the permissions list response
		 * @param klr	the permissions list response
		 * @return a comma separated string of partner permission ids.
		 * */
		protected function parsePartnerPermissions(klr:VidiunPermissionListResponse):String {
			var result:String = '';
			for each (var vperm:VidiunPermission in klr.objects) {
				result += vperm.name + ",";
			}
			// remove last ","
			result = result.substring(0, result.length - 1);
			return result;
		}
	}
}