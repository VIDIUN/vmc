package com.vidiun.edw.control.commands.cuepoints
{
	import com.vidiun.commands.cuePoint.CuePointCount;
	import com.vidiun.edw.control.commands.VedCommand;
	import com.vidiun.edw.control.events.CuePointEvent;
	import com.vidiun.edw.model.datapacks.CuePointsDataPack;
	import com.vidiun.events.VidiunEvent;
	import com.vidiun.vmvc.control.VMvCEvent;
	import com.vidiun.vo.VidiunCuePointFilter;
	
	public class CountCuePoints extends VedCommand {
		
		override public function execute(event:VMvCEvent):void
		{
			_model.increaseLoadCounter();		
			var e : CuePointEvent = event as CuePointEvent;
			var f:VidiunCuePointFilter = new VidiunCuePointFilter();
			f.entryIdEqual = e.data;
			var cnt:CuePointCount = new CuePointCount(f);
			
			cnt.addEventListener(VidiunEvent.COMPLETE, result);
			cnt.addEventListener(VidiunEvent.FAILED, fault);
			
			_client.post(cnt);	 
		}
		
		override public function result(data:Object):void
		{
			super.result(data);
			_model.decreaseLoadCounter();
			
			(_model.getDataPack(CuePointsDataPack) as CuePointsDataPack).cuepointsCount = parseInt(data.data);
			 
		}
	}
}