package com.vidiun.vmc.modules.content.commands {
	import com.adobe.cairngorm.commands.ICommand;
	import com.adobe.cairngorm.control.CairngormEvent;
	import com.vidiun.vmc.modules.content.events.SetListableEvent;
	import com.vidiun.vmc.modules.content.model.CmsModelLocator;

	public class SetCurrentListableCommand extends VidiunCommand {

		override public function execute(event:CairngormEvent):void {
			_model.listableVo = (event as SetListableEvent).listableVo;

		}
	}
}