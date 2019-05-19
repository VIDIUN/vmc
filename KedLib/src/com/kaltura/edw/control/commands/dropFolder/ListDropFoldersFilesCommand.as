package com.vidiun.edw.control.commands.dropFolder {
	import com.vidiun.commands.dropFolderFile.DropFolderFileList;
	import com.vidiun.edw.control.commands.VedCommand;
	import com.vidiun.edw.control.events.DropFolderFileEvent;
	import com.vidiun.edw.model.datapacks.DropFolderDataPack;
	import com.vidiun.errors.VidiunError;
	import com.vidiun.events.VidiunEvent;
	import com.vidiun.vmvc.control.VMvCEvent;
	import com.vidiun.types.VidiunDropFolderFileOrderBy;
	import com.vidiun.types.VidiunDropFolderFileStatus;
	import com.vidiun.vo.VidiunBaseEntry;
	import com.vidiun.vo.VidiunDropFolderFile;
	import com.vidiun.vo.VidiunDropFolderFileFilter;
	import com.vidiun.vo.VidiunDropFolderFileListResponse;
	
	import mx.collections.ArrayCollection;
	import mx.controls.Alert;
	import mx.resources.ResourceManager;

	public class ListDropFoldersFilesCommand extends VedCommand {
		// list_all / df_list_by_selected_folder_hierch / df_list_by_selected_folder_flat
		protected var _eventType:String;

		protected var _entry:VidiunBaseEntry;

		protected var _dropFolderData:DropFolderDataPack;
		
		override public function execute(event:VMvCEvent):void {
			_model.increaseLoadCounter();
			_dropFolderData = _model.getDataPack(DropFolderDataPack) as DropFolderDataPack;
			var listEvent:DropFolderFileEvent = event as DropFolderFileEvent;
			_eventType = listEvent.type;
			_entry = listEvent.entry;
			var listFiles:DropFolderFileList;
			
//			// drop folders panel
//			if (_eventType == DropFolderFileEvent.LIST_ALL) {
//				listFiles = new DropFolderFileList(_model.dropFolderModel.filter, _model.dropFolderModel.pager);
//			}
			// match from drop folder popup
//			else {
				var filter:VidiunDropFolderFileFilter = new VidiunDropFolderFileFilter();
				filter.orderBy = VidiunDropFolderFileOrderBy.CREATED_AT_DESC;
				// use selected folder
				filter.dropFolderIdEqual = _dropFolderData.selectedDropFolder.id;
				// if searching for slug
				if (listEvent.slug) {
					filter.parsedSlugLike = listEvent.slug;
				}
				// file status
				filter.statusIn = VidiunDropFolderFileStatus.NO_MATCH + "," + VidiunDropFolderFileStatus.WAITING + "," + VidiunDropFolderFileStatus.ERROR_HANDLING;
				listFiles = new DropFolderFileList(filter);
//			}

			listFiles.addEventListener(VidiunEvent.COMPLETE, result);
			listFiles.addEventListener(VidiunEvent.FAILED, fault);

			_client.post(listFiles);
		}


		override public function result(data:Object):void {
			if (data.error) {
				var er:VidiunError = data.error as VidiunError;
				if (er) {
					Alert.show(er.errorMsg, "Error");
				}
			}
			else {
				var ar:Array = handleDropFolderFileList(data.data as VidiunDropFolderFileListResponse);
//				if (_eventType == DropFolderFileEvent.LIST_ALL) {
//					_model.dropFolderModel.files = new ArrayCollection(ar);
//					_model.dropFolderModel.filesTotalCount = data.data.totalCount;
//				}
//				else {
					_dropFolderData.dropFolderFiles = new ArrayCollection(ar);
//				}
			}
			_model.decreaseLoadCounter();
		}


		/**
		 * list hierarchical:
		 * 	group items by slug
		 *
		 * list all or list flat:
		 *  just push the items to the model
		 *  */
		protected function handleDropFolderFileList(lr:VidiunDropFolderFileListResponse):Array {
			var ar:Array; // results array
			if (_eventType == DropFolderFileEvent.LIST_BY_SELECTED_FOLDER_HIERCH) {
				ar = createHierarchicData(lr);
			}
			else if (_eventType == DropFolderFileEvent.LIST_BY_SELECTED_FOLDER_FLAT) {
				ar = createFlatData(lr);
			}
			else {
				ar = new Array();
				for each (var o:Object in lr.objects) {
					if (o is VidiunDropFolderFile) {
						ar.push(o);
					}
				}
			}
			return ar;
		}


		protected function createFlatData(lr:VidiunDropFolderFileListResponse):Array {
			var dff:VidiunDropFolderFile;
			var ar:Array = new Array(); // results array
			var arWait:Array = new Array(); // waiting array

			for each (var o:Object in lr.objects) {
				if (o is VidiunDropFolderFile) {
					dff = o as VidiunDropFolderFile;
					// for files in status waiting, we only want files with a matching slug
					if (dff.status == VidiunDropFolderFileStatus.WAITING) {
						if (dff.parsedSlug != _entry.referenceId) {
							continue;
						}
						else {
							arWait.push(dff)
						}
					}
					// .. and all other fiels
					else {
						ar.push(dff);
					}
				}
			}

			// put the matched waiting files first
			while (arWait.length > 0) {
				ar.unshift(arWait.pop());
			}
			return ar;
		}


		/**
		 * Slug Based Folders:
		 * 	create a new dropfolderfile for each slug
		 * 	pouplate its createdAt property according to the file that created it.
		 * 	for each file:
		 * 	- if no matching slug object is found, create matching slug object.
		 * 	- update date on slug if needed
		 * 	- push the dff to the "files" attribute on the slug vo
		 */
		protected function createHierarchicData(lr:VidiunDropFolderFileListResponse):Array {
			var dff:VidiunDropFolderFile;
			var ar:Array = new Array(); // results array
			var dict:Object = new Object(); // slugs dictionary
			var group:VidiunDropFolderFile; // dffs group (by slug)

			var parseFailedStr:String = ResourceManager.getInstance().getString('dropfolders', 'parseFailed');
			for each (var o:Object in lr.objects) {
				if (o is VidiunDropFolderFile) {
					dff = o as VidiunDropFolderFile;
					// for files in status waiting, we only want files with a matching slug
					if (dff.status == VidiunDropFolderFileStatus.WAITING) {
						if (dff.parsedSlug != _entry.referenceId) {
							continue;
						}
					}
					// group all files where status == ERROR_HANDLING under same group
					if (dff.status == VidiunDropFolderFileStatus.ERROR_HANDLING) {
						dff.parsedSlug = parseFailedStr;
					}
					// get relevant group
					if (!dict[dff.parsedSlug]) {
						// create group
						group = new VidiunDropFolderFile();
						group.parsedSlug = dff.parsedSlug;
						group.createdAt = dff.createdAt;
						group.files = new Array();
						dict[group.parsedSlug] = group;
					}
					else {
						group = dict[dff.parsedSlug];
						// update date if needed
						if (group.createdAt > dff.createdAt) {
							group.createdAt = dff.createdAt;
						}
					}
					// add dff to files list
					group.files.push(dff);
					// if any file in the group is in waiting status, set the group to waiting:
					if (dff.status == VidiunDropFolderFileStatus.WAITING) {
						group.status = VidiunDropFolderFileStatus.WAITING;
					}
				}
			}
			var wait:VidiunDropFolderFile;
			for (var slug:String in dict) {
				if (slug != parseFailedStr) {
					if (dict[slug].status == VidiunDropFolderFileStatus.WAITING) {
						// we assume there's only one...
						wait = dict[slug] as VidiunDropFolderFile;
					}
					else {
						ar.push(dict[slug]);
					}
				}
			}
			// put the matched waiting file first
			if (wait) {
				ar.unshift(wait);
			}
			// put the parseFailed last
			if (dict[parseFailedStr]) {
				ar.push(dict[parseFailedStr]);
			}
			return ar;
		}
	}
}