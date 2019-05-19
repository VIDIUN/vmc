package com.vidiun.vmc.events {
	import flash.events.Event;

	import mx.modules.ModuleLoader;
	/**
	 * Class <code>VmcModuleEvent</code> represents events thrown by 
	 * <code>VmcModuleLoader</code> to handle module loading.
	 */
	public class VmcModuleEvent extends Event {
		public static const MODULE_LOADED:String = "moduleLoaded";
		public static const MODULE_LOAD_ERROR:String = "moduleLoadError";
		public static const MODULE_LOAD_PROGRESS:String = "moduleLoadProgress";

		private var _moduleLoader:ModuleLoader;
		private var _errorText:String;
		
		


		public function VmcModuleEvent(type:String, moduleLoader:ModuleLoader, errorText:String = "",  bubbles:Boolean = false, cancelable:Boolean = false) {
			_moduleLoader = moduleLoader;
			_errorText = errorText;
			super(type, bubbles, cancelable);
		}


		/**
		 * The <code>ModuleLoader</code> that loaded a module
		 */		
		public function get moduleLoader():ModuleLoader {
			return _moduleLoader;
		}

		/**
		 * the error text retrieved from the <code>ModuleLoader</code> instance which loaded the relevant module 
		 */		
		public function get errorText():String {
			return _errorText;
		}

	}
}