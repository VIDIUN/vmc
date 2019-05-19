package com.vidiun.vmc.modules.content.commands
{
	import com.adobe.cairngorm.commands.ICommand;
	import com.adobe.cairngorm.control.CairngormEvent;
	import com.vidiun.commands.media.MediaListFlags;
	import com.vidiun.events.VidiunEvent;
	import com.vidiun.vo.VidiunBaseEntry;
	import com.vidiun.vo.VidiunFilterPager;
	import com.vidiun.vo.VidiunModerationFlag;
	import com.vidiun.vo.VidiunModerationFlagListResponse;
	
	import mx.rpc.IResponder;
	import com.vidiun.vmc.modules.content.events.VMCEntryEvent;

	public class ListModerationCommand extends VidiunCommand implements ICommand, IResponder
	{
		private var _currentEntry : VidiunBaseEntry;
		override public function execute(event:CairngormEvent):void
		{
			var e : VMCEntryEvent = event as VMCEntryEvent;
			_currentEntry = e.entryVo;
			var pg:VidiunFilterPager = new VidiunFilterPager();
			pg.pageSize = 500;
			pg.pageIndex = 0;
			var mlf:MediaListFlags= new MediaListFlags(_currentEntry.id,pg);
		 	mlf.addEventListener(VidiunEvent.COMPLETE, result);
			mlf.addEventListener(VidiunEvent.FAILED, fault);
			_model.context.vc.post(mlf);
		}
		
		override public function result(data:Object):void
		{
			var vmflr:VidiunModerationFlagListResponse;
			var vmf:VidiunModerationFlag;
			_model.moderationModel.moderationsArray.source = data.data.objects as Array;
		}
	}
}