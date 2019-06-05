package com.vidiun.edw.control.commands.dropFolder
{
	import com.vidiun.edw.control.commands.VedCommand;
	import com.vidiun.edw.control.events.DropFolderEvent;
	import com.vidiun.edw.model.datapacks.DropFolderDataPack;
	import com.vidiun.vmvc.control.VMvCEvent;
	
	public class SetSelectedFolder extends VedCommand {
		
		override public function execute(event:VMvCEvent):void {
			var dropFolderData:DropFolderDataPack = _model.getDataPack(DropFolderDataPack) as DropFolderDataPack;
			dropFolderData.selectedDropFolder = (event as DropFolderEvent).folder;
		}
	}
}