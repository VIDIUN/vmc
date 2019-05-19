package com.vidiun.vmc.business
{
	import com.vidiun.vmc.business.module.TestVmc;
	import com.vidiun.vmc.business.module.TestVmcModuleLoader;
	import com.vidiun.vmc.business.module.TestModuleLoaded;
	import com.vidiun.vmc.business.module.TestVmc;
	import com.vidiun.vmc.business.module.TestVmcModuleLoader;
	import com.vidiun.vmc.business.module.TestModuleLoaded;
	
	[Suite]
	[RunWith("org.flexunit.runners.Suite")]
	public class ModuleSuit
	{
		public var test1:com.vidiun.vmc.business.module.TestVmc;
		public var test2:com.vidiun.vmc.business.module.TestVmcModuleLoader;
		public var test3:com.vidiun.vmc.business.module.TestModuleLoaded;
		
	}
}