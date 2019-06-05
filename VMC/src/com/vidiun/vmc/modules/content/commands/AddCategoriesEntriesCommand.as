package com.vidiun.vmc.modules.content.commands
{
	import com.adobe.cairngorm.control.CairngormEvent;
	import com.vidiun.commands.MultiRequest;
	import com.vidiun.commands.categoryEntry.CategoryEntryAdd;
	import com.vidiun.errors.VidiunError;
	import com.vidiun.events.VidiunEvent;
	import com.vidiun.vmc.modules.content.events.EntriesEvent;
	import com.vidiun.vo.VidiunBaseEntry;
	import com.vidiun.vo.VidiunCategory;
	import com.vidiun.vo.VidiunCategoryEntry;
	
	import mx.controls.Alert;
	import mx.resources.IResourceManager;
	import mx.resources.ResourceManager;

	public class AddCategoriesEntriesCommand extends VidiunCommand {
		
		
		private var _eventType:String;
		private var _entries:Array;
		private var _categories:Array;
		
		/**
		 * objects like {entry, category} for each request
		 */
		private var _catents:Array;
		
		override public function execute(event:CairngormEvent):void {
			_model.increaseLoadCounter();
			_eventType = event.type;
			
			var e:EntriesEvent = event as EntriesEvent;
			_categories = e.data as Array; // elements are VidiunCategories
			// for each entry, add the category.
			if (event.type == EntriesEvent.ADD_ON_THE_FLY_CATEGORY) {
				_entries = _model.categoriesModel.onTheFlyCategoryEntries;
			}
			else if (event.type == EntriesEvent.ADD_CATEGORIES_ENTRIES) {
				_entries = _model.selectedEntries;
			}
			
			var cea:CategoryEntryAdd;
			var vce:VidiunCategoryEntry;
			var mr:MultiRequest = new MultiRequest();
			_catents = new Array();
			for each (var vbe:VidiunBaseEntry in _entries) {
				for each (var vc:VidiunCategory in _categories) {
					vce = new VidiunCategoryEntry();
					vce.entryId = vbe.id;
					vce.categoryId = vc.id;
					cea = new CategoryEntryAdd(vce);
					mr.addAction(cea);
					_catents.push({entry:vbe, category:vc});
				}
			}
			
			
			mr.addEventListener(VidiunEvent.COMPLETE, result);
			mr.addEventListener(VidiunEvent.FAILED, fault);
			_model.context.vc.post(mr);
			
		}
		
		
		override public function result(data:Object):void {
			super.result(data);
			if (!checkError(data)) {
				if (_eventType == EntriesEvent.ADD_ON_THE_FLY_CATEGORY) {
					// re-load cat.tree
					if (_model.filterModel.catTreeDataManager) {
						_model.filterModel.catTreeDataManager.resetData();
					}
					// "forget" the list on the model
					_model.categoriesModel.onTheFlyCategoryEntries = null;
				}
			}
			_model.decreaseLoadCounter();
		}
		
		
		override protected function checkError(resultData:Object, header:String = ''):Boolean {
			if (!header) {
				header = ResourceManager.getInstance().getString('cms', 'error');
			}
			// look for error
			var str:String = '';
			var o:Object;
			var er:VidiunError = (resultData as VidiunEvent).error;
			if (er) {
				str = getMessageFromError(er.errorCode, er.errorMsg);
				Alert.show(str, header);
				return true;
			} 
			else {
				if (resultData.data is Array && resultData.data.length) {
					// this was a multirequest, we need to check its contents.
					str = '';
					for (var i:int = 0; i<resultData.data.length; i++) {
						o = resultData.data[i];
						if (o.error) {
							// in MR errors aren't created
							if (o.error.code == 'CATEGORY_ENTRY_ALREADY_EXISTS') {
								str += ResourceManager.getInstance().getString('cms', 'entry_already_assigned', [_catents[i]['entry'].name, _catents[i]['category'].name]);
							}
							else {
								str += getMessageFromError(o.error.code, o.error.message); 
							}
							str += '\n';
						}
					}
					if (str.length > 0) {
						Alert.show(str, header);
						return true;
					}
				}
			}
			return false;
		}
	}
}