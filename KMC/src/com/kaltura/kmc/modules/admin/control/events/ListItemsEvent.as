package com.vidiun.vmc.modules.admin.control.events
{
	import com.adobe.cairngorm.control.CairngormEvent;
	import com.vidiun.vo.VidiunFilter;
	import com.vidiun.vo.VidiunFilterPager;
	
	public class ListItemsEvent extends CairngormEvent {
		
		public static const LIST_ROLES:String = "admin_listRoles";
		public static const LIST_USERS:String = "admin_listUsers";
		public static const LIST_PARTNER_PERMISSIONS:String = "admin_listPartnerPermissions";
		
		private var _filter:VidiunFilter;
		private var _pager:VidiunFilterPager;
		
		
		public function ListItemsEvent(type:String, filter:VidiunFilter = null, pager:VidiunFilterPager = null, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
			_filter = filter;
			_pager = pager;
		}

		public function get filter():VidiunFilter
		{
			return _filter;
		}

		public function get pager():VidiunFilterPager
		{
			return _pager;
		}


	}
}