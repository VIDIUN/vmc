package com.vidiun.vmc.modules.content.commands.cat
{
	import com.adobe.cairngorm.control.CairngormEvent;
	import com.vidiun.commands.MultiRequest;
	import com.vidiun.commands.categoryUser.CategoryUserActivate;
	import com.vidiun.commands.categoryUser.CategoryUserDeactivate;
	import com.vidiun.events.VidiunEvent;
	import com.vidiun.vmc.modules.content.commands.VidiunCommand;
	import com.vidiun.vmc.modules.content.events.CategoryEvent;
	import com.vidiun.vmc.modules.content.events.CategoryUserEvent;
	import com.vidiun.vo.VidiunCategoryUser;
	
	import mx.controls.Alert;
	import mx.events.CloseEvent;
	import mx.resources.IResourceManager;
	import mx.resources.ResourceManager;
	
	public class ToggleCategoryUserStatusCommand extends VidiunCommand {
		
		private var _usrs:Array;
		private var _eventType:String;
		
		override public function execute(event:CairngormEvent):void {
			// event.data is [VidiunCategoryUser]
			_usrs = event.data;
			_eventType = event.type;
			
			if (!_model.categoriesModel.categoryUserFirstAction) {
				var rm:IResourceManager = ResourceManager.getInstance();
				Alert.show(rm.getString('cms', 'catUserFirstAction'), rm.getString('cms', 'catUserFirstActionTitle'), Alert.OK|Alert.CANCEL, null, afterConfirm);
				_model.categoriesModel.categoryUserFirstAction = true;
			}
			else {
				afterConfirm();
			}
		}
		
		private function afterConfirm(event:CloseEvent = null):void {
			if (event && event.detail == Alert.CANCEL) {
				return;
			}
			
			_model.increaseLoadCounter();
			
			var mr:MultiRequest = new MultiRequest();
			var cu:VidiunCategoryUser;
			for (var i:int = 0; i<_usrs.length; i++) {
				cu = _usrs[i] as VidiunCategoryUser;
				if (_eventType == CategoryUserEvent.DEACTIVATE_CATEGORY_USER) {
					mr.addAction(new CategoryUserDeactivate(cu.categoryId, cu.userId));
				}
				else {
					mr.addAction(new CategoryUserActivate(cu.categoryId, cu.userId));
				}
			} 			
			mr.addEventListener(VidiunEvent.COMPLETE, result);
			mr.addEventListener(VidiunEvent.FAILED, fault);
			_model.context.vc.post(mr);	   
			
		}
		
		override public function result(data:Object):void {
			super.result(data);
			var cg:CategoryEvent = new CategoryEvent(CategoryEvent.LIST_CATEGORY_USERS);
			cg.dispatch();
			_model.decreaseLoadCounter();
		}
	}
}