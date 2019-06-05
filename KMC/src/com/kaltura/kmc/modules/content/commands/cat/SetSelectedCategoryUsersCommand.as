package com.vidiun.vmc.modules.content.commands.cat
{
	import com.adobe.cairngorm.control.CairngormEvent;
	import com.vidiun.vmc.modules.content.commands.VidiunCommand;
	
	public class SetSelectedCategoryUsersCommand extends VidiunCommand {
		
		override public function execute(event:CairngormEvent):void {
			// event.data is [VidiunCategoryUser]
			_model.categoriesModel.selectedCategoryUsers = event.data;
		}
	}
}