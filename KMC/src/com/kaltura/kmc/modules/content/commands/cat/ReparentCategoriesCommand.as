package com.vidiun.vmc.modules.content.commands.cat
{
	import com.adobe.cairngorm.control.CairngormEvent;
	import com.vidiun.commands.category.CategoryMove;
	import com.vidiun.errors.VidiunError;
	import com.vidiun.events.VidiunEvent;
	import com.vidiun.vmc.modules.content.commands.VidiunCommand;
	import com.vidiun.vmc.modules.content.events.CatTrackEvent;
	import com.vidiun.vmc.modules.content.events.CategoryEvent;
	import com.vidiun.vo.VidiunCategory;
	
	import mx.controls.Alert;
	import mx.events.CloseEvent;
	import mx.resources.IResourceManager;
	import mx.resources.ResourceManager;

	public class ReparentCategoriesCommand extends VidiunCommand {
		
		
		private var cats:Array;
		
		private var newParent:int;
		
		override public function execute(event:CairngormEvent):void
		{
			cats = event.data[0] as Array;
			newParent = (event.data[1] as VidiunCategory).id;
			var rm:IResourceManager = ResourceManager.getInstance();
			
			if (!cats || cats.length == 0) {
				// no categories
				Alert.show(rm.getString('entrytable', 'selectCategoriesFirst'), rm.getString('cms', 'selectCategoriesFirstTitle'));
				return;
			}
			// verify all cats have the same parent:
			var origParentId:int = (cats[0] as VidiunCategory).parentId;
			for each (var vCat:VidiunCategory in cats) {
				if (vCat.parentId != origParentId) {
					Alert.show(rm.getString('cms', 'bulkMoveDeny'));
					return;
				}
			}
			
			// let the user know this is an async action:
			Alert.show(rm.getString('cms', 'asyncCategoryWarn'), rm.getString('cms', 'attention'), Alert.OK|Alert.CANCEL, null, moveCats);
			
		}
		
		
		/**
		 * move categories to new parent
		 * */
		private function moveCats(e:CloseEvent):void {
			if (e.detail == Alert.OK) {
				_model.increaseLoadCounter();
				var idstr:String = '';;
				for each (var vCat:VidiunCategory in cats) {
					idstr += vCat.id + ",";
				}
				var move:CategoryMove = new CategoryMove(idstr, newParent);
				
				move.addEventListener(VidiunEvent.COMPLETE, result);
				move.addEventListener(VidiunEvent.FAILED, fault);
				_model.context.vc.post(move);
				
			}
		}
		
		override public function result(data:Object):void {
			super.result(data);
			_model.decreaseLoadCounter();
			var rm:IResourceManager = ResourceManager.getInstance();
			var er:VidiunError = (data as VidiunEvent).error;
			if (er) { 
				Alert.show(getErrorText(er), rm.getString('cms', 'error'));
				return;
			}
			
			if (_model.filterModel.catTreeDataManager) {
				_model.filterModel.catTreeDataManager.resetData();
			}
			
			var cgEvent:CairngormEvent = new CategoryEvent(CategoryEvent.LIST_CATEGORIES);
			cgEvent.dispatch();
			cgEvent = new CatTrackEvent(CatTrackEvent.UPDATE_STATUS);
			cgEvent.dispatch();
			
		}
	}
}