package com.vidiun.vmc.modules.content.utils
{
	import mx.resources.IResourceManager;
	import mx.resources.ResourceManager;
	import com.vidiun.vo.VidiunDropFolderFile;
	import mx.controls.dataGridClasses.DataGridColumn;
	import mx.formatters.DateFormatter;
	import com.vidiun.types.VidiunDropFolderFileStatus;
	import com.vidiun.types.VidiunDropFolderFileErrorCode;

	public class DropFolderTableStringUtil {
		
		/**
		 * used to convert to MegaByetes
		 * */
		private static const MB_MULTIPLIER:int = 1024*1024;
		
		/**
		 * in files size: number of digits to show after the decimal point
		 * */
		private static const DIGITS_AFTER_DEC_POINT:int = 2;
		
		
		/**
		 * date formatter for "created at" column 
		 */
		private static var dateDisplay:DateFormatter; 
		
		private static function initDateFormatter():void {
			dateDisplay = new DateFormatter();
			dateDisplay.formatString = "MM/DD/YYYY JJ:NN";
		}
			
		private static function formatDate(timestamp:int):String {
			if (timestamp == int.MIN_VALUE)
				return ResourceManager.getInstance().getString('dropfolders', 'n_a');
			var date:Date = new Date(timestamp * 1000);
			if (!dateDisplay) initDateFormatter();
			return dateDisplay.format(date);
		}
		
		
		/**
		 * creates the string to show as tooltip for "created at" column
		 * */
		public static function getDatesInfo(item:Object):String {
			var rm:IResourceManager = ResourceManager.getInstance();
			var file:VidiunDropFolderFile = item as VidiunDropFolderFile;
			var str:String = rm.getString('dropfolders', 'dfUploadStart' , [formatDate(file.uploadStartDetectedAt)] );
			str += '\n' + rm.getString('dropfolders', 'dfUploadEnd',  [formatDate(file.uploadEndDetectedAt)] );
			str += '\n' + rm.getString('dropfolders', 'dfTranserStart',  [formatDate(file.importStartedAt)] );
			str += '\n' + rm.getString('dropfolders', 'dfTransferEnd',  [formatDate(file.importEndedAt)] );
			return str;
		}
		
		/**
		 * Create suitable string to display in the "Created at" column
		 * */
		public static function dateCreatedLabelFunc(item:Object, column:DataGridColumn): String {
			var curFile:VidiunDropFolderFile = item as VidiunDropFolderFile;
			return formatDate(curFile.createdAt);
		}
		
		
		/**
		 * Create suitable string to display in the "File Size" column
		 * */
		public static function fileSizeLabelFunc(item:Object, column:DataGridColumn): String {
			var curFile:VidiunDropFolderFile = item as VidiunDropFolderFile;
			if (curFile.fileSize==int.MIN_VALUE)
				return '';
			return ((curFile.fileSize/MB_MULTIPLIER).toFixed(DIGITS_AFTER_DEC_POINT)) + ' ' + ResourceManager.getInstance().getString('dropfolders','megaBytes');
			
		}
		
		
		/**
		 * creates the string to show as tooltip for "status" column
		 * */
		public static function getStatusInfo(item:Object):String {
			var resourceManager:IResourceManager = ResourceManager.getInstance();
			var file:VidiunDropFolderFile = item as VidiunDropFolderFile;
			var str:String = file.status.toString();	// original value as default
			switch (file.status) {
				case VidiunDropFolderFileStatus.UPLOADING:
					str = resourceManager.getString('dropfolders','transferringDesc');
					break;
				case VidiunDropFolderFileStatus.DOWNLOADING:
					str = resourceManager.getString('dropfolders','downloadingDesc');
					break;
				case VidiunDropFolderFileStatus.PENDING:
					str = resourceManager.getString('dropfolders','pendingDesc');
					break;
				case VidiunDropFolderFileStatus.PROCESSING:
					str = resourceManager.getString('dropfolders','processingDesc');
					break;
				case VidiunDropFolderFileStatus.PARSED:
					str = resourceManager.getString('dropfolders','parsedDesc');
					break;
				case VidiunDropFolderFileStatus.WAITING:
					str = resourceManager.getString('dropfolders','waitingDesc');
					break;
				case VidiunDropFolderFileStatus.NO_MATCH:
					str = resourceManager.getString('dropfolders','noMatchDesc');
					break;
				case VidiunDropFolderFileStatus.ERROR_HANDLING:
					str = resourceManager.getString('dropfolders','errHandlingDesc');
					break;
				case VidiunDropFolderFileStatus.ERROR_DELETING:
					str = resourceManager.getString('dropfolders','errDeletingDesc');
					break;
				case VidiunDropFolderFileStatus.HANDLED:
					str = resourceManager.getString('dropfolders','handledDesc');
					break;
				case VidiunDropFolderFileStatus.ERROR_DOWNLOADING:
					str = resourceManager.getString('dropfolders','errDnldDesc');
					break;
			}
			return str;
		}
		
		
		/**
		 * Create suitable string to display in the "Status" column
		 * */
		public static function statusLabelFunc(item:Object, column:DataGridColumn): String {
			var resourceManager:IResourceManager = ResourceManager.getInstance();
			var curFile:VidiunDropFolderFile = item as VidiunDropFolderFile;
			switch (curFile.status) {
				case VidiunDropFolderFileStatus.UPLOADING:
					return resourceManager.getString('dropfolders','transferringBtn');
				case VidiunDropFolderFileStatus.DOWNLOADING:
					return resourceManager.getString('dropfolders','downloadingBtn');
				case VidiunDropFolderFileStatus.PENDING:
					return resourceManager.getString('dropfolders','pendingBtn');
				case VidiunDropFolderFileStatus.PROCESSING:
					return resourceManager.getString('dropfolders','processingBtn');
				case VidiunDropFolderFileStatus.PARSED:
					return resourceManager.getString('dropfolders','parsedBtn');
				case VidiunDropFolderFileStatus.WAITING:
					return resourceManager.getString('dropfolders','waitingBtn');
				case VidiunDropFolderFileStatus.NO_MATCH:
					return resourceManager.getString('dropfolders','noMatchBtn');
				case VidiunDropFolderFileStatus.ERROR_HANDLING:
					return resourceManager.getString('dropfolders','errHandlingBtn');
				case VidiunDropFolderFileStatus.ERROR_DELETING:
					return resourceManager.getString('dropfolders','errDeletingBtn');
				case VidiunDropFolderFileStatus.HANDLED:
					return resourceManager.getString('dropfolders','handledBtn');
				case VidiunDropFolderFileStatus.ERROR_DOWNLOADING:
					return resourceManager.getString('dropfolders','errDnldBtn');
			}
			return '';
		}
		
		
		/**
		 * Create suitable string to display in the "error desctiption" column
		 * */
		public static function getErrorDescription(item:Object) : String {
			var resourceManager:IResourceManager = ResourceManager.getInstance();
			var file:VidiunDropFolderFile = item as VidiunDropFolderFile;
			var err:String = file.errorDescription;	// keep server string as default description
			
			switch (file.errorCode) {
				case VidiunDropFolderFileErrorCode.ERROR_ADDING_BULK_UPLOAD :
					err = resourceManager.getString('dropfolders','dfErrAddBulk');
					break;
				case VidiunDropFolderFileErrorCode.ERROR_IN_BULK_UPLOAD :
					err = resourceManager.getString('dropfolders','dfErrBulkUpload');
					break;
//				case VidiunDropFolderFileErrorCode.ERROR_WRITING_TEMP_FILE :
//				case VidiunDropFolderFileErrorCode.LOCAL_FILE_WRONG_CHECKSUM :
//				case VidiunDropFolderFileErrorCode.LOCAL_FILE_WRONG_SIZE :
//					// not supposed to happen
//					break;
				case VidiunDropFolderFileErrorCode.ERROR_UPDATE_ENTRY : 
					err = resourceManager.getString('dropfolders','dfErrUpdateEntry');
					break;
				case VidiunDropFolderFileErrorCode.ERROR_ADD_ENTRY : 
					err = resourceManager.getString('dropfolders','dfErrAddEntry');
					break;
				case VidiunDropFolderFileErrorCode.FLAVOR_NOT_FOUND : 
					err = resourceManager.getString('dropfolders','dfErrFlavorNotFound', [file.parsedFlavor]);
					break;
				case VidiunDropFolderFileErrorCode.FLAVOR_MISSING_IN_FILE_NAME : 
					err = resourceManager.getString('dropfolders','dfErrFlavorMissingInFile');
					break;
				case VidiunDropFolderFileErrorCode.SLUG_REGEX_NO_MATCH : 
					err = resourceManager.getString('dropfolders','dfErrSlugRegex');
					break;
				case VidiunDropFolderFileErrorCode.ERROR_READING_FILE :
					err = resourceManager.getString('dropfolders','dfErrReadFile');
					break;
				case VidiunDropFolderFileErrorCode.ERROR_DOWNLOADING_FILE :
					err = resourceManager.getString('dropfolders','dfErrDnldFile');
					break;
				case VidiunDropFolderFileErrorCode.ERROR_UPDATE_FILE :
					err = resourceManager.getString('dropfolders','dfErrUpdateFile');
					break;
				case VidiunDropFolderFileErrorCode.ERROR_ADD_CONTENT_RESOURCE :
					err = resourceManager.getString('dropfolders','dfErrAddResource');
					break;
				case VidiunDropFolderFileErrorCode.ERROR_ADDING_CONTENT_PROCESSOR :
					err = resourceManager.getString('dropfolders','dfErrAddProc');
					break;
				case VidiunDropFolderFileErrorCode.ERROR_IN_CONTENT_PROCESSOR :
					err = resourceManager.getString('dropfolders','dfErrProc');
					break;
				case VidiunDropFolderFileErrorCode.ERROR_DELETING_FILE :
					err = resourceManager.getString('dropfolders','dfErrDelFile');
					break;
				case VidiunDropFolderFileErrorCode.MALFORMED_XML_FILE :
					err = resourceManager.getString('dropfolders','dfErrMalformXml');
					break;
				case VidiunDropFolderFileErrorCode.XML_FILE_SIZE_EXCEED_LIMIT :
					err = resourceManager.getString('dropfolders','dfErrXmlSize');
					break;
					
			}
			
			return err;
		}
	}
}