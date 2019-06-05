package com.vidiun.vmc.modules.content.commands.cat
{
	import com.adobe.cairngorm.control.CairngormEvent;
	import com.vidiun.commands.MultiRequest;
	import com.vidiun.commands.category.CategoryUpdate;
	import com.vidiun.events.VidiunEvent;
	import com.vidiun.vmc.business.CategoryUtils;
	import com.vidiun.vmc.modules.content.commands.VidiunCommand;
	import com.vidiun.vmc.modules.content.events.CategoryEvent;
	import com.vidiun.types.VidiunInheritanceType;
	import com.vidiun.vo.VidiunCategory;
	
	import mx.controls.Alert;
	import mx.events.CloseEvent;
	import mx.resources.IResourceManager;
	import mx.resources.ResourceManager;
	
	public class SetCategoriesAttributeCommand extends VidiunCommand {
		
		private var _type:String;	// event type
		
		private var _vCats:Array;	// categories ready for update
		
		private var _numOfGroups:int = 1;	// numbre of groups to process
		
		private var _callsCompleted:int = 0;	// number of calls (groups) already processed
		
		private var _callFailed:Boolean = false;	// if any call failed, set to true
		
		private var _nonUpdate:Boolean = false;	// if any of the categories will not be updated due to lack of entitlements
		
		override public function execute(event:CairngormEvent):void
		{
			_type = event.type;
			_vCats = [];
			var vCat:VidiunCategory;
			var cats:Array = _model.categoriesModel.selectedCategories;
			
			// process cats before update
			for each (vCat in cats) {
				if (!vCat.privacyContexts) {
					_nonUpdate = true;
					continue;
				}
				
				if (_type == CategoryEvent.SET_CATEGORIES_LISTING) {
					vCat.appearInList = event.data as int;
				}
				else if (_type == CategoryEvent.SET_CATEGORIES_CONTRIBUTION) {
					vCat.contributionPolicy = event.data as int;
				} 
				else if (_type == CategoryEvent.SET_CATEGORIES_ACCESS) {
					vCat.privacy = event.data as int;
				} 
				else if (_type == CategoryEvent.SET_CATEGORIES_OWNER) {
//					if (vCat.inheritanceType == VidiunInheritanceType.INHERIT) {
//						_nonUpdate = true;
//						continue;
//					}
					vCat.owner = event.data as String;
				}
				
				CategoryUtils.resetUnupdateableFields(vCat);
				vCat.setUpdatedFieldsOnly(true);
				_vCats.push(vCat);
			}
			
			// is large update?
			if (_vCats.length > 50) {
				Alert.show(ResourceManager.getInstance().getString('cms', 'updateLotsOfCategoriesMsg', [_vCats.length]),
					ResourceManager.getInstance().getString('cms', 'updateLotsOfEntriesTitle'),
					Alert.YES | Alert.NO, null, responesFnc);
				
			}
			else if (_vCats.length > 0) {
				var mr:MultiRequest = new MultiRequest();
				for each (vCat in _vCats) {
					var update:CategoryUpdate = new CategoryUpdate(vCat.id, vCat);
					mr.addAction(update);
				}
				
				_model.increaseLoadCounter();
				mr.addEventListener(VidiunEvent.COMPLETE, result);
				mr.addEventListener(VidiunEvent.FAILED, fault);
				_model.context.vc.post(mr);
			}
			
			if (_nonUpdate) {
				var rm:IResourceManager = ResourceManager.getInstance();
				Alert.show(rm.getString('cms', 'catNotUpdateEnt'), rm.getString('cms', 'attention'));
			}
			
		}
		
		/**
		 * handle large update
		 * */
		private function responesFnc(event:CloseEvent):void {
			if (event.detail == Alert.YES) {
				if (_nonUpdate) {
					var rm:IResourceManager = ResourceManager.getInstance();
					Alert.show(rm.getString('cms', 'catNotUpdateEnt'), rm.getString('cms', 'attention'));
				}
				
				// update:
				_numOfGroups = Math.floor(_vCats.length / 50);
				var lastGroupSize:int = _vCats.length % 50;
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
						var keepId:int = (_vCats[index] as VidiunCategory).id;
						var vCat:VidiunCategory = _vCats[index] as VidiunCategory;
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
					if (_type == CategoryEvent.SET_CATEGORIES_LISTING) {
						Alert.show(ResourceManager.getInstance().getString('cms', 'catListSuccess'));
					}
					else if (_type == CategoryEvent.SET_CATEGORIES_CONTRIBUTION) {
						Alert.show(ResourceManager.getInstance().getString('cms', 'catContPolSuccess'));
					}
					else if (_type == CategoryEvent.SET_CATEGORIES_ACCESS) {
						Alert.show(ResourceManager.getInstance().getString('cms', 'catAcSuccess'));
					}
					else if (_type == CategoryEvent.SET_CATEGORIES_OWNER) {
						Alert.show(ResourceManager.getInstance().getString('cms', 'catOwnSuccess'));
					}
				}
				
				// reload categories for table (also if no update, so values will be reset)
				var getCategoriesList:CategoryEvent = new CategoryEvent(CategoryEvent.LIST_CATEGORIES);
				getCategoriesList.dispatch();
			}
		}
	}
}