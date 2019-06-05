package com.vidiun.edw.control.commands.cuepoints
{
	import com.vidiun.commands.cuePoint.CuePointAddFromBulk;
	import com.vidiun.edw.control.commands.VedCommand;
	import com.vidiun.edw.model.datapacks.CuePointsDataPack;
	import com.vidiun.events.VidiunEvent;
	import com.vidiun.vmvc.control.VMvCEvent;
	
	public class UploadCuePoints extends VedCommand {
		
		override public function execute(event:VMvCEvent):void
		{
			_model.increaseLoadCounter();		
			var cnt:CuePointAddFromBulk = new CuePointAddFromBulk(event.data);
			
			cnt.addEventListener(VidiunEvent.COMPLETE, result);
			cnt.addEventListener(VidiunEvent.FAILED, fault);
			cnt.queued = false;
			
			(_model.getDataPack(CuePointsDataPack) as CuePointsDataPack).reloadCuePoints = false;
			_client.post(cnt);	 
		}
		
		override public function result(data:Object):void {
			super.result(data);
			//refresh cue points
			(_model.getDataPack(CuePointsDataPack) as CuePointsDataPack).reloadCuePoints = true;
			_model.decreaseLoadCounter();
		}
	}
}