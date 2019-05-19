package com.vidiun.vmc.modules.analytics.model {
	import com.vidiun.VidiunClient;

	[Bindable]
	/**
	 * Context holds all kind of parameters that has to be shared accross the application
	 */
	public class Context {

		/**
		 * user identifier for tracking
		 * */
		public var userId:String;
		
		/**
		 * 
		 */
		public var isAnonymous:Boolean;
		
		/**
		 * partner id (passed to VDP) 
		 */		
		public var partnerId:String;
		
		/**
		 * sub partner id (passed to VDP)
		 */		
		public var subpId:String;
		
		/**
		 * session key (passed to VDP)
		 */		
		public var vs:String;
		
		
		public var permissions:int = -1;
		
		/**
		 * should VDP run in debug mode 
		 */		
		public var debugMode:Boolean = false;
		
		/**
		 * The PS3 - new flex client API
		 */
		public var vc:VidiunClient;

		/**
		 * protocol used for communication (like http://)
		 */
		public var protocol:String;
		
		/**
		 * protocol (like http://) and then  domain (like www.vidiun.com)
		 * e.g: swf that came from http://www.yourdomain.com/dir/file.swf will have "http://www.yourdomain.com/" as its root url
		 */
		public var rootUrl:String;

		/**
		 * This url from which this swf came from, omitting the [filename.swf]
		 * e.g: swf that came from http://www.yourdomain.com/dir/file.swf will have "http://www.yourdomain.com/dir/" as its source url
		 */
		public var sourceUrl:String;

		/**
		 * The hosting server name, e.g. "vidiun.com"
		 */
		public var hostName:String;

		/**
		 * url of the cdn server
		 */
		public var cdnHost:String;

		/**
		 *The main swf file name (e.g "ContributionWizard.swf")
		 */
		public var fileName:String

	}
}