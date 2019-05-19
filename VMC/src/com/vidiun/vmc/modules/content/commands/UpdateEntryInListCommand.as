package com.vidiun.vmc.modules.content.commands
{
	import com.adobe.cairngorm.control.CairngormEvent;
	import com.vidiun.edw.business.EntryUtil;
	import com.vidiun.vo.VidiunBaseEntry;

	public class UpdateEntryInListCommand extends VidiunCommand {
		
		override public function execute(event:CairngormEvent):void {
			//if in the entries list there's an entry with the same id, replace it.
			EntryUtil.updateSelectedEntryInList((event.data as VidiunBaseEntry), _model.listableVo.arrayCollection);
		}
	}
}