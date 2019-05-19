package com.vidiun.vmc.modules.content.commands.dropfolder
{
	import com.adobe.cairngorm.control.CairngormEvent;
	import com.vidiun.commands.MultiRequest;
	import com.vidiun.commands.dropFolderFile.DropFolderFileDelete;
	import com.vidiun.commands.dropFolderFile.DropFolderFileList;
	import com.vidiun.events.VidiunEvent;
	import com.vidiun.vmc.modules.content.commands.VidiunCommand;
	import com.vidiun.vmc.modules.content.events.VMCDropFolderEvent;
	import com.vidiun.vo.VidiunDropFolderFile;
	import com.vidiun.vo.VidiunDropFolderFileListResponse;
	
	import mx.collections.ArrayCollection;

	public class DeleteDropFolderFilesCommand extends VidiunCommand
	{
		override public function execute(event:CairngormEvent):void {
			_model.increaseLoadCounter();
			var itemsToDelete:Array = (event as VMCDropFolderEvent).data;
			var mr:MultiRequest = new MultiRequest();
			for each (var file:VidiunDropFolderFile in itemsToDelete) {
				var deleteFile:DropFolderFileDelete = new DropFolderFileDelete(file.id);
				mr.addAction(deleteFile);
			}
			var listFiles:DropFolderFileList = new DropFolderFileList(_model.dropFolderModel.filter, _model.dropFolderModel.pager);
			mr.addAction(listFiles);
			
			mr.addEventListener(VidiunEvent.COMPLETE, result);
			mr.addEventListener(VidiunEvent.FAILED, fault);
			_model.context.vc.post(mr);
		}
		
		override public function result(data:Object):void {
			var resultArr:Array = data.data as Array;
			var listResponse:VidiunDropFolderFileListResponse = resultArr[resultArr.length - 1];
			var filteredArray:Array = new Array();
			for each (var o:Object in listResponse.objects) {
				if (o is VidiunDropFolderFile) {
					filteredArray.push(o);
				}
			}
			_model.dropFolderModel.files = new ArrayCollection(filteredArray);
			_model.dropFolderModel.filesTotalCount = listResponse.totalCount;
			
			_model.decreaseLoadCounter();
		}
	}
}