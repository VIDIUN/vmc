package com.vidiun.edw.control
{
	import com.vidiun.edw.control.commands.*;
	import com.vidiun.edw.control.commands.dropFolder.*;
	import com.vidiun.edw.control.commands.flavor.*;
	import com.vidiun.edw.control.events.DropFolderEvent;
	import com.vidiun.edw.control.events.DropFolderFileEvent;
	import com.vidiun.edw.control.events.FlavorAssetEvent;
	import com.vidiun.edw.control.events.VedEntryEvent;
	import com.vidiun.edw.control.events.MediaEvent;
	import com.vidiun.edw.control.events.ProfileEvent;
	import com.vidiun.vmvc.control.VMvCController;
	
	public class FlavorsTabController extends VMvCController {
		
		public function FlavorsTabController()
		{
			initializeCommands();
		}
		
		public function initializeCommands():void {
			addCommand(ProfileEvent.LIST_CONVERSION_PROFILES_AND_FLAVOR_PARAMS, ListConversionProfilesAndFlavorParams);
			addCommand(ProfileEvent.LIST_STORAGE_PROFILES, ListStorageProfilesCommand);
			
			addCommand(VedEntryEvent.GET_REPLACEMENT_ENTRY, GetSingleEntryCommand);
			addCommand(VedEntryEvent.GET_FLAVOR_ASSETS, ListFlavorAssetsByEntryIdCommand);
			addCommand(VedEntryEvent.UPDATE_SELECTED_ENTRY_REPLACEMENT_STATUS, GetSingleEntryCommand);
			addCommand(VedEntryEvent.UPDATE_SINGLE_ENTRY, UpdateSingleEntry);
			
			addCommand(MediaEvent.APPROVE_REPLACEMENT, ApproveMediaEntryReplacementCommand);
			addCommand(MediaEvent.CANCEL_REPLACEMENT, CancelMediaEntryReplacementCommand);
			addCommand(MediaEvent.UPDATE_SINGLE_FLAVOR, UpdateFlavorCommand);	
			addCommand(MediaEvent.ADD_SINGLE_FLAVOR, AddFlavorCommand);
			addCommand(MediaEvent.UPDATE_MEDIA, UpdateMediaCommand);
			
			addCommand(DropFolderEvent.LIST_FOLDERS, ListDropFolders);
			addCommand(DropFolderEvent.SET_SELECTED_FOLDER, SetSelectedFolder);	// matchFromDF win
			addCommand(DropFolderFileEvent.RESET_DROP_FOLDERS_AND_FILES, ResetDropFoldersAndFiles); // matchFromDF win
			addCommand(DropFolderFileEvent.LIST_BY_SELECTED_FOLDER_HIERCH, ListDropFoldersFilesCommand);	// matchFromDF win
			addCommand(DropFolderFileEvent.LIST_BY_SELECTED_FOLDER_FLAT, ListDropFoldersFilesCommand);	// matchFromDF win
			
			addCommand(FlavorAssetEvent.CREATE_FLAVOR_ASSET, ConvertFlavorAssetCommand);
			addCommand(FlavorAssetEvent.DELETE_FLAVOR_ASSET, DeleteFlavorAssetCommand);
			addCommand(FlavorAssetEvent.DOWNLOAD_FLAVOR_ASSET, DownloadFlavorAsset);
			addCommand(FlavorAssetEvent.PREVIEW_FLAVOR_ASSET, PreviewFlavorAsset);
			addCommand(FlavorAssetEvent.VIEW_WV_ASSET_DETAILS, ViewWVAssetDetails);
			
		}
	}
}