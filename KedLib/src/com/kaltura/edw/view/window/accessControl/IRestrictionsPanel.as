package com.vidiun.edw.view.window.accessControl
{
	import com.vidiun.vo.VidiunAccessControl;

	/**
	 * this interface specifies methods of panels that show / manage access control restrictions on AccessControlProfilePopUpWindow.
	 * @see com.vidiun.edw.view.window.accessControl.AccessControlProfilePopUpWindow 
	 * @author atar.shadmi
	 * 
	 */
	public interface IRestrictionsPanel
	{
//		function get profile():VidiunAccessControl;
//		function set profile(value:VidiunAccessControl):void;
//		
//		function get editable():Boolean;
//		function set editable(value:Boolean):void;
//		
//		
//		function get isOk():Boolean;
//		function set isOk(value:Boolean):void;
		
		/**
		 * get the restrivtions from the profile and popuplate screen data accordingly 
		 */
		function setRestrictions():void;
		
		function updateRestrictions():void;
		
		
	}
}