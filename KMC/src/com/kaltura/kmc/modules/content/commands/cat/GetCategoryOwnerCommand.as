package com.vidiun.vmc.modules.content.commands.cat
{
	import com.adobe.cairngorm.control.CairngormEvent;
	import com.vidiun.commands.user.UserGet;
	import com.vidiun.errors.VidiunError;
	import com.vidiun.events.VidiunEvent;
	import com.vidiun.vmc.modules.content.commands.VidiunCommand;
	import com.vidiun.vmc.modules.content.events.CategoryEvent;
	import com.vidiun.vo.VidiunCategory;
	import com.vidiun.vo.VidiunUser;
	
	public class GetCategoryOwnerCommand extends VidiunCommand {
		
		override public function execute(event:CairngormEvent):void{
			
			switch (event.type){
				case CategoryEvent.CLEAR_CATEGORY_OWNER:
					_model.categoriesModel.categoryOwner = null;
					_model.categoriesModel.inheritedOwner = null;
					break;
				
				case CategoryEvent.GET_CATEGORY_OWNER:
					
					var selectedCat:VidiunCategory = event.data as VidiunCategory;
					var req:UserGet = new UserGet(selectedCat.owner);
					
					req.addEventListener(VidiunEvent.COMPLETE, result);
					req.addEventListener(VidiunEvent.FAILED, fault);
					
					_model.increaseLoadCounter();
					_model.context.vc.post(req);
					break;
				
			}
		}
		
		override public function result(data:Object):void{
			super.result(data);
			_model.decreaseLoadCounter();
			
			if (!checkError(data)) {
				_model.categoriesModel.categoryOwner = data.data as VidiunUser;
			}
		}
	}
}