package com.vidiun.vmc.business.module {
	import com.vidiun.vmc.business.VmcModuleLoader;
	import com.vidiun.vmc.events.VmcModuleEvent;
	import com.vidiun.vmc.modules.VmcModule;
	
	import flash.system.ApplicationDomain;
	
	import mx.containers.HBox;
	import mx.controls.ComboBox;
	import mx.events.ModuleEvent;
	import mx.modules.ModuleLoader;
	
	import org.flexunit.Assert;
	import org.flexunit.async.Async;

	public class TestVmcModuleLoader {
		private var _vmcModuleLoader:VmcModuleLoader;


		[Before]
		public function setUp():void {
			_vmcModuleLoader = new VmcModuleLoader();
		}


		[After]
		public function tearDown():void {
			_vmcModuleLoader = null;
		}


		[Test(async, description="if module loaded, say so")]
		public function testOnModuleReady():void {
			VmcModule;HBox;ComboBox;
			var asyncHandler:Function = Async.asyncHandler(this, handleSuccess, 5000, null, handleTimeout);
			_vmcModuleLoader.addEventListener(VmcModuleEvent.MODULE_LOADED, asyncHandler, false, 0, true);
			var ml:ModuleLoader = _vmcModuleLoader.loadVmcModule("bin-debug/modules/Dashboard.swf", "dashboard");
			ml.loadModule();
		}


		[Test(async, description="if error loading module, catch the error")]
		public function testOnModuleError():void {
			VmcModule; 
			var asyncHandler:Function = Async.asyncHandler(this, handleSuccess, 10000, null, handleTimeout);
			_vmcModuleLoader.addEventListener(VmcModuleEvent.MODULE_LOAD_ERROR, asyncHandler, false, 0, true);
			var ml:ModuleLoader = _vmcModuleLoader.loadVmcModule("bin-debug/modules/Dashboard1.swf", "dashboard");
			ml.loadModule();
		}


		protected function handleSuccess(event:VmcModuleEvent, passThroughData:Object = null):void {
			trace(event.type, event.errorText);
		}


		



		protected function handleTimeout(passThroughData:Object):void {
			Assert.fail("Timeout reached before event");
		}
	}
}