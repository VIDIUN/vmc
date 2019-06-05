package com.vidiun.vmc.modules.content.commands
{
	import com.adobe.cairngorm.commands.ICommand;
	import com.vidiun.vmc.modules.content.events.SetSyndicationPagerEvent;
	
	public class setSyndicationFeedsFilterPager extends VidiunCommand implements ICommand {
		
		
		override public function execute(event:CairngormEvent):void
		{
			_model.extSynModel.syndicationFeedsFilterPager = (event as SetSyndicationPagerEvent).pager;
		}
	}
}