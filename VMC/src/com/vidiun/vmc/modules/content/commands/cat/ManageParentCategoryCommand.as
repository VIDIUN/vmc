package com.vidiun.vmc.modules.content.commands.cat
{
	import com.adobe.cairngorm.control.CairngormEvent;
	import com.vidiun.commands.MultiRequest;
	import com.vidiun.commands.category.CategoryGet;
	import com.vidiun.commands.user.UserGet;
	import com.vidiun.errors.VidiunError;
	import com.vidiun.events.VidiunEvent;
	import com.vidiun.vmc.modules.content.commands.VidiunCommand;
	import com.vidiun.vmc.modules.content.events.CategoryEvent;
	import com.vidiun.types.VidiunInheritanceType;
	import com.vidiun.vo.VidiunCategory;
	import com.vidiun.vo.VidiunUser;
	
	import mx.controls.Alert;
	import mx.resources.ResourceManager;
	
	public class ManageParentCategoryCommand extends VidiunCommand{
		
		private var _eventType:String;
		
		override public function execute(event:CairngormEvent):void{
			_eventType = event.type;
			
			switch (event.type){
				case CategoryEvent.CLEAR_PARENT_CATEGORY:
					_model.categoriesModel.inheritedParentCategory = null;
					break;
				
				case CategoryEvent.GET_PARENT_CATEGORY:
				case CategoryEvent.GET_INHERITED_PARENT_CATEGORY:
					_model.increaseLoadCounter();
					var mr:MultiRequest = new MultiRequest();
					
					var selectedCat:VidiunCategory = event.data as VidiunCategory;
					var req:CategoryGet;
					if (event.type == CategoryEvent.GET_PARENT_CATEGORY) {
						req = new CategoryGet(selectedCat.parentId);
					}
					else if (event.type == CategoryEvent.GET_INHERITED_PARENT_CATEGORY) {
						req = new CategoryGet(selectedCat.inheritedParentId);
					}
					
					mr.addAction(req);
					
					// inheritedOwner
					var getOwner:UserGet = new UserGet("1"); // dummy value, overriden in 2 lines
					mr.addAction(getOwner);
					mr.mapMultiRequestParam(1, "owner", 2, "userId");
					
					mr.addEventListener(VidiunEvent.COMPLETE, result);
					mr.addEventListener(VidiunEvent.FAILED, fault);
		
					_model.context.vc.post(mr);
					
					break;
					
			}
		}
		
		override public function result(data:Object):void{
			super.result(data);
			_model.decreaseLoadCounter();
			
			if (!checkError(data)) {
				//inheritedOwner
				if (data.data[1] is VidiunUser) {
					_model.categoriesModel.inheritedOwner = data.data[1] as VidiunUser;
				}
				
				// category
				if (data.data[0] is VidiunCategory){
					_model.categoriesModel.inheritedParentCategory = data.data[0] as VidiunCategory;
				}
				else {
					Alert.show(ResourceManager.getInstance().getString('cms', 'error') + ": " +
						ResourceManager.getInstance().getString('cms', 'noMatchingParentError'));
				}
				
			}
		}
	}
}