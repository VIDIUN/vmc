package com.vidiun.vmc.modules.content.commands
{
	import com.adobe.cairngorm.control.CairngormEvent;
	import com.vidiun.edw.control.events.SearchEvent;
	import com.vidiun.edw.control.VedController;
	import com.vidiun.vmc.modules.content.events.VMCSearchEvent;

	/**
	 * this command adds some VMC specific actions around the list action 
	 * @author Atar
	 */	
	public class DoSearchSequenceCommand extends VidiunCommand {
		
		
		override public function execute(event:CairngormEvent):void {
			var e:VMCSearchEvent = event as VMCSearchEvent;
			// reset selected entries list
			_model.selectedEntries = new Array();
			// search for new entries
			var cgEvent:SearchEvent = new SearchEvent(SearchEvent.SEARCH_ENTRIES, e.listableVo);
			VedController.getInstance().dispatch(cgEvent);
			// reset the refresh required flag
			_model.refreshEntriesRequired = false;
		}
	}
}