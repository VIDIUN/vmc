package com.vidiun.vmc.modules.content.commands
{
	import com.adobe.cairngorm.control.CairngormEvent;
	import com.vidiun.edw.control.commands.VedCommand;
	import com.vidiun.edw.model.datapacks.EntryDataPack;
	import com.vidiun.edw.model.types.WindowsStates;
	import com.vidiun.vmvc.control.VMvCEvent;
	import com.vidiun.vmc.modules.content.events.VMCEntryEvent;

	public class OpenLiveDashboardCommand extends VidiunCommand
	{
		override public function execute(event:CairngormEvent):void
		{
			(_model.entryDetailsModel.getDataPack(EntryDataPack) as EntryDataPack).selectedEntry = (event as VMCEntryEvent).entryVo;
			_model.windowState = WindowsStates.LIVE_DASHBOARD;
		}
	}
}