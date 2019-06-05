package com.vidiun.vmc.vo
{
	import com.vidiun.vo.VidiunUser;
	import com.vidiun.vo.VidiunUserRole;

	[Bindable]
	/**
	 * holds together data about a user and their role 
	 * @author Atar
	 */	
	public class UserVO {
		
		/**
		 * user details 
		 */
		public var user:VidiunUser;
		
		/**
		 * the role associated with <code>user</code> 
		 */		
		public var role:VidiunUserRole;
	}
}