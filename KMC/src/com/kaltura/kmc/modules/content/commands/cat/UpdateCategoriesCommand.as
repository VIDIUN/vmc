package com.vidiun.vmc.modules.content.commands.cat
{
	import com.adobe.cairngorm.control.CairngormEvent;
	import com.vidiun.commands.MultiRequest;
	import com.vidiun.commands.category.CategoryUpdate;
	import com.vidiun.events.VidiunEvent;
	import com.vidiun.vmc.business.CategoryUtils;
	import com.vidiun.vmc.modules.content.commands.VidiunCommand;
	import com.vidiun.vmc.modules.content.events.CategoryEvent;
	import com.vidiun.vo.VidiunCategory;
	
	import mx.controls.Alert;
	import mx.events.CloseEvent;
	import mx.resources.ResourceManager;
	
	public class UpdateCategoriesCommand extends VidiunCommand {
		
		private var _categories:Array;
		
		private var _numOfGroups:int = 1;
		private var _callsCompleted:int = 0;
		private var _callFailed:Boolean = false;
		
		override public function execute(event:CairngormEvent):void
		{
			_categories = event.data as Array;
			if (_categories.length > 50) {
				Alert.show(ResourceManager.getInstance().getString('cms', 'updateLotsOfCategoriesMsg', [_categories.length]),
					ResourceManager.getInstance().getString('cms', 'updateLotsOfEntriesTitle'),
					Alert.YES | Alert.NO, null, responesFnc);
			}
			// for small update
			else {
				_model.increaseLoadCounter();
				var mr:MultiRequest = new MultiRequest();
				for each (var vCat:VidiunCategory in _categories) {
					vCat.setUpdatedFieldsOnly(true);
					CategoryUtils.resetUnupdateableFields(vCat);
					var update:CategoryUpdate = new CategoryUpdate(vCat.id, vCat);
					mr.addAction(update);
				}
				
				mr.addEventListener(VidiunEvent.COMPLETE, result);
				mr.addEventListener(VidiunEvent.FAILED, fault);
				_model.context.vc.post(mr); 
			}
		}
		
		
		
		/**
		 * handle large update
		 * */
		private function responesFnc(event:CloseEvent):void {
			if (event.detail == Alert.YES) {
				
				// update:
				_numOfGroups = Math.floor(_categories.length / 50);
				var lastGroupSize:int = _categories.length % 50;
				if (lastGroupSize != 0) {
					_numOfGroups++;
				}
				
				var groupSize:int;
				var mr:MultiRequest;
				for (var groupIndex:int = 0; groupIndex < _numOfGroups; groupIndex++) {
					mr = new MultiRequest();
					mr.addEventListener(VidiunEvent.COMPLETE, result);
					mr.addEventListener(VidiunEvent.FAILED, fault);
					mr.queued = false;
					
					groupSize = (groupIndex < (_numOfGroups - 1)) ? 50 : lastGroupSize;
					for (var entryIndexInGroup:int = 0; entryIndexInGroup < groupSize; entryIndexInGroup++) {
						var index:int = ((groupIndex * 50) + entryIndexInGroup);
						var keepId:int = (_categories[index] as VidiunCategory).id;
						var vCat:VidiunCategory = _categories[index] as VidiunCategory;
						vCat.setUpdatedFieldsOnly(true);
						CategoryUtils.resetUnupdateableFields(vCat);
						
						var update:CategoryUpdate = new CategoryUpdate(keepId, vCat);
						mr.addAction(update);
					}
					_model.increaseLoadCounter();
					_model.context.vc.post(mr);
				}
			}
			else {
				// announce no update:
				Alert.show(ResourceManager.getInstance().getString('cms', 'noUpdateMadeMsg'),
					ResourceManager.getInstance().getString('cms', 'noUpdateMadeTitle'));
			}
		}
		
		override public function result(data:Object):void {
			super.result(data);
			_model.decreaseLoadCounter();
			
			_callsCompleted ++;
			_callFailed ||= checkError(data);
			if (_callsCompleted == _numOfGroups) {
				if (!_callFailed) {
					Alert.show(ResourceManager.getInstance().getString('cms', 'catUpdtSuccess'));
				}
				
				// reload categories for table (also if no update, so values will be reset)
				var getCategoriesList:CategoryEvent = new CategoryEvent(CategoryEvent.LIST_CATEGORIES);
				getCategoriesList.dispatch();
			}
		}
	}
}