package com.vidiun.vmc.modules.content.commands.live {
	import com.adobe.cairngorm.control.CairngormEvent;
	import com.vidiun.commands.conversionProfile.ConversionProfileList;
	import com.vidiun.events.VidiunEvent;
	import com.vidiun.vmc.modules.content.commands.VidiunCommand;
	import com.vidiun.types.VidiunConversionProfileType;
	import com.vidiun.types.VidiunNullableBoolean;
	import com.vidiun.vo.VidiunConversionProfile;
	import com.vidiun.vo.VidiunConversionProfileFilter;
	import com.vidiun.vo.VidiunConversionProfileListResponse;
	import com.vidiun.vo.VidiunFilterPager;
	
	import mx.collections.ArrayCollection;

	[ResourceBundle("live")]
	
	public class ListLiveConversionProfilesCommand extends VidiunCommand {

		override public function execute(event:CairngormEvent):void {
			
			var p:VidiunFilterPager = new VidiunFilterPager();
			p.pageIndex = 1;
			p.pageSize = 500; // trying to get all conversion profiles here, standard partner has no more than 10
			var f:VidiunConversionProfileFilter = new VidiunConversionProfileFilter();
			f.typeEqual = VidiunConversionProfileType.LIVE_STREAM;
			var listProfiles:ConversionProfileList = new ConversionProfileList(f, p);
			listProfiles.addEventListener(VidiunEvent.COMPLETE, result);
			listProfiles.addEventListener(VidiunEvent.FAILED, fault);
			_model.increaseLoadCounter();
			_model.context.vc.post(listProfiles);
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
			
			_model.liveConversionProfiles = new ArrayCollection(result);
			_model.decreaseLoadCounter();

		}
	}
}
