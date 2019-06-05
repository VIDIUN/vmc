package com.vidiun.utils
{
	import mx.resources.IResourceBundle;
	import mx.resources.IResourceManager;
	import mx.resources.ResourceBundle;
	import mx.resources.ResourceManager;

	[ResourceBundle("vplayer")]
	[ResourceBundle("vplayerelements")]
	public class VPlayerUtil
	{
		/**
		 * add attributes on the given objects so when used as player flashvars, will override strings 
		 * @param obj
		 * @return 
		 * 
		 */
		public static function overrideStrings(obj:Object) :Object
		{
			// get the vplayer resource bundle
			var rm:IResourceManager = ResourceManager.getInstance();
			var bundle:IResourceBundle = rm.getResourceBundle(rm.localeChain[0], 'vplayer'); 
			if (bundle) {
				// get all the available strings
				for (var key:String in bundle.content) {
					// put them on the object with correct format: strings.ENTRY_CONVERTING
					obj["strings." + key] = bundle.content[key]; 
				}
			}
			return obj;
		}
		
		public static function overrideElementStrings(obj:Object) :Object {
			// get the vplayer resource bundle
			var rm:IResourceManager = ResourceManager.getInstance();
			var bundle:IResourceBundle = rm.getResourceBundle(rm.localeChain[0], 'vplayerelements'); 
			if (bundle) {
				// get all the available strings
				for (var key:String in bundle.content) {
					// put them on the object with correct format: strings.ENTRY_CONVERTING
					obj[key] = bundle.content[key]; 
				}
			}
			return obj;
		}
	}
}