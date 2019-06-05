package com.vidiun.vmc.modules.content.commands.cat
{
	import com.adobe.cairngorm.control.CairngormEvent;
	import com.vidiun.vmc.modules.content.commands.VidiunCommand;
	
	public class SetRefreshCatsRequiredCommand extends VidiunCommand
	{
		override public function execute(event:CairngormEvent):void {
			_model.categoriesModel.refreshCategoriesRequired = event.data;
		}
	}
}