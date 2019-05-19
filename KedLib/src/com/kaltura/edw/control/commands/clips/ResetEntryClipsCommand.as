package com.vidiun.edw.control.commands.clips
{
	import com.vidiun.edw.control.commands.VedCommand;
	import com.vidiun.edw.model.datapacks.ClipsDataPack;
	import com.vidiun.vmvc.control.VMvCEvent;
	
	public class ResetEntryClipsCommand extends VedCommand {
		
		override public function execute(event:VMvCEvent):void {
			(_model.getDataPack(ClipsDataPack) as ClipsDataPack).clips = null;
		}
	}
}