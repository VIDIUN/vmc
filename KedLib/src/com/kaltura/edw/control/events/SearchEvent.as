package com.vidiun.edw.control.events
{
	import com.vidiun.edw.vo.ListableVo;
	import com.vidiun.vmvc.control.VMvCEvent;

	public class SearchEvent extends VMvCEvent
	{
		
		
		public static const SEARCH_ENTRIES : String = "content_searchEntries";
		
		
		private var _listableVo : ListableVo;
		
		public function SearchEvent( type:String , 
									 listableVo:ListableVo,
									 bubbles:Boolean=false,
									 cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
			_listableVo = listableVo;
		}

		public function get listableVo():ListableVo
		{
			return _listableVo;
		}

	}
}