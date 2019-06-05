package com.vidiun.vmc.modules.content.commands.cat {
	import com.adobe.cairngorm.control.CairngormEvent;
	import com.vidiun.commands.category.CategoryAdd;
	import com.vidiun.events.VidiunEvent;
	import com.vidiun.vmc.modules.content.commands.VidiunCommand;
	import com.vidiun.vmc.modules.content.events.CategoryEvent;
	import com.vidiun.vmc.modules.content.events.EntriesEvent;
	import com.vidiun.utils.ObjectUtil;
	import com.vidiun.vo.VidiunCategory;
	
	import mx.events.PropertyChangeEvent;

	public class AddCategoryCommand extends VidiunCommand {
		
		/**
		 * should (custom) metadata be saved after category creation
		 * (only saved if values are set) 
		 */		
		private var _saveMetadata:Boolean;
		
		override public function execute(event:CairngormEvent):void {
			_model.increaseLoadCounter();
			_saveMetadata = event.data[1];
			var newCategory:VidiunCategory = event.data[0] as VidiunCategory;
			var addCategory:CategoryAdd = new CategoryAdd(newCategory);
			addCategory.addEventListener(VidiunEvent.COMPLETE, result);
			addCategory.addEventListener(VidiunEvent.FAILED, fault);
			_model.context.vc.post(addCategory);
		}


		override public function result(data:Object):void {
			super.result(data);
			if (!checkError(data) && data.data is VidiunCategory) {
				// addition worked out fine
				_model.categoriesModel.processingNewCategory = false;

				var cgEvent:CairngormEvent;
				// if need to add entries to the created category
				if (_model.categoriesModel.onTheFlyCategoryEntries) {
					cgEvent = new EntriesEvent(EntriesEvent.ADD_ON_THE_FLY_CATEGORY);
					cgEvent.data = [data.data];
					cgEvent.dispatch();
				}
				if (_saveMetadata) {
					cgEvent = new CategoryEvent(CategoryEvent.UPDATE_CATEGORY_METADATA_DATA);
					cgEvent.data = (data.data as VidiunCategory).id;
					cgEvent.dispatch();
				}
				
				// copy any attributes from the server object to the client object 
				ObjectUtil.copyObject(data.data, _model.categoriesModel.selectedCategory);
				// retrigger binding
				_model.categoriesModel.dispatchEvent(PropertyChangeEvent.createUpdateEvent(_model.categoriesModel, "selectedCategory", _model.categoriesModel.selectedCategory, _model.categoriesModel.selectedCategory));
			}
			_model.decreaseLoadCounter();
		}
		

	}
}
