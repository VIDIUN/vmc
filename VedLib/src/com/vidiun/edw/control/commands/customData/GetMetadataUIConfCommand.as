package com.vidiun.edw.control.commands.customData
{
	import com.vidiun.commands.uiConf.UiConfGet;
	import com.vidiun.edw.control.commands.VedCommand;
	import com.vidiun.edw.model.datapacks.CustomDataDataPack;
	import com.vidiun.events.VidiunEvent;
	import com.vidiun.vmvc.control.VMvCEvent;
	import com.vidiun.vo.VidiunUiConf;
	
	/**
	 * This class will get the default metadata view and save the uiconf xml on the entryDetailsModel.
	 * @author Michal
	 * 
	 */
	public class GetMetadataUIConfCommand extends VedCommand
	{
		
		override public function execute(event:VMvCEvent):void {
			_model.increaseLoadCounter();

			var uiconfRequest:UiConfGet = new UiConfGet(CustomDataDataPack.metadataDefaultUiconf);
			uiconfRequest.addEventListener(VidiunEvent.COMPLETE, result);
			uiconfRequest.addEventListener(VidiunEvent.FAILED, fault);
			
			_client.post(uiconfRequest);
		}
		
		override public function result(data:Object):void {
			super.result(data);
			var result:VidiunUiConf = data.data as VidiunUiConf;
			if (result)
				CustomDataDataPack.metadataDefaultUiconfXML = new XML(result.confFile);
			
			_model.decreaseLoadCounter();
			
		}
	}
}