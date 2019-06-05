package com.vidiun.edw.control.events {
	import com.vidiun.vmvc.control.VMvCEvent;
	import com.vidiun.vo.VidiunAssetsParamsResourceContainers;
	import com.vidiun.vo.VidiunBaseEntry;
	import com.vidiun.vo.VidiunResource;

	public class DropFolderFileEvent extends VMvCEvent {

		/**
		 * reset the drop folder files list on the model
		 */		
		public static const RESET_DROP_FOLDERS_AND_FILES:String = "df_reset_files_list";
		
//		/**
//		 * list all files from all drop folders
//		 * */
//		public static const LIST_ALL:String = "list_all";
		
		/**
		 * list files in selected folder and create the array hierarchical
		 * */
		public static const LIST_BY_SELECTED_FOLDER_HIERCH:String = "df_list_by_selected_folder_hierch";
		
		/**
		 * list files in selected folder and create the array flat
		 */		
		public static const LIST_BY_SELECTED_FOLDER_FLAT:String = "df_list_by_selected_folder_flat";
		
//		/**
//		 * delete files from drop folder?
//		 * */
//		public static const DELETE_FILES:String = "delete_files";

		private var _entry:VidiunBaseEntry;
		private var _slug:String;
		private var _resources:VidiunResource;
		private var _selectedFiles:Array;


		public function DropFolderFileEvent(type:String, entry:VidiunBaseEntry=null, slug:String=null, resource:VidiunResource=null, selectedFiles:Array=null, bubbles:Boolean = false, cancelable:Boolean = false) {
			super(type, bubbles, cancelable);
			_entry = entry;
			_slug = slug;
			_resources = resource;
			_selectedFiles = selectedFiles;
		}


		public function get entry():VidiunBaseEntry {
			return _entry;
		}


		public function get slug():String {
			return _slug;
		}


		public function get resource():VidiunResource {
			return _resources;
		}
		
		public function get selectedFiles():Array {
			return _selectedFiles;
		}

	}
}