package com.vidiun.vmc.model {
	import com.adobe.cairngorm.model.IModelLocator;
	import com.vidiun.VidiunClient;
	import com.vidiun.edw.business.permissions.PermissionManager;
	import com.vidiun.vmc.vo.UserVO;
	import com.vidiun.types.VidiunPermissionStatus;
	import com.vidiun.types.VidiunPermissionType;
	import com.vidiun.vo.VidiunPermission;
	import com.vidiun.vo.VidiunPermissionFilter;

	import flash.events.EventDispatcher;

	[Bindable]
	public class VmcModelLocator extends EventDispatcher implements IModelLocator {

		///////////////////////////////////////////
		//singleton methods
		/**
		 * singleton instance
		 */
		private static var _instance:VmcModelLocator;


		/**
		 * Vidiun Client. This should be the instance that every module will get and use
		 */
		public var vidiunClient:VidiunClient;

		/**
		 * The instance of a PermissionManager.
		 */
		public var permissionManager:PermissionManager;

		/**
		 * Flashvars of the main app wrapped in one object. The items are
		 */
		public var flashvars:Object;

		public var userInfo:UserVO;

		public var permissionsListFilter:VidiunPermissionFilter;


		/**
		 * singleton means of retreiving an instance of the
		 * <code>VmcModelLocator</code> class.
		 */
		public static function getInstance():VmcModelLocator {
			if (_instance == null) {
				_instance = new VmcModelLocator(new Enforcer());

			}
			return _instance;
		}


		/**
		 * initialize parameters and sub-models.
		 * @param enforcer	singleton garantee
		 */
		public function VmcModelLocator(enforcer:Enforcer) {
			permissionManager = PermissionManager.getInstance();

			permissionsListFilter = new VidiunPermissionFilter();
			permissionsListFilter.typeIn = VidiunPermissionType.SPECIAL_FEATURE + ',' + VidiunPermissionType.PLUGIN;
			permissionsListFilter.statusEqual = VidiunPermissionStatus.ACTIVE;
		}


	}
}

class Enforcer {

}