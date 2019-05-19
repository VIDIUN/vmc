package com.vidiun.edw.control.commands.usrs
{
	import com.vidiun.edw.control.commands.VedCommand;
	import com.vidiun.edw.model.datapacks.EntryDataPack;
	import com.vidiun.vmvc.control.VMvCEvent;
	import com.vidiun.vo.VidiunUser;
	
	public class SetEntryOwnerCommand extends VedCommand {
		
		override public function execute(event:VMvCEvent):void {
			var edp:EntryDataPack = _model.getDataPack(EntryDataPack) as EntryDataPack;
			edp.selectedEntryOwner = event.data as VidiunUser;
		}
	}
}