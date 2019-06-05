package com.vidiun.vmc.modules.analytics.model
{
	import mx.resources.ResourceManager;
	
	[Bindable]
	public class Notifications
	{
		public static const notificationMap : Object = { "1" : {"name":ResourceManager.getInstance().getStringArray('vmc','addEntry') , "clientEnabled":true }, 
														 "2" : {"name":ResourceManager.getInstance().getStringArray('vmc','updateEntryPermissions') , "clientEnabled":false},  
														 "3" : {"name":ResourceManager.getInstance().getStringArray('vmc','deleteEntry'), "clientEnabled":false},
														 "4" : {"name":ResourceManager.getInstance().getStringArray('vmc','blockEntry'), "clientEnabled":false},
														 "5" : {"name":ResourceManager.getInstance().getStringArray('vmc','updateEntry'), "clientEnabled":false},
														 "6" : {"name":ResourceManager.getInstance().getStringArray('vmc','updateEntryThumbnail'), "clientEnabled":false},
														 "7" : {"name":ResourceManager.getInstance().getStringArray('vmc','updateEntryModeration'), "clientEnabled":false},
														 "21": {"name":ResourceManager.getInstance().getStringArray('vmc','addUser'), "clientEnabled":false},
														 "26": {"name":ResourceManager.getInstance().getStringArray('vmc','bannedUser'), "clientEnabled":false}};
	}
}