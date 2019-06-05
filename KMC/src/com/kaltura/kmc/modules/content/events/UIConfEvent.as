package com.vidiun.vmc.modules.content.events
{
	import com.adobe.cairngorm.control.CairngormEvent;
	import com.vidiun.vo.VidiunUiConfFilter;
	
	public class UIConfEvent extends CairngormEvent
	{
		public static const LIST_UI_CONFS : String = "content_listUIConfs";
		
		public var uiConfFilter:VidiunUiConfFilter;
		
		public function UIConfEvent(type:String, filterVo:VidiunUiConfFilter, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
			this.uiConfFilter = filterVo;
		}

	}
}