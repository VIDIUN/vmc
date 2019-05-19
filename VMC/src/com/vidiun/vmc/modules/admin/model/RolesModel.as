package com.vidiun.vmc.modules.admin.model
{
	import com.vidiun.types.VidiunPermissionStatus;
	import com.vidiun.types.VidiunPermissionType;
	import com.vidiun.types.VidiunUserRoleOrderBy;
	import com.vidiun.types.VidiunUserRoleStatus;
	import com.vidiun.vo.VidiunPermissionFilter;
	import com.vidiun.vo.VidiunUserRole;
	import com.vidiun.vo.VidiunUserRoleFilter;
	
	import mx.collections.ArrayCollection;

	[Bindable]
	public class RolesModel {
		
		public function RolesModel(){
			// get only active roles (not deleted)
			rolesFilter = new VidiunUserRoleFilter();
			rolesFilter.statusEqual = VidiunUserRoleStatus.ACTIVE;
			rolesFilter.orderBy = VidiunUserRoleOrderBy.ID_ASC;
			rolesFilter.tagsMultiLikeOr = 'vmc';
			// only get speacial, non-deleted features
			permissionsFilter = new VidiunPermissionFilter();
			permissionsFilter.typeIn = VidiunPermissionType.SPECIAL_FEATURE + ',' + VidiunPermissionType.PLUGIN;
			permissionsFilter.statusEqual = VidiunPermissionStatus.ACTIVE;
		}
		
		/**
		 * the active role entry.
		 * */
		public var selectedRole:VidiunUserRole;
		
		[ArrayElementType("VidiunUserRole")]
		/**
		 * list of all roles (VidiunRole objects) 
		 */
		public var roles:ArrayCollection;
		
		/**
		 * total number of rols as indicated by list result 
		 */		
		public var totalRoles:int;
		
		/**
		 * the filter used for listing roles. 
		 */		
		public var rolesFilter:VidiunUserRoleFilter;
		
		/**
		 * the filter used for listing partner permissions
		 * (only get speacial features). 
		 */		
		public var permissionsFilter:VidiunPermissionFilter;
		
		
		/**
		 * role drilldown mode, either <code>DrilldownMode.ADD</code>, 
		 * <code>DrilldownMode.EDIT</code> or  <code>DrilldownMode.NONE</code>.
		 * */
		public var drilldownMode:String = DrilldownMode.NONE;
		
		
		/**
		 * when duplications a role from the roles table, need to open a 
		 * drilldown window for it. since the only way to trigger ui actions
		 * is via binding, we'll use this propoerty.    
		 */		
		public var newRole:VidiunUserRole;
		
		
		/**
		 * all partner's permissions uiconf 
		 */
		public var partnerPermissionsUiconf:XML;
		
		/**
		 * a list of permissions ids from the VidiunPartner data (features, plugins)
		 */
		public var partnerPermissions:String;
	}
}