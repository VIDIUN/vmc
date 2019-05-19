package com.vidiun.vmc.modules.content.commands.dropfolder {
	import com.adobe.cairngorm.control.CairngormEvent;
	import com.vidiun.commands.dropFolder.DropFolderList;
	import com.vidiun.commands.dropFolderFile.DropFolderFileList;
	import com.vidiun.edw.control.commands.VedCommand;
	import com.vidiun.edw.control.events.DropFolderEvent;
	import com.vidiun.edw.model.types.DropFolderListType;
	import com.vidiun.errors.VidiunError;
	import com.vidiun.events.VidiunEvent;
	import com.vidiun.vmc.modules.content.commands.VidiunCommand;
	import com.vidiun.vmc.modules.content.events.VMCDropFolderEvent;
	import com.vidiun.vmvc.control.VMvCEvent;
	import com.vidiun.types.VidiunDropFolderContentFileHandlerMatchPolicy;
	import com.vidiun.types.VidiunDropFolderFileHandlerType;
	import com.vidiun.types.VidiunDropFolderFileOrderBy;
	import com.vidiun.types.VidiunDropFolderFileStatus;
	import com.vidiun.types.VidiunDropFolderOrderBy;
	import com.vidiun.types.VidiunDropFolderStatus;
	import com.vidiun.vo.VidiunDropFolder;
	import com.vidiun.vo.VidiunDropFolderContentFileHandlerConfig;
	import com.vidiun.vo.VidiunDropFolderFile;
	import com.vidiun.vo.VidiunDropFolderFileFilter;
	import com.vidiun.vo.VidiunDropFolderFileListResponse;
	import com.vidiun.vo.VidiunDropFolderFilter;
	import com.vidiun.vo.VidiunDropFolderListResponse;
	import com.vidiun.vo.VidiunFtpDropFolder;
	import com.vidiun.vo.VidiunScpDropFolder;
	import com.vidiun.vo.VidiunSftpDropFolder;
	
	import mx.collections.ArrayCollection;
	import mx.controls.Alert;
	import mx.core.mx_internal;
	import mx.resources.IResourceBundle;
	import mx.resources.IResourceManager;
	import mx.resources.ResourceManager;
	
//	use namespace mx.core.mx_internal;
	

	public class ListDropFoldersAndFiles extends VidiunCommand {

		
		private var _flags:uint;
		private var _fileFilter:VidiunDropFolderFileFilter;


		override public function execute(event:CairngormEvent):void {
			_flags = (event as VMCDropFolderEvent).flags;
			_model.increaseLoadCounter();
			if (event.data is VidiunDropFolderFileFilter) {
				_fileFilter = event.data;
			}
			var filter:VidiunDropFolderFilter = new VidiunDropFolderFilter();
			filter.orderBy = VidiunDropFolderOrderBy.CREATED_AT_DESC;
			filter.statusEqual = VidiunDropFolderStatus.ENABLED;
			var listFolders:DropFolderList = new DropFolderList(filter);
			listFolders.addEventListener(VidiunEvent.COMPLETE, result);
			listFolders.addEventListener(VidiunEvent.FAILED, fault);

			_model.context.vc.post(listFolders);
		}


		override public function result(data:Object):void {
			var rm:IResourceManager = ResourceManager.getInstance();
			if (data.error) {
				var er:VidiunError = data.error as VidiunError;
				if (er) {
					Alert.show(er.errorMsg, rm.getString('cms', 'error'));
				}
			}
			else {
				var ar:Array = handleDropFolderList(data.data as VidiunDropFolderListResponse);
				_model.dropFolderModel.dropFolders = new ArrayCollection(ar);
				
				if (ar.length == 0) {
					// show upsale alert
					var str:String = rm.getString('dropfolders', 'dfUpsale');
					var alert:Alert = Alert.show(str, rm.getString('cms', 'attention'));
					alert.mx_internal::alertForm.mx_internal::textField.htmlText = str; // because it includes links and stuff
					_model.decreaseLoadCounter();
				}
				else {
					// load files from the returned folders
					if (!_fileFilter) {
						var folderIds:String = '';
						for each (var vdf:VidiunDropFolder in ar) {
							folderIds += vdf.id + ",";
						}
						_fileFilter = new VidiunDropFolderFileFilter();
						_fileFilter.orderBy = VidiunDropFolderFileOrderBy.CREATED_AT_DESC;
						// use selected folder
						_fileFilter.dropFolderIdIn = folderIds;
						_fileFilter.statusIn = VidiunDropFolderFileStatus.DOWNLOADING + "," +
							VidiunDropFolderFileStatus.ERROR_DELETING + "," + 
							VidiunDropFolderFileStatus.ERROR_DOWNLOADING + "," + 
							VidiunDropFolderFileStatus.ERROR_HANDLING + "," + 
							VidiunDropFolderFileStatus.HANDLED + "," + 
							VidiunDropFolderFileStatus.NO_MATCH + "," + 
							VidiunDropFolderFileStatus.PENDING + "," + 
							VidiunDropFolderFileStatus.PROCESSING + "," + 
							VidiunDropFolderFileStatus.PARSED + "," + 
							VidiunDropFolderFileStatus.UPLOADING + "," + 
							VidiunDropFolderFileStatus.DETECTED + "," + 
							VidiunDropFolderFileStatus.WAITING; 
						_model.dropFolderModel.filter = _fileFilter;
					}
					var listFiles:DropFolderFileList = new DropFolderFileList(_fileFilter, _model.dropFolderModel.pager);
	
					listFiles.addEventListener(VidiunEvent.COMPLETE, filesResult);
					listFiles.addEventListener(VidiunEvent.FAILED, fault);
					_model.context.vc.post(listFiles);
				}
			}
//			_model.decreaseLoadCounter();
		}


		protected function filesResult(event:VidiunEvent):void {
			var ar:Array = new Array();
			var objs:Array = (event.data as VidiunDropFolderFileListResponse).objects;
			for each (var o:Object in objs) {
				if (o is VidiunDropFolderFile) {
					ar.push(o);
				}
			}
			_model.dropFolderModel.files = new ArrayCollection(ar);
			_model.dropFolderModel.filesTotalCount = event.data.totalCount;
			_model.decreaseLoadCounter();
		}


		/**
		 * put the folders in an array collection on the model
		 * */
		protected function handleDropFolderList(lr:VidiunDropFolderListResponse):Array {
			// so that the classes will be comiled in
			var dummy1:VidiunScpDropFolder;
			var dummy2:VidiunSftpDropFolder;
			var dummy3:VidiunFtpDropFolder;

			var df:VidiunDropFolder;
			var ar:Array = new Array();
			for each (var o:Object in lr.objects) {
				if (o is VidiunDropFolder) {
					df = o as VidiunDropFolder;
					if (df.fileHandlerType == VidiunDropFolderFileHandlerType.CONTENT) {
						var cfg:VidiunDropFolderContentFileHandlerConfig = df.fileHandlerConfig as VidiunDropFolderContentFileHandlerConfig;
						if (_flags & DropFolderListType.ADD_NEW && cfg.contentMatchPolicy == VidiunDropFolderContentFileHandlerMatchPolicy.ADD_AS_NEW) {
							ar.push(df);
						}
						else if (_flags & DropFolderListType.MATCH_OR_KEEP && cfg.contentMatchPolicy == VidiunDropFolderContentFileHandlerMatchPolicy.MATCH_EXISTING_OR_KEEP_IN_FOLDER) {
							ar.push(df);
						}
						else if (_flags & DropFolderListType.MATCH_OR_NEW && cfg.contentMatchPolicy == VidiunDropFolderContentFileHandlerMatchPolicy.MATCH_EXISTING_OR_ADD_AS_NEW) {
							ar.push(df);
						}
					}
					else if (_flags & DropFolderListType.XML_FOLDER && df.fileHandlerType == VidiunDropFolderFileHandlerType.XML) {
						ar.push(df);
					}
				}
			}
			return ar;
		}
	}
}