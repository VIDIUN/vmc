package com.vidiun.vmc.business
{
	import com.vidiun.edw.business.VedJSGate;
	import com.vidiun.vmc.modules.content.model.CmsModelLocator;
	
	import flash.external.ExternalInterface;

	/**
	 * this class is supposed to make sure we pass correct parameters to JS functions.
	 * a method's signature in JS should be identical to the one here, give or take, 
	 * so if we use the one here instead of directly calling ExternalInterface we'll 
	 * know where we need to change stuff when changing method signatures, etc.  
	 * @author Atar
	 */
	public class JSGate {
		
		public static function openClipApp(entryId:String, mode:String):void {
			VedJSGate.openClipApp(entryId, mode);
//			ExternalInterface.call("vmc.functions.openClipApp", entryId, mode);
		}
		
		
		public static function OpenLiveDashboard(entryId:String):void {
			ExternalInterface.call("vmc.functions.openLiveDashboard", entryId);
		}
		
		/**
		 * vs expired 
		 */
		public static function expired():void {
			VedJSGate.expired();
		}
		
		/**
		 * create the HTML tabs
		 * @param tabs	list of objects that describe the tabs.
		 * 				{display_name:name to display on tab,
		 * 				module_name:id to return to vmc for this tab,
		 * 				subtab:initial subtab to show when switching to this module,
		 * 				html_url:url of contents of html tabs}
		 */
		public static function createTabs(tabs:Array):void {
			ExternalInterface.call("vmc.utils.createTabs", tabs);
		}
		
		/**
		 * switch to HTML tab
		 * @param url url of the html tab contents
		 */
		public static function openIframe(url:String):void {
			ExternalInterface.call("vmc.utils.openIframe", url);
		}
		
		/**
		 * trigger the given JS function
		 * @param funcName name of JS function to trigger
		 */
		public static function triggerJS(funcName:String):void {
			VedJSGate.triggerJS(funcName);
		}
		
		/**
		 * show the vmc swf
		 * (used after showing HTML tab to tell js that we need to switch back to flash)
		 */
		public static function showFlash():void {
			ExternalInterface.call("vmc.utils.showFlash");
		}
		
		/**
		 * set the active tab
		 * @param module	id of module to mark active 
		 */
		public static function setTab(module:String, resetAll:Boolean):void {
			ExternalInterface.call("vmc.utils.setTab", module, resetAll);
		}
		
		
		/**
		 * set the tab as not active
		 * @param module	id of module to mark active 
		 */
		public static function resetTab(module:String):void {
			ExternalInterface.call("vmc.utils.resetTab", module);
			//TODO use this
		}
		
		
		/**
		 * open preview and embed popup 
		 * @param functionName		name of the function we need to trigger in js
		 * @param entryId			entry id
		 * @param entryName			entry name
		 * @param entryDescription	entry description
		 * @param previewOnly		hide embed code
		 * @param is_playlist		the entry is a playlist
		 * @param uiconfId			initial player uiconf to use
		 * @param live_bitrates		list of bitrate objects {bitrate, width, height}
		 * @param duration			entry duration (only for single player, not playlist)
		 * @param thumbnail			entry thumbnail (only for single player, not playlist)
		 * @param creationDate		entry creation date, unix timestamp (only for single player, not playlist)
		 */
		public static function doPreviewEmbed(functionName:String, entryId:String, entryName:String, entryDescription:String, 
											  previewOnly:Boolean, is_playlist:Boolean, uiconfId:String, live_bitrates:Array,
											  duration:int, thumbnail:String, creationDate:int):void {
			VedJSGate.doPreviewEmbed(functionName, entryId, entryName, entryDescription, 
				previewOnly, is_playlist, uiconfId, live_bitrates, duration, thumbnail, creationDate);
		}
		
		
		public static function onTabChange():void {
			ExternalInterface.call("onTabChange");
		}
		
		/**
		 * set url hash text to represent current subtab 
		 * @param module	name of module (not part of JS API)
		 * @param subtab	name of subtab to write in url
		 */
		public static function writeUrlHash(module:String, subtab:String):void {
			ExternalInterface.call("vmc.mediator.writeUrlHash", module, subtab);
		}
		
		/**
		 * open an editor for the given entry 
		 * @param entryId		entry id
		 * @param entryName		entry name
		 * @param editorType	editor type
		 * @param isNewMix		true: create a mix and then open an editor, 
		 *						false: edit this mix with the matching editor type
		 */
		public static function startEditor(entryId:String, entryName:String, editorType:int, isNewMix:Boolean):void {
			ExternalInterface.call("vmc.editors.start", entryId, entryName, editorType, isNewMix);
		}
		
		/**
		 * open the change user name popup window 
		 */
		public static function openChangeName():void {
			ExternalInterface.call("vmc.user.changeSetting", 'name');
		}
		
		/**
		 * open the change user password popup window 
		 */
		public static function openChangePwd():void {
			ExternalInterface.call("vmc.user.changeSetting", 'password');
		}
		
		/**
		 * open the change user email popup window
		 * @param mail	user's current email 
		 */
		public static function openChangeEmail():void {
			ExternalInterface.call("vmc.user.changeSetting", 'email');
		}
		
		
		/**
		 * open the VCW 
		 * @param conversion_profile
		 * @param uiconftag
		 */
		public static function openVcw(conversion_profile:String, uiconftag:String):void {
			ExternalInterface.call("vmc.functions.openVcw", conversion_profile,uiconftag);
		}
		
		
		
		/**
		 * ask the page where to position the add entry menu 
		 * @return top right point of where the menu should open.
		 */
		public static function getPanelPosition():int {
			return ExternalInterface.call("vmc.functions.getAddPanelPosition");
		}
		
		
		
		
		/**
		 * show help pages
		 * @param baseURL  
		 * @param key	help page to show (VMC anchor, mapped to page name in JS)
		 */
		public static function openHelp(baseURL:String, key:String):void {
			ExternalInterface.call("vmc.utils.openHelp", baseURL, key);
		}
		
		
		/**
		 * enable/disable header tabs
		 * @param enable	if true enable, otherwise disable  
		 */
		public static function maskHeader(enable:Boolean):void {
			VedJSGate.maskHeader(enable);
		}
		
		public static function alerti(str:String):void {
			ExternalInterface.call("alert", str);
		}
	}
}