package com.vidiun.vmc.modules.content.commands
{
	import com.adobe.cairngorm.commands.ICommand;
	import com.adobe.cairngorm.control.CairngormEvent;
	import com.vidiun.vmc.modules.content.events.VMCFilterEvent;

	public class SetFilterToModelCommand extends VidiunCommand implements ICommand
	{
		override public function execute(event:CairngormEvent):void
		{
			
			_model.playlistModel.onTheFlyFilter = (event as VMCFilterEvent).filterVo;
		}
	}
}