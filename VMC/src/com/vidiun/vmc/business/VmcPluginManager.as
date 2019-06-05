package com.vidiun.vmc.business
{
	import com.vidiun.VidiunClient;
	import com.vidiun.vmc.events.VmcErrorEvent;
	
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.LoaderInfo;
	import flash.events.EventDispatcher;
	import flash.system.ApplicationDomain;
	import flash.utils.Dictionary;
	
	import mx.core.Application;
	import mx.events.ModuleEvent;
	import mx.modules.Module;
	import mx.modules.ModuleLoader;
	import mx.resources.ResourceManager;

	public class VmcPluginManager extends EventDispatcher {
		
		/**
		 * VMC uiconf, holds data regarding modules and plugins 
		 */
		private var _uiconf:XML;
		
		/**
		 * associative array of plugins (FlexModules) that VMC loaded, 
		 * listed by their ids
		 * */
		private var _plugins:Object;
		
		/**
		 * something to addChild plugins to 
		 */
		private var _approot:DisplayObjectContainer;
		
		/**
		 * client for API calls 
		 */
		private var _client:VidiunClient;
		
		/**
		 * application flashvars object 
		 */		
		private var _flashvars:Object;
		
		/**
		 * event handlers to attach to loaded plugins 
		 * {eventType:listenerFunction, eventType2:listenerFunction2}
		 */		
		private var _eventHandlers:Object;
		
		public function VmcPluginManager(approot:DisplayObjectContainer, client:VidiunClient, flashvars:Object, eventHandlers:Object)
		{
			_approot = approot;
			_client = client;
			_flashvars = flashvars;
			_eventHandlers = eventHandlers;
			_plugins = new Object(); 
		}
		
		
		/**
		 * decide if should use relative or absolute url.
		 * if the given path is ablsolute, return the same string.
		 * if the given path is relative, concatenate it to the swf url.
		 * @param	given path
		 * @return	path to use
		 * */
		protected function getUrl(path:String):String {
			var url:String;
			if (path.indexOf("http") == 0) {
				url = path;
			}
			else {
				var li:LoaderInfo = (Application.application as Application).loaderInfo; 
				var base:String = li.url.substr(0, li.url.lastIndexOf("/"));
				url = base + "/" + path;
			}
			return url; 
		}
		
		
		/**
		 * load the FlexModule
		 * @param pluginInfo xml with plugin load info 
		 * 			<plugin id="addCode" path="modules/Add.swf" dependencies="add,admin"/>
		 */
		private function loadPlugin(pluginInfo:XML):void {
			var pluginLoader:ModuleLoader = new ModuleLoader();
			pluginLoader.applicationDomain = ApplicationDomain.currentDomain;
			pluginLoader.addEventListener(ModuleEvent.READY, onPluginLoaded);
			pluginLoader.addEventListener(ModuleEvent.ERROR, onPluginLoadError);
			pluginLoader.url = getUrl(pluginInfo.@path);
			_approot.addChild(pluginLoader);
		}
		
		
		/**
		 * when the plugin is loaded, assign it an id according
		 * to uiconf and put it in the plugins list
		 * */
		private function onPluginLoaded (e:ModuleEvent):void {
			var ml:ModuleLoader = e.target as ModuleLoader;
			if (ml.parent) {
				ml.parent.removeChild(ml);
			}
			ml.removeEventListener(ModuleEvent.READY, onPluginLoaded);
			ml.removeEventListener(ModuleEvent.ERROR, onPluginLoadError);
			var pluginInfo:XML = getPluginInfoByUrl(ml.url);  
			var plugin:Module = ml.child as Module;
			
			// pass all attributes as plugins vars
			var atts:XMLList = pluginInfo.attributes();
			var att:String;
			for (var i:uint = 0 ; i< atts.length() ; i++) {
				att = (atts[i] as XML).localName().toString();
				if (att != "path" && att != "dependencies") {
					// the above are required by VMC, not by the plugin
					plugin[att] = atts[i].toString();
				}
			}
			// pass the config node if exists
			if (pluginInfo.config.length() > 0) {
				plugin["config"] = pluginInfo.config[0]; 
			}
			
			for (var event:String in _eventHandlers) {
				plugin.addEventListener(event, _eventHandlers[event]);
			}

			
			if (plugin is IPopupMenu) {
				(plugin as IPopupMenu).setRoot(_approot);
			}
			if (plugin is IVmcPlugin) {
				(plugin as IVmcPlugin).client = _client;
				(plugin as IVmcPlugin).flashvars = _flashvars;
			}
			_plugins[plugin.id] = plugin;
			
		}
		
		private function getPluginInfoByUrl(url:String):XML {
			var plugins:XMLList = _uiconf.plugins.plugin;
			for each (var plugin:XML in plugins) {
				if (url.indexOf(plugin.@path) > -1) {
					return plugin;
				}
			}
			return null;
		}
		
		
		/**
		 * dispatch a VMCErrorEvent
		 * @param e
		 */
		private function onPluginLoadError (e:ModuleEvent):void {
			dispatchEvent(new VmcErrorEvent(VmcErrorEvent.ERROR, e.errorText));
		}
		
		/**
		 * load required VMC plugins 
		 * */
		public function loadPlugins(uiconf:XML):void {
			_uiconf = uiconf;
			// see if plugin is needed, then load it.
			var plugins:XMLList = uiconf.plugins.plugin;
			var module:XMLList;
			
			for each (var pluginInfo:XML in plugins) {
				var dependencies:Array = pluginInfo.@dependencies.split(",");
				for (var i:int =0;i <dependencies.length; i++) {
					module = uiconf.modules.module.(@id == dependencies[i]);
					if (module.length() > 0) {
						// load plugin, then break.
						loadPlugin(pluginInfo);
						break;
					}
				}
			}
		}
		
		public function executePluginMethod(pluginId:String, methodName:String, ...args):* {
			try {
				return _plugins[pluginId][methodName].apply(_plugins[pluginId], args);
			} catch (e:Error) {
				dispatchEvent(new VmcErrorEvent(VmcErrorEvent.ERROR, ResourceManager.getInstance().getString('vmc', 'method_dont_exist', [pluginId, methodName])));
			}
		}
		
	}
}