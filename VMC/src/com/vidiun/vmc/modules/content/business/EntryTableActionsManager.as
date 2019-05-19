package com.vidiun.vmc.modules.content.business
{
	import com.adobe.cairngorm.control.CairngormEvent;
	import com.vidiun.edw.components.et.EntryTable;
	import com.vidiun.edw.components.et.events.EntryTableEvent;
	import com.vidiun.edw.control.VedController;
	import com.vidiun.edw.control.events.VedEntryEvent;
	import com.vidiun.edw.model.types.WindowsStates;
	import com.vidiun.vmc.modules.content.events.EntriesEvent;
	import com.vidiun.vmc.modules.content.events.VMCEntryEvent;
	import com.vidiun.vmc.modules.content.events.SelectionEvent;
	import com.vidiun.vmc.modules.content.events.WindowEvent;
	import com.vidiun.vmvc.control.VMvCEvent;
	import com.vidiun.types.VidiunPlaylistType;
	import com.vidiun.vo.VidiunBaseEntry;
	import com.vidiun.vo.VidiunMediaEntry;
	import com.vidiun.vo.VidiunMixEntry;
	import com.vidiun.vo.VidiunPlaylist;
	
	import mx.collections.ArrayCollection;

	/**
	 * handles EntryTable actions in a single location,
	 * so we won't have to duplicate code in all the classes that hold the ET.  
	 * @author atar.shadmi
	 */
	public class EntryTableActionsManager {
		
		/**
		 * delete selected entries
		 */
		public function deleteEntries(event:EntryTableEvent):void {
			var cgEvent:EntriesEvent = new EntriesEvent(EntriesEvent.DELETE_ENTRIES);
			cgEvent.data = event.data;
			cgEvent.dispatch();
		}
		
		
		/**
		 * open PnE window 
		 * @param event
		 */
		public function preview(event:EntryTableEvent):void {
			var entry:VidiunBaseEntry = event.data as VidiunBaseEntry;
			var cgEvent:VMCEntryEvent;
			if (entry is VidiunPlaylist)
				cgEvent = new VMCEntryEvent(VMCEntryEvent.PREVIEW, entry as VidiunPlaylist);
			else if (entry is VidiunMediaEntry || entry is VidiunMixEntry)
				cgEvent = new VMCEntryEvent(VMCEntryEvent.PREVIEW, entry as VidiunBaseEntry);
			else {
				trace("Error: no PlaylistVO nor EntryVO");
				return;
			}
			
			cgEvent.dispatch();
		}
		
		
		/**
		 * open live dashboard window 
		 * @param event
		 */
		public function showLiveDashboard(event:EntryTableEvent):void {
			var entry:VidiunBaseEntry = event.data as VidiunBaseEntry;
			var cgEvent:VMCEntryEvent;
			cgEvent = new VMCEntryEvent(VMCEntryEvent.SHOW_LIVE_DASHBOARD, entry as VidiunBaseEntry);
			cgEvent.dispatch();
		}
		
		
		public function showEntryDetailsHandler(event:EntryTableEvent):void {
			var entry:VidiunBaseEntry = event.data as VidiunBaseEntry;
			var et:EntryTable = event.target as EntryTable;
			var vEvent:VMvCEvent = new VedEntryEvent(VedEntryEvent.SET_SELECTED_ENTRY, entry, entry.id, (et.dataProvider as ArrayCollection).getItemIndex(entry));
			VedController.getInstance().dispatch(vEvent);
			var cgEvent:CairngormEvent = new WindowEvent(WindowEvent.OPEN, WindowsStates.ENTRY_DETAILS_WINDOW);
			cgEvent.dispatch();
		}
		
		
		public function showPlaylistDetailsHandler(event:EntryTableEvent):void {
			var entry:VidiunBaseEntry = event.data as VidiunBaseEntry;
			var et:EntryTable = event.target as EntryTable;
			var cgEvent:CairngormEvent;
			var vEvent:VedEntryEvent = new VedEntryEvent(VedEntryEvent.SET_SELECTED_ENTRY, entry as VidiunBaseEntry, (entry as VidiunBaseEntry).id, (et.dataProvider as ArrayCollection).getItemIndex(entry));
			VedController.getInstance().dispatchEvent(vEvent);
			//switch manual / rule base
			if ((entry as VidiunPlaylist).playlistType == VidiunPlaylistType.STATIC_LIST) {
				// manual list
				cgEvent = new WindowEvent(WindowEvent.OPEN, WindowsStates.PLAYLIST_MANUAL_WINDOW);
				cgEvent.dispatch();
			}
			if ((entry as VidiunPlaylist).playlistType == VidiunPlaylistType.DYNAMIC) {
				cgEvent = new WindowEvent(WindowEvent.OPEN, WindowsStates.PLAYLIST_RULE_BASED_WINDOW);
				cgEvent.dispatch();
			}
		}
		
		
		public function itemClickHandler(event:EntryTableEvent):void {
			var et:EntryTable = event.target as EntryTable;
			var cgEvent:SelectionEvent = new SelectionEvent(SelectionEvent.ENTRIES_SELECTION_CHANGED, et.selectedItems);
			cgEvent.dispatch();
			
		}
		
	}
}