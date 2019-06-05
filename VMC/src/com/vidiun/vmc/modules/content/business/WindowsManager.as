package com.vidiun.vmc.modules.content.business
{
	import com.adobe.cairngorm.control.CairngormEvent;
	import com.vidiun.analytics.GoogleAnalyticsConsts;
	import com.vidiun.analytics.GoogleAnalyticsTracker;
	import com.vidiun.analytics.VAnalyticsTracker;
	import com.vidiun.analytics.VAnalyticsTrackerConsts;
	import com.vidiun.containers.ConfinedTitleWindow;
	import com.vidiun.edw.business.IDataOwner;
	import com.vidiun.edw.components.playlist.ManualPlaylistWindow;
	import com.vidiun.edw.components.playlist.events.ManualPlaylistWindowEvent;
	import com.vidiun.edw.components.playlist.types.ManualPlaylistWindowMode;
	import com.vidiun.edw.constants.PanelConsts;
	import com.vidiun.edw.control.VedController;
	import com.vidiun.edw.control.events.VedEntryEvent;
	import com.vidiun.edw.control.events.LoadEvent;
	import com.vidiun.edw.control.events.SearchEvent;
	import com.vidiun.edw.events.VedDataEvent;
	import com.vidiun.edw.model.datapacks.ContextDataPack;
	import com.vidiun.edw.model.datapacks.DistributionDataPack;
	import com.vidiun.edw.model.datapacks.EntryDataPack;
	import com.vidiun.edw.model.types.WindowsStates;
	import com.vidiun.edw.view.EntryDetailsWin;
	import com.vidiun.edw.view.window.CategoryBrowser;
	import com.vidiun.edw.view.window.SetEntryOwnerWindow;
	import com.vidiun.edw.vo.ListableVo;
	import com.vidiun.vmc.business.JSGate;
	import com.vidiun.vmc.modules.content.events.CategoryEvent;
	import com.vidiun.vmc.modules.content.events.EntriesEvent;
	import com.vidiun.vmc.modules.content.events.VMCEntryEvent;
	import com.vidiun.vmc.modules.content.events.VMCSearchEvent;
	import com.vidiun.vmc.modules.content.events.SetPlaylistTypeEvent;
	import com.vidiun.vmc.modules.content.events.UpdateEntryEvent;
	import com.vidiun.vmc.modules.content.events.WindowEvent;
	import com.vidiun.vmc.modules.content.model.CmsModelLocator;
	import com.vidiun.vmc.modules.content.model.types.EntryDetailsWindowState;
	import com.vidiun.vmc.modules.content.utils.StringUtil;
	import com.vidiun.vmc.modules.content.view.window.AddLiveStream;
	import com.vidiun.vmc.modules.content.view.window.AddTagsWin;
	import com.vidiun.vmc.modules.content.view.window.CategoriesAccessWindow;
	import com.vidiun.vmc.modules.content.view.window.CategoriesContributionWindow;
	import com.vidiun.vmc.modules.content.view.window.CategoriesListingWindow;
	import com.vidiun.vmc.modules.content.view.window.DownloadWin;
	import com.vidiun.vmc.modules.content.view.window.MoveCategoriesWindow;
	import com.vidiun.vmc.modules.content.view.window.RemoveCategoriesWindow;
	import com.vidiun.vmc.modules.content.view.window.RemoveTagsWin;
	import com.vidiun.vmc.modules.content.view.window.RulePlaylistWindow;
	import com.vidiun.vmc.modules.content.view.window.SetAccessControlProfileWin;
	import com.vidiun.vmc.modules.content.view.window.SetSchedulingWin;
	import com.vidiun.vmc.modules.content.view.window.cdw.CategoryDetailsWin;
	import com.vidiun.vmc.modules.content.view.window.cdw.users.SetCatOwnerWindow;
	import com.vidiun.vmvc.control.VMvCEvent;
	import com.vidiun.vmvc.model.VMvCModel;
	import com.vidiun.types.VidiunMediaType;
	import com.vidiun.types.VidiunPlaylistType;
	import com.vidiun.types.VidiunStatsVmcEventType;
	import com.vidiun.utils.SoManager;
	import com.vidiun.vo.VidiunBaseEntry;
	import com.vidiun.vo.VidiunLiveStreamEntry;
	import com.vidiun.vo.VidiunLiveStreamBitrate;
	import com.vidiun.vo.VidiunMediaEntry;
	import com.vidiun.vo.VidiunPlaylist;
	
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.external.ExternalInterface;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	
	import modules.Content;
	
	import mx.collections.ArrayCollection;
	import mx.containers.ViewStack;
	import mx.core.Application;
	import mx.events.CloseEvent;
	import mx.managers.PopUpManager;

	
	
	[Event(name="refreshData", type="flash.events.Event")]
	
	
	/**
	 * manages all content popups navigation
	 * @author atar.shadmi
	 * 
	 */	
	public class WindowsManager extends EventDispatcher {
		
		private const DOWNLOAD_FINITE:String = "/file_name/name";
		
		/**
		 * Content's model 
		 */		
		public var model:CmsModelLocator;
		
		/**
		 * reference to Content's view stack 
		 */		
		public var contentView:ViewStack;
		
		
		/**
		 * reference to Content module 
		 */		
		public var owner:Content;
		
		[Bindable]
		/**
		 * entry data
		 * */
		private var _entryData:EntryDataPack = VMvCModel.getInstance().getDataPack(EntryDataPack) as EntryDataPack;		

		
		/**
		 * adds a popup window to the screen
		 * */
		private function addPopup(currentPopUp:ConfinedTitleWindow):void {
			// remember the new window
			model.popups.push(currentPopUp);
			if (model.popups.length == 1) {
				// this is the first popup
				owner.pEnableHtmlTabs(false);
				
			}
			PopUpManager.addPopUp(currentPopUp, Application.application as DisplayObject, true);
			currentPopUp.setFocus();
			centerPopups();
		}
		
		
		/**
		 * close popup window.
		 * if this was the last opened popup, enable HTML tabs
		 * */
		private function closePopup():void {
			var popup:ConfinedTitleWindow = model.topPopup;
			if (popup) {
				PopUpManager.removePopUp(popup);
				model.popups.pop();
			}
			if (!model.topPopup) {
				if (popup) {
					// only do this if we actualy closed a popup
					owner.pEnableHtmlTabs(true);
					if (contentView) {
						contentView.selectedChild.setFocus();
					}
				}
			}
		}
		
		/**
		 * bring any visible popups to the center of the screen
		 * */
		public function centerPopups(event:Event = null):void {
			for (var i:int = 0; i < model.popups.length; i++) {
				PopUpManager.centerPopUp(model.popups[i]);
			}
		}
		
		
		/**
		 * request to close the popup as response of window "x" button
		 * @param e
		 */
		private function handleClosePopup(e:CloseEvent):void {
			var cgEvent:WindowEvent = new WindowEvent(WindowEvent.CLOSE);
			cgEvent.dispatch();
		}
		
		
		/**
		 * opens or closes needed popup windows according to new state
		 * */
		public function changeWindowState(newState:String):void {
			if (newState == WindowsStates.NONE) {
				dispatchEvent(new Event("refreshData"));
				closePopup();
				owner.enabled = true;
			}
			else if (newState == WindowsStates.ENTRY_DETAILS_WINDOW_CLOSED_ONE) {
				closePopup();
			}
			else {
				owner.enabled = false;
				var currentPopUp:ConfinedTitleWindow;
				switch (newState) {
					case WindowsStates.REPLACEMENT_ENTRY_DETAILS_WINDOW:
						currentPopUp = openEntryDetails(EntryDetailsWindowState.REPLACEMENT_ENTRY);
						break;
					case WindowsStates.ENTRY_DETAILS_WINDOW_NEW_ENTRY:
						currentPopUp = openEntryDetails(EntryDetailsWindowState.NEW_ENTRY);
						break;
					case WindowsStates.ENTRY_DETAILS_WINDOW:
						currentPopUp = openEntryDetails(EntryDetailsWindowState.NORMAL_ENTRY);
						break;
					case WindowsStates.ENTRY_DETAILS_WINDOW_SA:
						currentPopUp = openEntryDetails(EntryDetailsWindowState.NORMAL_ENTRY_SA);
						break;
					case WindowsStates.PLAYLIST_ENTRY_DETAILS_WINDOW:
						currentPopUp = openEntryDetails(EntryDetailsWindowState.PLAYLIST_ENTRY);
						break;
					case WindowsStates.DOWNLOAD_WINDOW:
						currentPopUp = openDownload();
						break;
					case WindowsStates.ADD_ENTRY_TAGS_WINDOW:
						currentPopUp = new AddTagsWin();
						(currentPopUp as AddTagsWin).objectType = AddTagsWin.OBJECT_TYPE_ENTRY;
						(currentPopUp as AddTagsWin).setObjects(model.selectedEntries);
						currentPopUp.addEventListener(CloseEvent.CLOSE, handleClosePopup, false, 0, true);
						break;
					case WindowsStates.ADD_LIVE_STREAM:
						currentPopUp = new AddLiveStream();
						(currentPopUp as AddLiveStream).model = model;
						var ip:String;
						try {
							ip = ExternalInterface.call("vmc.utils.getClientIP");
							(currentPopUp as AddLiveStream).defaultIP = ip;
						}
						catch (e:Error) {
							trace('could not get clientIP from page');
						}
						break;
					case WindowsStates.REMOVE_ENTRY_TAGS_WINDOW:
						currentPopUp = new RemoveTagsWin();
						currentPopUp.addEventListener(CloseEvent.CLOSE, handleClosePopup, false, 0, true);
						(currentPopUp as RemoveTagsWin).objectType = RemoveTagsWin.OBJECT_TYPE_ENTRY;
						(currentPopUp as RemoveTagsWin).setObjects(new ArrayCollection(model.selectedEntries));
						break;
					case WindowsStates.PLAYLIST_MANUAL_WINDOW:
						currentPopUp = openManualPlaylist();
						break;
					case WindowsStates.PLAYLIST_RULE_BASED_WINDOW:
						currentPopUp = openRuleBasedPlaylist();
						break;
					case WindowsStates.SETTING_ACCESS_CONTROL_PROFILES_WINDOW:
						currentPopUp = new SetAccessControlProfileWin();
						(currentPopUp as SetAccessControlProfileWin).context = model.context; 
						(currentPopUp as SetAccessControlProfileWin).selectedEntries = new ArrayCollection(model.selectedEntries);
						(currentPopUp as SetAccessControlProfileWin).filterModel = model.filterModel;
						(currentPopUp as SetAccessControlProfileWin).entryDetailsModel = VMvCModel.getInstance();
						
						break;
					case WindowsStates.SETTING_SCHEDULING_WINDOW:
						currentPopUp = new SetSchedulingWin();
						(currentPopUp as SetSchedulingWin).context = model.context; 
						(currentPopUp as SetSchedulingWin).selectedEntries = new ArrayCollection(model.selectedEntries);
						break;
					case WindowsStates.PREVIEW:
						openPreviewEmbed();
						break;
					case WindowsStates.LIVE_DASHBOARD:
						openLiveDashboard();
						break;
					case WindowsStates.CATEGORY_DETAILS_WINDOW:
						var catDetails:CategoryDetailsWin;
						currentPopUp = catDetails = new CategoryDetailsWin();
						if (model.categoriesModel.selectedCategory.name == null){
							model.categoriesModel.processingNewCategory = true;	//TODO make pretty
							catDetails.isNewCategory = true;
							catDetails.vClient = model.context.vc;
						}
						catDetails.filterModel = model.filterModel;
						catDetails.categoriesModel = model.categoriesModel;
						catDetails.addEventListener(VedDataEvent.CLOSE_WINDOW, handleVedEvents, false, 0, true);
						break;
					case WindowsStates.CHANGE_ENTRY_OWNER_WINDOW:
						currentPopUp = new SetEntryOwnerWindow();
						currentPopUp.addEventListener("save", handleChangeEntryOwnerEvents, false, 0, true);
						currentPopUp.addEventListener(CloseEvent.CLOSE, handleClosePopup, false, 0, true);
						(currentPopUp as SetEntryOwnerWindow).vClient = (VMvCModel.getInstance().getDataPack(ContextDataPack) as ContextDataPack).vc;
//							(currentPopUp as SetOwnerWindow).entryData = _entryData;
//							(currentPopUp as SetOwnerWindow).setUserById(_entryData.selectedEntry.userId);
						break;
					case WindowsStates.ADD_CATEGORIES_WINDOW:
						currentPopUp = new CategoryBrowser();
						currentPopUp.addEventListener("apply", handleAddCategoriesEvents, false, 0, true);
						currentPopUp.addEventListener(CloseEvent.CLOSE, handleClosePopup, false, 0, true);
						(currentPopUp as CategoryBrowser).filterModel = model.filterModel;
						(currentPopUp as CategoryBrowser).vClient = (VMvCModel.getInstance().getDataPack(ContextDataPack) as ContextDataPack).vc;
						break;
					case WindowsStates.REMOVE_CATEGORIES_WINDOW:
						currentPopUp = new RemoveCategoriesWindow();
						currentPopUp.addEventListener(CloseEvent.CLOSE, handleClosePopup, false, 0, true);
						(currentPopUp as RemoveCategoriesWindow).model = model;
						break;
					case WindowsStates.MOVE_CATEGORIES_WINDOW:
					case WindowsStates.MOVE_CATEGORY_WINDOW:
						currentPopUp = openMoveCatsWin(newState);
						break;
					case WindowsStates.CATEGORIES_LISTING_WINDOW:
						currentPopUp = new CategoriesListingWindow();
						currentPopUp.addEventListener("apply", handleCategoriesListingEvents, false, 0, true);
						currentPopUp.addEventListener(CloseEvent.CLOSE, handleClosePopup, false, 0, true);
						break;
					case WindowsStates.CATEGORIES_ACCESS_WINDOW:
						currentPopUp = new CategoriesAccessWindow();
						currentPopUp.addEventListener("apply", handleCategoriesAccessEvents, false, 0, true);
						currentPopUp.addEventListener(CloseEvent.CLOSE, handleClosePopup, false, 0, true);
						break;
					case WindowsStates.CATEGORIES_CONTRIBUTION_WINDOW:
						currentPopUp = new CategoriesContributionWindow();
						currentPopUp.addEventListener("apply", handleCategoriesContributionEvents, false, 0, true);
						currentPopUp.addEventListener(CloseEvent.CLOSE, handleClosePopup, false, 0, true);
						break;
					case WindowsStates.CATEGORIES_OWNER_WINDOW:
						currentPopUp = new SetCatOwnerWindow();
						currentPopUp.addEventListener("apply", handleChangeCatOwnerEvent, false, 0, true);
						currentPopUp.addEventListener(CloseEvent.CLOSE, handleClosePopup, false, 0, true);
						break;
					case WindowsStates.ADD_CATEGORY_TAGS_WINDOW:
						currentPopUp = new AddTagsWin();
						(currentPopUp as AddTagsWin).objectType = AddTagsWin.OBJECT_TYPE_CATEGORY;
						(currentPopUp as AddTagsWin).setObjects(model.categoriesModel.selectedCategories);
						currentPopUp.addEventListener(CloseEvent.CLOSE, handleClosePopup, false, 0, true);
						break;
					case WindowsStates.REMOVE_CATEGORY_TAGS_WINDOW:
						currentPopUp = new RemoveTagsWin();
						currentPopUp.addEventListener(CloseEvent.CLOSE, handleClosePopup, false, 0, true);
						(currentPopUp as RemoveTagsWin).objectType = RemoveTagsWin.OBJECT_TYPE_CATEGORY;
						(currentPopUp as RemoveTagsWin).setObjects(new ArrayCollection(model.categoriesModel.selectedCategories));
						break;
				}
				
				// add the new window
				if (currentPopUp) {
					addPopup(currentPopUp);
					// if this is a replacement entry drilldown, move it a little
					if (newState == WindowsStates.REPLACEMENT_ENTRY_DETAILS_WINDOW) {
						currentPopUp.x += 20;
						currentPopUp.y += 40;
					}
				}
			}
		}
		
		private function openMoveCatsWin(newState:String):MoveCategoriesWindow {
			var currentPopUp:MoveCategoriesWindow = new MoveCategoriesWindow();
			currentPopUp.addEventListener("apply", handleMoveCategoriesEvents, false, 0, true);
			currentPopUp.addEventListener(CloseEvent.CLOSE, handleClosePopup, false, 0, true);
			(currentPopUp as MoveCategoriesWindow).filterModel = model.filterModel;
			(currentPopUp as MoveCategoriesWindow).vClient = model.context.vc;
			if (newState == WindowsStates.MOVE_CATEGORIES_WINDOW) {
				(currentPopUp as MoveCategoriesWindow).setCategories(model.categoriesModel.selectedCategories);
			}
			else if (newState == WindowsStates.MOVE_CATEGORY_WINDOW) {
				(currentPopUp as MoveCategoriesWindow).setCategories([model.categoriesModel.selectedCategory]);
			}
			return currentPopUp;
		}
		
		/**
		 * allows download of a single image or opens a download popup window
		 * */
		private function openDownload():DownloadWin {
			var dw:DownloadWin;
			//if the user selected to download a single image, no need to open to pop-up
			if ((model.selectedEntries) && (model.selectedEntries.length == 1) && 
				(model.selectedEntries[0] is VidiunMediaEntry) && 
				((model.selectedEntries[0] as VidiunMediaEntry).mediaType == VidiunMediaType.IMAGE)) {
				var urlRequest:URLRequest = new URLRequest(model.selectedEntries[0].downloadUrl + DOWNLOAD_FINITE);
				navigateToURL(urlRequest);
				owner.enabled = true;
			}
			else {
				dw = new DownloadWin();
				dw.entries = model.selectedEntries;
				dw.flavorParams = model.filterModel.flavorParams;
			}
			return dw;
		}
		
		/**
		 * opens a popup window with entry details
		 * @param state	they type of entry drilldown to show, enumerated in <code>EntryDetailsWindowState</code>
		 * */
		private function openEntryDetails(state:String):EntryDetailsWin {
			var edw:EntryDetailsWin = new EntryDetailsWin();
			edw.styleName = "WinTitleStyle";
			edw.addEventListener(VedDataEvent.ENTRY_RELOADED, handleVedEvents, false, 0, true);
			edw.addEventListener(VedDataEvent.CLOSE_WINDOW, handleVedEvents, false, 0, true);
			edw.addEventListener(VedDataEvent.CATEGORY_CHANGED, handleVedEvents, false, 0, true);
			edw.addEventListener(VedDataEvent.ENTRY_UPDATED, handleVedEvents, false, 0, true);
			edw.addEventListener(VedDataEvent.OPEN_REPLACEMENT, handleVedEvents, false, 0, true);
			edw.addEventListener(VedDataEvent.OPEN_ENTRY, handleVedEvents, false, 0, true);
			edw.isNewEntry = state == EntryDetailsWindowState.NEW_ENTRY;
			// get the selected entry from the server
			if (state != EntryDetailsWindowState.NEW_ENTRY && state != EntryDetailsWindowState.NORMAL_ENTRY_SA) {
				// in the SA mode, we just got the entry. no need to fetch again
				var getSelectedEntry:VedEntryEvent = new VedEntryEvent(VedEntryEvent.UPDATE_SELECTED_ENTRY_REPLACEMENT_STATUS, null,
					_entryData.selectedEntry.id);
				VedController.getInstance().dispatch(getSelectedEntry);
			}
			if (state == EntryDetailsWindowState.REPLACEMENT_ENTRY) {
				setReplacementDrilldown(edw);
			}
			
			var entryDetailsModel:VMvCModel = VMvCModel.getInstance();
			edw.entryDetailsModel = entryDetailsModel;
			var contextData:ContextDataPack = entryDetailsModel.getDataPack(ContextDataPack) as ContextDataPack;
			contextData.showEmbedCode = model.showSingleEntryEmbedCode;
			contextData.landingPage = model.extSynModel.partnerData.landingPage;
			contextData.openPlayerFunc = model.openPlayer;
			if (state != EntryDetailsWindowState.NORMAL_ENTRY)
				edw.showNextPrevBtns = false;
			else if (model.listableVo)	// only for normal entries
				edw.itemsAC = model.listableVo.arrayCollection;
			GoogleAnalyticsTracker.getInstance().sendToGA(GoogleAnalyticsConsts.CONTENT_ENTRY_DRILLDOWN, GoogleAnalyticsConsts.CONTENT)
			VAnalyticsTracker.getInstance().sendEvent(VAnalyticsTrackerConsts.CONTENT, VidiunStatsVmcEventType.CONTENT_ENTRY_DRILLDOWN, "content>Entry DrillDown");
			
			return edw;
		
		}
		
		
		/**
		 * open drill down to replacement entry, with partial tabs list
		 * */
		private function setReplacementDrilldown(edw:EntryDetailsWin):void {
			VMvCModel.addModel();
			var edp:EntryDataPack = VMvCModel.getInstance().getDataPack(EntryDataPack) as EntryDataPack;
			edp.selectedEntry = _entryData.selectedReplacementEntry;
			edp.replacedEntryName = _entryData.selectedEntry.name;
			//
			edp.loadRoughcuts = false;
			edw.visibleTabs = Vector.<String>([PanelConsts.ASSETS_PANEL]);
			edw.styleName = "WinTitleStyle2";
			edw.setStyle("modalTransparency", 0);
		}
		
		
		/**
		 * start the sequence of commands which will end in opening drilldown
		 * window for the given entry.
		 * @param entry		the entry to drill into.
		 * */
		private function requestEntryDrilldown(entry:VidiunBaseEntry):void {
			var cgEvent:CairngormEvent;
			var vEvent:VMvCEvent = new VedEntryEvent(VedEntryEvent.SET_SELECTED_ENTRY, entry);
			VedController.getInstance().dispatch(vEvent);
			if (entry is VidiunPlaylist) {
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
			else {
				cgEvent = new WindowEvent(WindowEvent.OPEN, WindowsStates.ENTRY_DETAILS_WINDOW_SA);
				cgEvent.dispatch();
			}
		}

		
		
		/**
		 * handle events dispatched by the drilldown
		 * */
		public function handleVedEvents(e:VedDataEvent):void {
			switch (e.type) {
				case VedDataEvent.ENTRY_UPDATED:
					// set refresh list required
					model.refreshEntriesRequired = true;
					// break; // case falldown
				case VedDataEvent.ENTRY_RELOADED:
					// dispatch a Cairngorm event which will update the new entry in the entries list
					var uev:UpdateEntryEvent = new UpdateEntryEvent(UpdateEntryEvent.UPDATE_ENTRY_IN_LIST);
					uev.data = e.data;
					uev.dispatch();
					break;
				
				case VedDataEvent.CLOSE_WINDOW:
					// close the drilldown
					var cgEvent:CairngormEvent = new WindowEvent(WindowEvent.CLOSE);
					cgEvent.dispatch();
					
//					// make sure list is refreshed when drilldown window is closed (Atar: this happens in Content)
//					if (model.refreshEntriesRequired) {
//						cgEvent = new VMCSearchEvent(VMCSearchEvent.DO_SEARCH_ENTRIES, model.listableVo);
//						cgEvent.dispatch();
//					}
					break;
				
				case VedDataEvent.CATEGORY_CHANGED:
					// list entries
					var searchEvent:VMCSearchEvent = new VMCSearchEvent(VMCSearchEvent.DO_SEARCH_ENTRIES , model.listableVo  );
					searchEvent.dispatch();
					break;
				
				case VedDataEvent.OPEN_REPLACEMENT:
					var openWindow:WindowEvent = new WindowEvent(WindowEvent.OPEN, WindowsStates.REPLACEMENT_ENTRY_DETAILS_WINDOW);
					openWindow.dispatch();
					break;
				
				case VedDataEvent.OPEN_ENTRY:
					requestEntryDrilldown(e.data);
					break;
			}
		}
		
		
		/**
		 * opens a popup window with manual playlist
		 * */
		private function openManualPlaylist():ManualPlaylistWindow {
			var cgEvent:EntriesEvent = new EntriesEvent(EntriesEvent.SET_SELECTED_ENTRIES_FOR_PLAYLIST);
			cgEvent.dispatch();
			
			var mpw:ManualPlaylistWindow = new ManualPlaylistWindow();
			mpw.filterData = model.filterModel;
			mpw.client = model.context.vc;
			
			if (model.playlistModel.onTheFlyPlaylistType == SetPlaylistTypeEvent.MANUAL_PLAYLIST) {
				// this is not an empty or edit existing playlist - this is a
				// new playlist created on the fly from entries screen 
				mpw.onTheFlyEntries = model.playlistModel.onTheFlyPlaylistEntries;
			}	
			
			mpw.distributionProfilesArray = (model.entryDetailsModel.getDataPack(DistributionDataPack) as DistributionDataPack).distributionInfo.distributionProfiles;
			mpw.editedItem = _entryData.selectedEntry;
			if (_entryData.selectedEntry && _entryData.selectedEntry.id){
				mpw.context = ManualPlaylistWindowMode.EDIT_PLAYLIST_MODE;
			}
			
			mpw.addEventListener(ManualPlaylistWindowEvent.CLOSE, handleManPlEvents);
			mpw.addEventListener(ManualPlaylistWindowEvent.SHOW_ENTRY_DETAILS, handleManPlEvents);
			mpw.addEventListener(ManualPlaylistWindowEvent.SAVE_NEW_PLAYLIST, handleManPlEvents);
			mpw.addEventListener(ManualPlaylistWindowEvent.SAVE_EXISTING_PLAYLIST, handleManPlEvents);
			mpw.addEventListener(ManualPlaylistWindowEvent.GET_PLAYLIST, handleManPlEvents);
			mpw.addEventListener(ManualPlaylistWindowEvent.LOAD_FILTER_DATA, handleManPlEvents);
			mpw.addEventListener(ManualPlaylistWindowEvent.SEARCH_ENTRIES, handleManPlEvents);
			return mpw;
		}
		
		
		private function handleManPlEvents(e:ManualPlaylistWindowEvent) :void {
			var cgEvent:CairngormEvent;
			switch (e.type) {
				case ManualPlaylistWindowEvent.CLOSE:
					var mpw:ManualPlaylistWindow = e.target as ManualPlaylistWindow;
					mpw.removeEventListener(ManualPlaylistWindowEvent.CLOSE, handleManPlEvents);
					mpw.removeEventListener(ManualPlaylistWindowEvent.SHOW_ENTRY_DETAILS, handleManPlEvents);
					mpw.removeEventListener(ManualPlaylistWindowEvent.SAVE_NEW_PLAYLIST, handleManPlEvents);
					mpw.removeEventListener(ManualPlaylistWindowEvent.SAVE_EXISTING_PLAYLIST, handleManPlEvents);
					mpw.removeEventListener(ManualPlaylistWindowEvent.GET_PLAYLIST, handleManPlEvents);
					mpw.removeEventListener(ManualPlaylistWindowEvent.LOAD_FILTER_DATA, handleManPlEvents);
					mpw.removeEventListener(ManualPlaylistWindowEvent.SEARCH_ENTRIES, handleManPlEvents);
					// reset on-the-fly flag 
					cgEvent = new SetPlaylistTypeEvent(SetPlaylistTypeEvent.NONE_PLAYLIST);
					cgEvent.dispatch();
					cgEvent = new WindowEvent(WindowEvent.CLOSE);
					cgEvent.dispatch();
					break;
				
				case ManualPlaylistWindowEvent.SHOW_ENTRY_DETAILS:
					// open entry details window with the selected entry from the playlist
					var entry:VidiunBaseEntry = e.data as VidiunBaseEntry;
					var vEvent:VMvCEvent = new VedEntryEvent(VedEntryEvent.SET_SELECTED_ENTRY, entry, entry.id);
					VedController.getInstance().dispatch(vEvent);
					cgEvent = new WindowEvent(WindowEvent.OPEN, WindowsStates.PLAYLIST_ENTRY_DETAILS_WINDOW);
					cgEvent.dispatch();
					break;
				
				case ManualPlaylistWindowEvent.SAVE_NEW_PLAYLIST:
					var addEntryEvent:VMCEntryEvent = new VMCEntryEvent(VMCEntryEvent.ADD_PLAYLIST, e.data as VidiunPlaylist);
					addEntryEvent.dispatch();
					break;
				
				case ManualPlaylistWindowEvent.SAVE_EXISTING_PLAYLIST:
					var entriesEvent:EntriesEvent = new EntriesEvent(EntriesEvent.UPDATE_PLAYLISTS,
						new ArrayCollection([e.data as VidiunPlaylist]));
					entriesEvent.dispatch();
					break;
				
				case ManualPlaylistWindowEvent.GET_PLAYLIST:
					cgEvent = new VMCEntryEvent(VMCEntryEvent.GET_PLAYLIST, e.data as VidiunPlaylist);
					cgEvent.dispatch();
					break;
				
				case ManualPlaylistWindowEvent.LOAD_FILTER_DATA:
					var fe:LoadEvent = new LoadEvent(LoadEvent.LOAD_FILTER_DATA, e.target as IDataOwner, model.filterModel);
					VedController.getInstance().dispatch(fe);
					break;
				
				case ManualPlaylistWindowEvent.SEARCH_ENTRIES:
					var searchEvent:SearchEvent = new SearchEvent(SearchEvent.SEARCH_ENTRIES, e.data as ListableVo);
					VedController.getInstance().dispatch(searchEvent);
					break;
			}
		}
		
		
		
		/**
		 * opens a popup window with rule based playlist
		 * */
		private function openRuleBasedPlaylist():RulePlaylistWindow {
			var rpw:RulePlaylistWindow = new RulePlaylistWindow();
			rpw.rulePlaylistData = model.playlistModel;
			rpw.rootUrl = model.context.rootUrl;
			if (_entryData.selectedEntry && (_entryData.selectedEntry is VidiunPlaylist)) {
				rpw.editPlaylist = _entryData.selectedEntry as VidiunPlaylist;
			}
			rpw.filterData = model.filterModel;
			
			rpw.distributionProfilesArr = (model.entryDetailsModel.getDataPack(DistributionDataPack) as DistributionDataPack).distributionInfo.distributionProfiles;
			rpw.client = model.context.vc;
			// assign the current fiter to the new window 
			rpw.onTheFlyFilter = model.playlistModel.onTheFlyFilter;
			model.playlistModel.onTheFlyFilter = null;
			
			return rpw;
		}
		
		/**
		 * open a preview player with live streaming entry
		 * */
		private function openLivestreamPreview(entry:VidiunBaseEntry):void {
			var lp:VidiunLiveStreamEntry = entry as VidiunLiveStreamEntry;
			var bitrates:Array = new Array();
			var o:Object;
			for each (var br:VidiunLiveStreamBitrate in lp.bitrates) {
				o = new Object();
				o.bitrate = br.bitrate;
				o.width = br.width;
				o.height = br.height;
				bitrates.push(o);
			}
			
			if (model.openPlayer) {
				//id, name, description, previewonly, is_playlist, uiconf_id 
				JSGate.doPreviewEmbed(model.openPlayer, lp.id, lp.name, StringUtil.cutTo512Chars(lp.description), 
					!model.showSingleEntryEmbedCode, false, model.attic.previewuiconf, bitrates, 0, lp.thumbnailUrl, lp.createdAt);
				model.attic.previewuiconf = null;
			}
			
			//First time funnel
			if (!SoManager.getInstance().checkOrFlush(GoogleAnalyticsConsts.CONTENT_FIRST_TIME_PLAYER_EMBED)) {
				GoogleAnalyticsTracker.getInstance().sendToGA(GoogleAnalyticsConsts.CONTENT_FIRST_TIME_PLAYER_EMBED, GoogleAnalyticsConsts.CONTENT);
			}
		}
		
		
		/**
		 * open a preview player with playlist
		 * */
		private function openPlaylistPreview(entry:VidiunBaseEntry):void {
			// open playlist preview
			if (model.openPlaylist) {
				var pl:VidiunPlaylist = entry as VidiunPlaylist;
				JSGate.doPreviewEmbed(model.openPlaylist, pl.id, pl.name, StringUtil.cutTo512Chars(pl.description), 
					!model.showPlaylistEmbedCode, true, model.attic.previewuiconf, null, 0, null, 0);
				model.attic.previewuiconf = null;
				//first time funnel 
				if (!SoManager.getInstance().checkOrFlush(GoogleAnalyticsConsts.CONTENT_FIRST_TIME_PLAYLIST_EMBED)) {
					GoogleAnalyticsTracker.getInstance().sendToGA(GoogleAnalyticsConsts.CONTENT_FIRST_TIME_PLAYLIST_EMBED, GoogleAnalyticsConsts.CONTENT);
				}
			}
		}
		
		
		/**
		 * open a preview player with a normal entry
		 * */
		private function openEntryPreview(entry:VidiunBaseEntry):void {
			// open regular entry preview
			if (model.openPlayer) {
				var duration:int = 0;
				if (entry is VidiunMediaEntry) {
					duration = (entry as VidiunMediaEntry).duration;
				}
				JSGate.doPreviewEmbed(model.openPlayer, entry.id, entry.name, StringUtil.cutTo512Chars(entry.description),
					!model.showSingleEntryEmbedCode, false, model.attic.previewuiconf, null, duration, entry.thumbnailUrl,
				entry.createdAt);
				model.attic.previewuiconf = null;
			}
			//First time funnel
			if (!SoManager.getInstance().checkOrFlush(GoogleAnalyticsConsts.CONTENT_FIRST_TIME_PLAYER_EMBED)) {
				GoogleAnalyticsTracker.getInstance().sendToGA(GoogleAnalyticsConsts.CONTENT_FIRST_TIME_PLAYER_EMBED, GoogleAnalyticsConsts.CONTENT);
			}
		}
		
		
		/**
		 * Open a preview player. <br>
		 * This method triggers one of the specific openPreview methods.
		 * */
		private function openPreviewEmbed():void {
			var entry:VidiunBaseEntry = _entryData.selectedEntry;
			
			if (entry is VidiunLiveStreamEntry) {
				openLivestreamPreview(entry);
				
			}
			else if (entry is VidiunPlaylist) {
				openPlaylistPreview(entry);
			}
			else {
				openEntryPreview(entry);
			}
			model.windowState = WindowsStates.NONE;
		}
		
		
		/**
		 * Open live dashboard for a live entry. <br>
		 * */
		private function openLiveDashboard():void {
			var entry:VidiunBaseEntry = _entryData.selectedEntry;
			JSGate.OpenLiveDashboard(entry.id);
			model.windowState = WindowsStates.NONE;
		}
		
		
		private function handleChangeEntryOwnerEvents(e:Event):void {
			switch (e.type) {
				case "save":
					// set entry owner for all selected entries
					var tgt:SetEntryOwnerWindow = e.target as SetEntryOwnerWindow;
					var vEvent:EntriesEvent = new EntriesEvent(EntriesEvent.SET_ENTRIES_OWNER, new ArrayCollection(model.selectedEntries));
					vEvent.data = tgt.selectedUser.id;
					vEvent.dispatch();
					break;
			}
		}
		
		
		private function handleAddCategoriesEvents(e:Event):void {
			switch (e.type) {
				case "apply":
					// add categories to all selected entries
					var tgt:CategoryBrowser = e.target as CategoryBrowser;
					var vEvent:EntriesEvent = new EntriesEvent(EntriesEvent.ADD_CATEGORIES_ENTRIES, new ArrayCollection(model.selectedEntries));
					vEvent.data = tgt.getCategories();
					vEvent.dispatch();
					break;
			}
		}
		
		
		
		private function handleMoveCategoriesEvents(e:Event):void {
			switch (e.type) {
				case "apply": 
					// set all categories as children of the selected parent category 
					var tgt:MoveCategoriesWindow = e.target as MoveCategoriesWindow;
					var vEvent:CategoryEvent = new CategoryEvent(CategoryEvent.MOVE_CATEGORIES);
					vEvent.data = [tgt.getCategories(), tgt.getParent()];
					vEvent.dispatch();
					GoogleAnalyticsTracker.getInstance().sendToGA(GoogleAnalyticsConsts.CONTENT_CATS_MOVE, GoogleAnalyticsConsts.CONTENT);
					break;
			}
		}
		
		private function handleCategoriesListingEvents(e:Event):void {
			switch (e.type) {
				case "apply": 
					var tgt:CategoriesListingWindow = e.target as CategoriesListingWindow;
					var vEvent:CategoryEvent = new CategoryEvent(CategoryEvent.SET_CATEGORIES_LISTING);
					vEvent.data = tgt.getListing();
					vEvent.dispatch();
					GoogleAnalyticsTracker.getInstance().sendToGA(GoogleAnalyticsConsts.CONTENT_CATS_LISTING, GoogleAnalyticsConsts.CONTENT);
					break;
			}
		}
		
		
		private function handleCategoriesContributionEvents(e:Event):void {
			switch (e.type) {
				case "apply": 
					var tgt:CategoriesContributionWindow = e.target as CategoriesContributionWindow
					var vEvent:CategoryEvent = new CategoryEvent(CategoryEvent.SET_CATEGORIES_CONTRIBUTION);
					vEvent.data = tgt.getContributionPolicy();
					vEvent.dispatch();
					GoogleAnalyticsTracker.getInstance().sendToGA(GoogleAnalyticsConsts.CONTENT_CATS_CONTRIBUTION_POLICY, GoogleAnalyticsConsts.CONTENT);
					break;
			}
		}
		
		
		private function handleCategoriesAccessEvents(e:Event):void {
			switch (e.type) {
				case "apply": 
					var tgt:CategoriesAccessWindow = e.target as CategoriesAccessWindow;
					var vEvent:CategoryEvent = new CategoryEvent(CategoryEvent.SET_CATEGORIES_ACCESS);
					vEvent.data = tgt.getAccess();
					vEvent.dispatch();
					GoogleAnalyticsTracker.getInstance().sendToGA(GoogleAnalyticsConsts.CONTENT_CATS_ACCESS, GoogleAnalyticsConsts.CONTENT);
					break;
			}
		}
		
		
		private function handleChangeCatOwnerEvent(e:Event):void {
			var tgt:SetCatOwnerWindow = e.target as SetCatOwnerWindow;
			switch (e.type) {
				case "apply":
					var vEvent:CategoryEvent = new CategoryEvent(CategoryEvent.SET_CATEGORIES_OWNER);
					vEvent.data = tgt.ownerUser.id;
					vEvent.dispatch();
					GoogleAnalyticsTracker.getInstance().sendToGA(GoogleAnalyticsConsts.CONTENT_CATS_OWNER, GoogleAnalyticsConsts.CONTENT);
					break;
			}
		}		
		
	}
}