package com.vidiun.edw.control.commands.cuepoints {
	import com.vidiun.edw.control.commands.VedCommand;
	import com.vidiun.edw.model.datapacks.CuePointsDataPack;
	import com.vidiun.vmvc.control.VMvCEvent;
	

	public class ResetCuePointsCount extends VedCommand {

		override public function execute(event:VMvCEvent):void {
			(_model.getDataPack(CuePointsDataPack) as CuePointsDataPack).cuepointsCount = 0;
		}
	}
}