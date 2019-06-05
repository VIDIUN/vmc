package com.vidiun.edw.control.commands {
	import com.adobe.cairngorm.control.CairngormEvent;
	import com.vidiun.commands.conversionProfile.ConversionProfileList;
	import com.vidiun.edw.control.commands.VedCommand;
	import com.vidiun.edw.model.datapacks.FlavorsDataPack;
	import com.vidiun.events.VidiunEvent;
	import com.vidiun.vmvc.control.VMvCEvent;
	import com.vidiun.types.VidiunConversionProfileType;
	import com.vidiun.types.VidiunNullableBoolean;
	import com.vidiun.vo.VidiunConversionProfile;
	import com.vidiun.vo.VidiunConversionProfileFilter;
	import com.vidiun.vo.VidiunConversionProfileListResponse;
	import com.vidiun.vo.VidiunFilterPager;
	
	import mx.collections.ArrayCollection;

	[ResourceBundle("live")]
	
	public class ListLiveConversionProfilesCommand extends VedCommand {

		override public function execute(event:VMvCEvent):void {
			
			var p:VidiunFilterPager = new VidiunFilterPager();
			p.pageIndex = 1;
			p.pageSize = 500; // trying to get all conversion profiles here, standard partner has no more than 10
			var f:VidiunConversionProfileFilter = new VidiunConversionProfileFilter();
			f.typeEqual = VidiunConversionProfileType.LIVE_STREAM;
			var listProfiles:ConversionProfileList = new ConversionProfileList(f, p);
			listProfiles.addEventListener(VidiunEvent.COMPLETE, result);
			listProfiles.addEventListener(VidiunEvent.FAILED, fault);
			_model.increaseLoadCounter();
			_client.post(listProfiles);
		}


		override public function result(data:Object):void {
			super.result(data);
			
			var result:Array = new Array();
			for each (var vcp:VidiunConversionProfile in (data.data as VidiunConversionProfileListResponse).objects) {
				if (vcp.isDefault == VidiunNullableBoolean.TRUE_VALUE) {
					result.unshift(vcp);
				}
				else {
					result.push(vcp);
				}
			}
			var fdp:FlavorsDataPack = _model.getDataPack(FlavorsDataPack) as FlavorsDataPack;
			fdp.liveConversionProfiles = new ArrayCollection(result);
			_model.decreaseLoadCounter();

		}
	}
}
