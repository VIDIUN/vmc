package com.vidiun.vmc.modules.account.control.events
{
	import com.adobe.cairngorm.control.CairngormEvent;
	import com.vidiun.vo.VidiunUserFilter;
	
	public class UserEvent extends CairngormEvent {
		
		public static const LIST_USERS:String = "account_listUsers";
		
		public function UserEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}

	}
}