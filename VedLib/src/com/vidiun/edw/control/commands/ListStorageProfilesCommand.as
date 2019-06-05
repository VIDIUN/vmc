package com.vidiun.edw.control.commands
{
	import com.vidiun.commands.storageProfile.StorageProfileList;
	import com.vidiun.core.VClassFactory;
	import com.vidiun.edw.business.ClientUtil;
	import com.vidiun.edw.control.commands.VedCommand;
	import com.vidiun.edw.model.datapacks.FlavorsDataPack;
	import com.vidiun.errors.VidiunError;
	import com.vidiun.events.VidiunEvent;
	import com.vidiun.vmvc.control.VMvCEvent;
	import com.vidiun.vo.VidiunStorageProfile;
	import com.vidiun.vo.VidiunStorageProfileListResponse;
	
	import mx.collections.ArrayCollection;
	import mx.controls.Alert;

	public class ListStorageProfilesCommand extends VedCommand {
		
		override public function execute(event:VMvCEvent):void {
			_model.increaseLoadCounter();
			var lsp:StorageProfileList = new StorageProfileList();
			lsp.addEventListener(VidiunEvent.COMPLETE, result);
			lsp.addEventListener(VidiunEvent.FAILED, fault);
			_client.post(lsp);
		}
		
		
		override public function result(event:Object):void {
			// error handling
			var er:VidiunError ;
			if (event.error) {
				er = event.error as VidiunError;
				if (er) {
					Alert.show(er.errorMsg, "Error");
				}
			}
			
			// result
			else {
				// assume what we got are remote storage profiles, even if we got something that inherits (ie, object)
				var objects:Array = (event.data as VidiunStorageProfileListResponse).objects;
				var profiles:Array = new Array();
				var profile:VidiunStorageProfile;
				for each (var obj:Object in objects) {
					if (!(obj is VidiunStorageProfile)) {
						profile = ClientUtil.createClassInstanceFromObject(VidiunStorageProfile, obj);
					}
					else {
						profile = obj as VidiunStorageProfile;
					}
					profiles.push(profile);
				}
				
				(_model.getDataPack(FlavorsDataPack) as FlavorsDataPack).storageProfiles = new ArrayCollection(profiles);
			}	
			_model.decreaseLoadCounter();
		}
	}
}