package com.vidiun.vmc.modules.admin.control.events
{
	import com.adobe.cairngorm.control.CairngormEvent;
	import com.vidiun.vo.VidiunUserRole;
	
	public class RoleEvent extends CairngormEvent {
		
		public static const ADD_ROLE_FROM_USERS:String = "admin_addRoleFromUsers";
		public static const ADD_ROLE:String = "admin_addRole";
		public static const UPDATE_ROLE:String = "admin_updateRole";
		public static const DUPLICATE_ROLE:String = "admin_duplicateRole";
		public static const DELETE_ROLE:String = "admin_deleteRole";
		public static const SELECT_ROLE:String = "admin_selectRole";
		
		
		private var _role:VidiunUserRole;
		
		
		public function RoleEvent(type:String, role:VidiunUserRole = null, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
			_role = role;
		}
		
		public function get role():VidiunUserRole
		{
			return _role;
		}
	}
}