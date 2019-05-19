package com.vidiun.vmc.modules.content.business
{
	import com.vidiun.vo.VidiunBaseEntryFilter;

	/**
	 * This interface declares methods that allow the Content module to comunicate with its subtabs.
	 * @author Atar
	 * 
	 */	
	public interface IContentPanel {
		
		/**
		 * initialize the panel, refresh data, etc.
		 * @param vbef	(optional) initial filtering data
		 */		
		function init(vbef:VidiunBaseEntryFilter = null):void;
		

	}
}