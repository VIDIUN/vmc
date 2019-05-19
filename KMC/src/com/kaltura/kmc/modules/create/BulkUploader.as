package com.vidiun.vmc.modules.create
{
	import com.vidiun.VidiunClient;
	import com.vidiun.commands.MultiRequest;
	import com.vidiun.commands.bulkUpload.BulkUploadAdd;
	import com.vidiun.commands.category.CategoryAddFromBulkUpload;
	import com.vidiun.commands.categoryUser.CategoryUserAddFromBulkUpload;
	import com.vidiun.commands.user.UserAddFromBulkUpload;
	import com.vidiun.edw.model.types.APIErrorCode;
	import com.vidiun.errors.VidiunError;
	import com.vidiun.events.VidiunEvent;
	import com.vidiun.vmc.business.JSGate;
	import com.vidiun.vmc.modules.create.types.BulkTypes;
	import com.vidiun.net.VidiunCall;
	import com.vidiun.types.VidiunBulkUploadType;
	import com.vidiun.vo.VidiunBulkUploadCategoryData;
	import com.vidiun.vo.VidiunBulkUploadCategoryUserData;
	import com.vidiun.vo.VidiunBulkUploadCsvJobData;
	import com.vidiun.vo.VidiunBulkUploadUserData;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.net.FileFilter;
	import flash.net.FileReference;
	import flash.net.FileReferenceList;
	
	import mx.controls.Alert;
	import mx.core.mx_internal;
	import mx.resources.ResourceBundle;
	import mx.resources.ResourceManager;
	import mx.validators.EmailValidator;

	/**
	 * this component handles the logic of selection and upload of bulk items 
	 * @author atar.shadmi
	 * 
	 */	
	public class BulkUploader extends EventDispatcher {
		
		
		private var _client:VidiunClient;
		
		/**
		 * type of object being uploaded in bulk
		 * 
		 * @see com.vidiun.vmc.modules.create.types.BulkTypes 
		 */		
		private var _uploadType:String;
		
		/**
		 * file reference list object for bulk uploads
		 * */
		private var _bulkUpldFileRef:FileReferenceList;
		
		/**
		 * list of FileReference objects to upload
		 */		
		private var _files:Array;
		
		private var _processedFilesCounter:int = 0;
		
		public function BulkUploader(client:VidiunClient) {
			super(this);
			_client = client;
		}

		/**
		 * Opens a desktop file selection pop-up, allowing csv/xml files selection
		 * */
		public function doUpload(type:String):void {
			_uploadType = type;
			_bulkUpldFileRef = new FileReferenceList();
			_bulkUpldFileRef.addEventListener(Event.SELECT, addBulkUploads);
			_bulkUpldFileRef.browse(getBulkUploadFilter(type));
		}
		
		
		protected function addBulkUploads(event:Event):void {
			var defaultConversionProfileId:int = -1;
			var file:FileReference;
			var vbu:VidiunCall;
			var jobData:VidiunBulkUploadCsvJobData;
			_files = [];
			for (var i:int = 0; i<_bulkUpldFileRef.fileList.length; i++) {
				file = _bulkUpldFileRef.fileList[i] as FileReference;
				// save the file
				_files.push(file);
			
				jobData = new VidiunBulkUploadCsvJobData();
				jobData.fileName = file.name;
				switch (_uploadType) {
					case BulkTypes.MEDIA:
						// pass in xml or csv file type
						vbu = new BulkUploadAdd(defaultConversionProfileId, file, getUploadType(file.name));
						break;
					
					case BulkTypes.CATEGORY:
						vbu = new CategoryAddFromBulkUpload(file, jobData, new VidiunBulkUploadCategoryData());
						break;
					case BulkTypes.USER:
						vbu = new UserAddFromBulkUpload(file, jobData, new VidiunBulkUploadUserData());
						break;
					case BulkTypes.CATEGORY_USER:
						vbu = new CategoryUserAddFromBulkUpload(file, jobData, new VidiunBulkUploadCategoryUserData());
						break;
				}
				
				
				vbu.addEventListener(VidiunEvent.COMPLETE, bulkUploadCompleteHandler);
				vbu.addEventListener(VidiunEvent.FAILED, bulkUploadCompleteHandler);
				vbu.queued = false;
				_client.post(vbu);
			}
		}
		
		/**
		 * create the list of optional file types for bulk upload
		 * */
		protected function getBulkUploadFilter(type:String):Array {
			var filter:FileFilter;
			switch (type) {
				case BulkTypes.MEDIA:
					filter = new FileFilter(ResourceManager.getInstance().getString('create', 'media_file_types'), "*.csv;*.xml");
					break;
				case BulkTypes.CATEGORY:
				case BulkTypes.USER:
				case BulkTypes.CATEGORY_USER:
					filter = new FileFilter(ResourceManager.getInstance().getString('create', 'other_file_types'), "*.csv");
					break;
			}
			var types:Array = [filter];
			return types;
		}
		
		/**
		 * get upload type (csv / xml) by file extension
		 * */
		protected function getUploadType(url:String):String {
			var ext:String = url.substring(url.length - 3);
			ext = ext.toLowerCase();
			if (ext == "csv") {
				return VidiunBulkUploadType.CSV;
			}
			return VidiunBulkUploadType.XML;
		}
		
		
		/**
		 * notify user 
		 */		
		protected function onComplete():void {
			// dispatch complete event
			dispatchEvent(new Event(Event.COMPLETE));	
		}
		
		
		protected function bulkUploadCompleteHandler(e:VidiunEvent):void {
			if (!e.success)  {
				var er:VidiunError = e.error;
				if (er.errorCode == APIErrorCode.INVALID_VS) {
					JSGate.expired();
				}
				else if (er.errorCode == APIErrorCode.SERVICE_FORBIDDEN) {
					// added the support of non closable window
					Alert.show(ResourceManager.getInstance().getString('common','forbiddenError',[er.errorMsg]), 
						ResourceManager.getInstance().getString('create', 'forbiden_error_title'), Alert.OK, null, logout);
				}
				else if (er.errorMsg) {
					Alert.show(er.errorMsg, ResourceManager.getInstance().getString('common', 'error'));
				}
			}
			
			_processedFilesCounter ++;
			if (_processedFilesCounter == _files.length) {
				onComplete();
			}
		}
		
		/**
		 * logout from VMC
		 * */
		protected function logout(e:Object):void {
			JSGate.expired();
		}
	}
}