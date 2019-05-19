package com.vidiun.edw.control.commands.customData
{
	import com.vidiun.commands.metadataProfile.MetadataProfileGet;
	import com.vidiun.edw.business.EntryFormBuilder;
	import com.vidiun.edw.control.commands.VedCommand;
	import com.vidiun.edw.control.events.MetadataProfileEvent;
	import com.vidiun.edw.model.FilterModel;
	import com.vidiun.edw.model.datapacks.FilterDataPack;
	import com.vidiun.events.VidiunEvent;
	import com.vidiun.vmvc.control.VMvCEvent;
	import com.vidiun.vo.VMCMetadataProfileVO;
	import com.vidiun.vo.VidiunMetadataProfile;

	public class GetMetadataProfileCommand extends VedCommand
	{
		override public function execute(event:VMvCEvent):void {
			_model.increaseLoadCounter();
			var profileId:int = (event as MetadataProfileEvent).profileId;
			if (profileId != -1) {
				var getMetadataProfile:MetadataProfileGet = new MetadataProfileGet(profileId);
				getMetadataProfile.addEventListener(VidiunEvent.COMPLETE, result);
				getMetadataProfile.addEventListener(VidiunEvent.FAILED, fault);
				
				_client.post(getMetadataProfile);
			}
		}
		
		override public function result(data:Object):void {
			var recievedProfile:VidiunMetadataProfile = data.data as VidiunMetadataProfile;
			var filterModel:FilterModel = (_model.getDataPack(FilterDataPack) as FilterDataPack).filterModel;
			if (recievedProfile) {
				for (var i:int = 0; i<filterModel.metadataProfiles.length; i++) {
					var profile:VMCMetadataProfileVO = filterModel.metadataProfiles[i] as VMCMetadataProfileVO;
					if (profile.profile.id == recievedProfile.id) {
						profile.profile = recievedProfile;
						(filterModel.formBuilders[i] as EntryFormBuilder).metadataProfile = profile;
						break;
					}
				}
			}
			_model.decreaseLoadCounter();
			
		}
	}
}