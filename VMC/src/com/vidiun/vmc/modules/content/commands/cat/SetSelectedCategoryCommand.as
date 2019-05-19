package com.vidiun.vmc.modules.content.commands.cat
{
	import com.adobe.cairngorm.control.CairngormEvent;
	import com.vidiun.vmc.modules.content.commands.VidiunCommand;
	import com.vidiun.vo.VidiunCategory;
	
	public class SetSelectedCategoryCommand extends VidiunCommand
	{
		override public function execute(event:CairngormEvent):void{
			var catToSet:VidiunCategory = event.data as VidiunCategory;
			_model.categoriesModel.selectedCategory = catToSet;
		}

	}
}