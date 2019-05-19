package com.vidiun.autocomplete.itemRenderers
{
	import com.vidiun.autocomplete.itemRenderers.selection.UserSelectedItem;
	
	public class UserFilterSelectedItem extends UserSelectedItem
	{
		override protected function getUnregisteredMsg(userId:String):String{
			return resourceManager.getString("autocomplete", "unregisteredUserForFilterMsg");
		}
	}
}