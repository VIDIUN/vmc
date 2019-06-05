package com.vidiun.vmc.modules.content.events
{
	import com.adobe.cairngorm.control.CairngormEvent;
	import com.vidiun.edw.business.IDataOwner;
	import com.vidiun.vo.VidiunMediaEntryFilterForPlaylist;

	public class VMCFilterEvent extends CairngormEvent
	{
		public static const SET_FILTER_TO_MODEL : String = "content_setFilterToModel";
		
		
		private var _filterVo : VidiunMediaEntryFilterForPlaylist;
		
		
		
		public function VMCFilterEvent(type:String, filterVo : VidiunMediaEntryFilterForPlaylist, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
			_filterVo = filterVo;
		}

		public function get filterVo():VidiunMediaEntryFilterForPlaylist
		{
			return _filterVo;
		}
		
		

	}
}