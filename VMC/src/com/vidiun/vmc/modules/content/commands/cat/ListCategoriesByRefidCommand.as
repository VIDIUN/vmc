package com.vidiun.vmc.modules.content.commands.cat {
	import com.adobe.cairngorm.control.CairngormEvent;
	import com.vidiun.commands.category.CategoryList;
	import com.vidiun.events.VidiunEvent;
	import com.vidiun.vmc.modules.content.commands.VidiunCommand;
	import com.vidiun.vo.VidiunCategory;
	import com.vidiun.vo.VidiunCategoryFilter;
	import com.vidiun.vo.VidiunCategoryListResponse;

	public class ListCategoriesByRefidCommand extends VidiunCommand {
		
		override public function execute(event:CairngormEvent):void {
			_model.increaseLoadCounter();

			var f:VidiunCategoryFilter = new VidiunCategoryFilter();
			f.referenceIdEqual = (event.data as VidiunCategory).referenceId;
			
			var catList:CategoryList = new CategoryList(f);
			catList.addEventListener(VidiunEvent.COMPLETE, result);
			catList.addEventListener(VidiunEvent.FAILED, fault);
			_model.context.vc.post(catList);
		}


		override public function result(data:Object):void {
			super.result(data);
			if (!checkError(data)) {
				var recievedData:VidiunCategoryListResponse = VidiunCategoryListResponse(data.data);
				_model.categoriesModel.categoriesWSameRefidAsSelected = recievedData.objects;
			}
			_model.decreaseLoadCounter();
		}

	}
}
