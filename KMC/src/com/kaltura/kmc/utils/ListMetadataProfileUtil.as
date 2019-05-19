package com.vidiun.vmc.utils
{
	import com.vidiun.vmc.modules.account.model.Context;
	import com.vidiun.types.VidiunMetadataProfileCreateMode;
	import com.vidiun.utils.parsers.MetadataProfileParser;
	import com.vidiun.vo.VMCMetadataProfileVO;
	import com.vidiun.vo.VidiunMetadataProfile;
	import com.vidiun.vo.VidiunMetadataProfileListResponse;
	
	import mx.collections.ArrayCollection;

	/**
	 * This class it intended for creating a "listMetadataProfile" request
	 * and handling the response. Since the "list" request is sent from various places we will handle the result in this util. 
	 * @author Michal
	 * 
	 */	
	public class ListMetadataProfileUtil
	{
		/**
		 * This function will parse the given object and return an arrayCollection of the 
		 * suitable VMCMetadataProfileVO classes 
		 * @param response is the VidiunMetadataProfileList response, returned from the server
		 * @param context is the Context that will be used for the download url
		 * @return arrayCollection
		 */		
		public static function handleListMetadataResult(response:VidiunMetadataProfileListResponse, context:Context) : ArrayCollection 
		{
			var profilesArray:ArrayCollection = new ArrayCollection();
		
			if (response.objects) {
				for (var i:int = 0; i< response.objects.length; i++ ) {
					var recievedProfile:VidiunMetadataProfile = response.objects[i] as VidiunMetadataProfile;
					if (!recievedProfile)
						continue;
					var metadataProfile : VMCMetadataProfileVO = new VMCMetadataProfileVO();
					metadataProfile.profile = recievedProfile;
					metadataProfile.id = recievedProfile.id;
					metadataProfile.downloadUrl = context.vc.protocol + context.vc.domain + VMCMetadataProfileVO.serveURL + "/vs/" + context.vc.vs + "/id/" + recievedProfile.id;
					//parses only profiles that were created from VMC
					if (!(recievedProfile.createMode) || (recievedProfile.createMode == VidiunMetadataProfileCreateMode.VMC)) {
						try {
							metadataProfile.xsd = new XML(recievedProfile.xsd);
							metadataProfile.metadataFieldVOArray = MetadataProfileParser.fromXSDtoArray(metadataProfile.xsd);
						}
						catch (er:Error) {
							metadataProfile.profileDisabled = true;	
						}
					}
					//none VMC profile
					else {
						metadataProfile.profileDisabled = true;
					}
					
					profilesArray.addItem(metadataProfile);
				}
			}
			return profilesArray;
		}
	}
}