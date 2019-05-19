package com.vidiun.vmc.business.module
{
	import com.vidiun.vmc.business.VmcModuleLoader;
	import com.vidiun.vmc.events.VmcModuleEvent;
	import com.vidiun.vmc.modules.VmcModule;VmcModule;
	
	
	import mx.modules.ModuleLoader;
	
	import org.flexunit.Assert;
	import org.flexunit.async.Async;
	import org.fluint.uiImpersonation.UIImpersonator;
	import mx.controls.ComboBox;ComboBox;

	public class TestModuleLoaded
	{		
		
		private var _vmcModuleLoader:VmcModuleLoader;
		private var _ml:ModuleLoader;
		
		[Before( async, ui )]
		public function setUp():void
		{
			_vmcModuleLoader = new VmcModuleLoader();
			_ml = _vmcModuleLoader.loadVmcModule("bin-debug/modules/Dashboard.swf", "dashboard");
			Async.proceedOnEvent( this, _vmcModuleLoader, VmcModuleEvent.MODULE_LOADED, 2000 );
			UIImpersonator.addChild( _ml );
		}
		
		[After(ui)]
		public function tearDown():void
		{
			UIImpersonator.removeChild( _ml );
			_ml = null;
			_vmcModuleLoader = null;
			
		}
		
		[Test(async, description="return the id a module was loaded with")]
		public function testGetModuleId():void
		{
			Assert.assertEquals(_vmcModuleLoader.getModuleLoadId(_ml), "dashboard");
		}
		
		
	}
}