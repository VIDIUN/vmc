package com.vidiun.vmc.modules.analytics.model.types
{
	import com.vidiun.types.VidiunSearchProviderType;
	import com.vidiun.types.VidiunSourceType;
	
	import mx.resources.ResourceManager;

	public class ContributionTypes
	{
		public static function getContributionType(type:int):String
		{
			switch (type)
			{
				// mix entries have no source attribute in DB, so we get -1 for them.
				case -1:
					return ResourceManager.getInstance().getString('sourceTypes', 'UNKNOWN');
					break;
				case int(VidiunSourceType.FILE):
					return ResourceManager.getInstance().getString('sourceTypes', 'FILE');
					break;
				case int(VidiunSourceType.SEARCH_PROVIDER):
					return ResourceManager.getInstance().getString('sourceTypes', 'SEARCH_PROVIDER');
					break;
				case int(VidiunSourceType.URL):
					return ResourceManager.getInstance().getString('sourceTypes', 'URL');
					break;
				case int(VidiunSourceType.WEBCAM):
					return ResourceManager.getInstance().getString('sourceTypes', 'WEBCAM');
					break;
				case VidiunSearchProviderType.FLICKR:
					return ResourceManager.getInstance().getString('sourceTypes', 'FLICKR');
					break;
				case VidiunSearchProviderType.ARCHIVE_ORG:
					return ResourceManager.getInstance().getString('sourceTypes', 'ARCHIVE_ORG');
					break;
				case VidiunSearchProviderType.CCMIXTER:
					return ResourceManager.getInstance().getString('sourceTypes', 'CCMIXTER');
					break;
				case VidiunSearchProviderType.CURRENT:
					return ResourceManager.getInstance().getString('sourceTypes', 'CURRENT');
					break;
				case VidiunSearchProviderType.JAMENDO:
					return ResourceManager.getInstance().getString('sourceTypes', 'JAMENDO');
					break;
				case VidiunSearchProviderType.VIDIUN:
					return ResourceManager.getInstance().getString('sourceTypes', 'VIDIUN');
					break;
				case VidiunSearchProviderType.VIDIUN_PARTNER:
					return ResourceManager.getInstance().getString('sourceTypes', 'VIDIUN_PARTNER');
					break;
				case VidiunSearchProviderType.VIDIUN_USER_CLIPS:
					return ResourceManager.getInstance().getString('sourceTypes', 'VIDIUN_USER_CLIPS');
					break;
				case VidiunSearchProviderType.MEDIA_COMMONS:
					return ResourceManager.getInstance().getString('sourceTypes', 'MEDIA_COMMONS');
					break;
				case VidiunSearchProviderType.METACAFE:
					return ResourceManager.getInstance().getString('sourceTypes', 'METACAFE');
					break;
				case VidiunSearchProviderType.MYSPACE:
					return ResourceManager.getInstance().getString('sourceTypes', 'MYSPACE');
					break;
				case VidiunSearchProviderType.NYPL:
					return ResourceManager.getInstance().getString('sourceTypes', 'NYPL');
					break;
				case VidiunSearchProviderType.PHOTOBUCKET:
					return ResourceManager.getInstance().getString('sourceTypes', 'PHOTOBUCKET');
					break;
				case VidiunSearchProviderType.YOUTUBE:
					return ResourceManager.getInstance().getString('sourceTypes', 'YOUTUBE');
					break;
				case VidiunSearchProviderType.SEARCH_PROXY:
					return ResourceManager.getInstance().getString('sourceTypes', 'SEARCH_PROXY');
					break;
			}

			return "";
		}
	}
}