package com.vidiun.vmc.modules.content.events
{
	import com.adobe.cairngorm.control.CairngormEvent;
	import com.vidiun.vo.VidiunFilterPager;
	
	public class SetSyndicationPagerEvent extends CairngormEvent {
		
		public static const SET_PAGER:String = "content_setPager";
		
		private var _pager:VidiunFilterPager;
		
		public function SetSyndicationPagerEvent(type:String, pager:VidiunFilterPager = null, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			_pager = pager;
			super(type, bubbles, cancelable);
		}

		public function get pager():VidiunFilterPager
		{
			return _pager;
		}

	}
}