package com.vidiun.vmc.modules.content.commands.cat
{
	import com.adobe.cairngorm.control.CairngormEvent;
	import com.vidiun.commands.MultiRequest;
	import com.vidiun.commands.category.CategoryGet;
	import com.vidiun.commands.categoryUser.CategoryUserCopyFromCategory;
	import com.vidiun.events.VidiunEvent;
	import com.vidiun.vmc.modules.content.commands.VidiunCommand;
	import com.vidiun.vmc.modules.content.events.CategoryEvent;
	import com.vidiun.net.VidiunCall;
	import com.vidiun.vo.VidiunCategory;
	
	public class InheritUsersCommand extends VidiunCommand {
		
		
		override public function execute(event:CairngormEvent):void {
			_model.increaseLoadCounter();
			var catid:int = (event.data as VidiunCategory).id;
			var mr:MultiRequest = new MultiRequest();
			var call:VidiunCall = new CategoryUserCopyFromCategory(catid);
			mr.addAction(call);
			call = new CategoryGet(catid);
			mr.addAction(call);
			mr.addEventListener(VidiunEvent.COMPLETE, result);
			mr.addEventListener(VidiunEvent.FAILED, fault);
			_model.context.vc.post(mr);
			
		}
		
		override public function result(data:Object):void {
			super.result(data);
			if (!checkError(data)) {
				var cg:CategoryEvent = new CategoryEvent(CategoryEvent.LIST_CATEGORY_USERS);
				cg.dispatch();
				// set new numbers of members to the category object
				var updatedCat:VidiunCategory = data.data[data.data.length-1] as VidiunCategory;
				_model.categoriesModel.selectedCategory.membersCount = updatedCat.membersCount;
				_model.categoriesModel.selectedCategory.pendingMembersCount = updatedCat.pendingMembersCount;
			}
			_model.decreaseLoadCounter();
		}
	}
}