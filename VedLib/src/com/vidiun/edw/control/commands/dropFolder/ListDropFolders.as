package com.vidiun.edw.control.commands.dropFolder
{
	import com.vidiun.commands.dropFolder.DropFolderList;
	import com.vidiun.edw.control.commands.VedCommand;
	import com.vidiun.edw.control.events.DropFolderEvent;
	import com.vidiun.edw.model.datapacks.DropFolderDataPack;
	import com.vidiun.edw.model.types.DropFolderListType;
	import com.vidiun.errors.VidiunError;
	import com.vidiun.events.VidiunEvent;
	import com.vidiun.vmvc.control.VMvCEvent;
	import com.vidiun.types.VidiunDropFolderContentFileHandlerMatchPolicy;
	import com.vidiun.types.VidiunDropFolderFileHandlerType;
	import com.vidiun.types.VidiunDropFolderOrderBy;
	import com.vidiun.types.VidiunDropFolderStatus;
	import com.vidiun.vo.VidiunDropFolder;
	import com.vidiun.vo.VidiunDropFolderContentFileHandlerConfig;
	import com.vidiun.vo.VidiunDropFolderFilter;
	import com.vidiun.vo.VidiunDropFolderListResponse;
	import com.vidiun.vo.VidiunFtpDropFolder;
	import com.vidiun.vo.VidiunScpDropFolder;
	import com.vidiun.vo.VidiunSftpDropFolder;
	
	import mx.collections.ArrayCollection;
	import mx.controls.Alert;
	
	public class ListDropFolders extends VedCommand {
		
		private var _flags:uint;
		
		override public function execute(event:VMvCEvent):void {
			_flags = (event as DropFolderEvent).flags;
			_model.increaseLoadCounter();
			var filter:VidiunDropFolderFilter = new VidiunDropFolderFilter();
//			filter.fileHandlerTypeEqual = VidiunDropFolderFileHandlerType.CONTENT;
			filter.orderBy = VidiunDropFolderOrderBy.NAME_DESC;
			filter.statusEqual = VidiunDropFolderStatus.ENABLED;
			var listFolders:DropFolderList = new DropFolderList(filter);
			listFolders.addEventListener(VidiunEvent.COMPLETE, result);
			listFolders.addEventListener(VidiunEvent.FAILED, fault);
			
			_client.post(listFolders); 	
		}
		
		
		override public function result(data:Object):void {
			if (data.error) {
				var er:VidiunError = data.error as VidiunError;
				if (er) {
					Alert.show(er.errorMsg, "Error");
				}
			}
			else {
				handleDropFolderList(data.data as VidiunDropFolderListResponse);
			}
			_model.decreaseLoadCounter();
		}
		
		
		/**
		 * put the folders in an array collection on the model 
		 * */
		protected function handleDropFolderList(lr:VidiunDropFolderListResponse):void {
			// so that the classes will be compiled in
			var dummy1:VidiunScpDropFolder;
			var dummy2:VidiunSftpDropFolder;
			var dummy3:VidiunFtpDropFolder;
			
			var df:VidiunDropFolder;
			var ar:Array = new Array();
			for each (var o:Object in lr.objects) {
				if (o is VidiunDropFolder ) {
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
					else if (_flags & DropFolderListType.XML_FOLDER && df.fileHandlerType == VidiunDropFolderFileHandlerType.XML){
						ar.push(df);
					}
				}
			}
			
			(_model.getDataPack(DropFolderDataPack) as DropFolderDataPack).dropFolders = new ArrayCollection(ar);
		}
		
	}
}