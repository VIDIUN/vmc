package com.vidiun.vmc.modules.content.utils
{
	import com.vidiun.types.VidiunCategoryUserPermissionLevel;

	public class CategoryUserUtil
	{
		public function CategoryUserUtil()
		{
		}
		
		
		public static function getPermissionNames(permissionLevel:int):String {
			var result:String;
			switch(permissionLevel) {
				case VidiunCategoryUserPermissionLevel.MEMBER:
					result = "CATEGORY_VIEW";
					break;
				case VidiunCategoryUserPermissionLevel.CONTRIBUTOR:
					result = "CATEGORY_CONTRIBUTE,CATEGORY_VIEW";
					break;
				case VidiunCategoryUserPermissionLevel.MODERATOR:
					result = "CATEGORY_MODERATE,CATEGORY_CONTRIBUTE,CATEGORY_VIEW";
					break;
				case VidiunCategoryUserPermissionLevel.MANAGER:
					result = "CATEGORY_EDIT,CATEGORY_MODERATE,CATEGORY_CONTRIBUTE,CATEGORY_VIEW";
					break;
			}
			return result;
		}
	}
}