package com.vidiun.vmc.modules.content.commands.dropfolder {
	import com.adobe.cairngorm.control.CairngormEvent;
	import com.vidiun.commands.dropFolderFile.DropFolderFileList;
	import com.vidiun.errors.VidiunError;
	import com.vidiun.events.VidiunEvent;
	import com.vidiun.vmc.modules.content.commands.VidiunCommand;
	import com.vidiun.vmc.modules.content.events.VMCDropFolderEvent;
	import com.vidiun.vo.VidiunDropFolderFile;
	import com.vidiun.vo.VidiunDropFolderFileListResponse;
	
	import mx.collections.ArrayCollection;
	import mx.controls.Alert;

	public class ListDropFoldersFilesCommand extends VidiunCommand {
		// list_all / df_list_by_selected_folder_hierch / df_list_by_selected_folder_flat
		protected var _eventType:String;


		override public function execute(event:CairngormEvent):void {
			_model.increaseLoadCounter();
			var listEvent:VMCDropFolderEvent = event as VMCDropFolderEvent;
			_eventType = listEvent.type;
			var listFiles:DropFolderFileList;
			
			// drop folders panel
			listFiles = new DropFolderFileList(_model.dropFolderModel.filter, _model.dropFolderModel.pager);

			listFiles.addEventListener(VidiunEvent.COMPLETE, result);
			listFiles.addEventListener(VidiunEvent.FAILED, fault);

			_model.context.vc.post(listFiles);
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
				_model.dropFolderModel.files = new ArrayCollection(ar);
				_model.dropFolderModel.filesTotalCount = data.data.totalCount;
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
			ar = new Array();
			for each (var o:Object in lr.objects) {
				if (o is VidiunDropFolderFile) {
					ar.push(o);
				}
			}
			return ar;
		}


	}
}