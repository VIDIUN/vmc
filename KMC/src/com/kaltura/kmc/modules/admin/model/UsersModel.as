package com.vidiun.vmc.modules.admin.model
{
	import com.vidiun.vmc.vo.UserVO;
	import com.vidiun.types.VidiunNullableBoolean;
	import com.vidiun.types.VidiunUserOrderBy;
	import com.vidiun.types.VidiunUserStatus;
	import com.vidiun.vo.VidiunUser;
	import com.vidiun.vo.VidiunUserFilter;
	import com.vidiun.vo.VidiunUserRole;
	
	import mx.collections.ArrayCollection;

	[Bindable]
	public class UsersModel {
		
		public function UsersModel() {
			// init filter - only admin users who have access to VMC and are either active or blocked.
			usersFilter = new VidiunUserFilter();
			usersFilter.isAdminEqual = VidiunNullableBoolean.TRUE_VALUE;
			usersFilter.loginEnabledEqual = VidiunNullableBoolean.TRUE_VALUE;
			usersFilter.statusIn = VidiunUserStatus.ACTIVE + "," + VidiunUserStatus.BLOCKED;
			usersFilter.orderBy = VidiunUserOrderBy.CREATED_AT_ASC;
		}
		
		/**
		 * info about the current (active) user 
		 */		
		public var currentUserInfo:UserVO;
		
		/**
		 * the active user entry.
		 * */
		public var selectedUser:VidiunUser;
		
		[ArrayElementType("VidiunUser")]
		/**
		 * a list of all users (VidiunUser objects)
		 * */
		public var users:ArrayCollection;
		
		/**
		 * total number of users as indicated by list result 
		 */		
		public var totalUsers:int;
		
		/**
		 * total number of users the partner may use 
		 */
		public var loginUsersQuota:int;
		
		/**
		 * the filter used for listing users. 
		 */		
		public var usersFilter:VidiunUserFilter;
		
		/**
		 * link to upgrade page on corp website
		 * */
		public var usersUpgradeLink:String;
		
		/**
		 * user drilldown mode, either <code>DrilldownMode.ADD</code>, 
		 * <code>DrilldownMode.EDIT</code> or <code>DrilldownMode.NONE</code>.
		 * */
		public var drilldownMode:String = DrilldownMode.NONE;
		
		/**
		 * role drilldown mode when opened from this screen, either <code>DrilldownMode.ADD</code>, 
		 * <code>DrilldownMode.EDIT</code> or <code>DrilldownMode.NONE</code>.
		 * */
		public var roleDrilldownMode:String = DrilldownMode.NONE;
		
		
		/**
		 * when creating a new role from the user drilldown, need to pass  
		 * the VidiunUserRole returned from the server back to the user drilldown   
		 * window via the model. 
		 */		
		public var newRole:VidiunUserRole;
		
		[ArrayElementType("String")]
		/**
		 * users that in users table don't have destructive actions 
		 * (user ids separated by ',') 
		 */		
		public var crippledUsers:Array;
		
		
		/**
		 * the partner's admin user id. 
		 */
		public var adminUserId:String;
		
		
	}
}