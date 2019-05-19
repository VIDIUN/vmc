package com.vidiun.vmc.business
{
	import com.vidiun.vmc.business.permissions.ExtendPermissionManager;
	import com.vidiun.vmc.business.permissions.TestPermissionManager;
	import com.vidiun.vmc.business.permissions.TestPermissionParser;

	
	[Suite(order="1")]
	[RunWith("org.flexunit.runners.Suite")]
	public class PermissionsSuit
	{
		public var test1:com.vidiun.vmc.business.permissions.TestPermissionManager;
		public var test2:com.vidiun.vmc.business.permissions.TestPermissionParser;
		public var test4:com.vidiun.vmc.business.permissions.ExtendPermissionManager;
		
	}
}