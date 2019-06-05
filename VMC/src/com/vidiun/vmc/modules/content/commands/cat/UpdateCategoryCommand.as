package com.vidiun.vmc.modules.content.commands.cat
{
	import com.adobe.cairngorm.control.CairngormEvent;
	import com.vidiun.commands.category.CategoryUpdate;
	import com.vidiun.edw.control.VedController;
	import com.vidiun.edw.control.events.SearchEvent;
	import com.vidiun.edw.vo.CategoryVO;
	import com.vidiun.events.VidiunEvent;
	import com.vidiun.vmc.modules.content.commands.VidiunCommand;
	import com.vidiun.vmc.modules.content.events.CategoryEvent;
	import com.vidiun.utils.ObjectUtil;
	import com.vidiun.vo.VidiunCategory;
	
	import mx.controls.Alert;
	import mx.events.PropertyChangeEvent;
	import mx.resources.ResourceManager;
	
	public class UpdateCategoryCommand extends VidiunCommand 
	{
		
		override public function execute(event:CairngormEvent):void
		{
			_model.increaseLoadCounter();
			var cat:CategoryVO = event.data[0] as CategoryVO;
			cat.category.setUpdatedFieldsOnly(true);
		 	var updateCategory:CategoryUpdate = new CategoryUpdate(cat.id, cat.category);
		 	updateCategory.addEventListener(VidiunEvent.COMPLETE, result);
			updateCategory.addEventListener(VidiunEvent.FAILED, fault);
			_model.context.vc.post(updateCategory);	   
		}
		
		override public function result(data:Object):void
		{
			super.result(data);
			_model.decreaseLoadCounter();
			if (!checkError(data)) {
				// copy any attributes from the server object to the client object 
				ObjectUtil.copyObject(data.data, _model.categoriesModel.selectedCategory);
				// retrigger binding
				_model.categoriesModel.dispatchEvent(PropertyChangeEvent.createUpdateEvent(_model.categoriesModel, "selectedCategory", _model.categoriesModel.selectedCategory, _model.categoriesModel.selectedCategory));
			}
		}
		
		
		/**
		 * reloads data 
		 */		
		private function refreshLists():void {
			var getCategoriesList:CategoryEvent = new CategoryEvent(CategoryEvent.LIST_CATEGORIES);
			getCategoriesList.dispatch();

			if (_model.listableVo) {
				var searchEvent:SearchEvent = new SearchEvent(SearchEvent.SEARCH_ENTRIES , _model.listableVo);
				VedController.getInstance().dispatch(searchEvent);
			}
			
			// reload categories for tree
			if (_model.filterModel.catTreeDataManager) {
				_model.filterModel.catTreeDataManager.resetData();
			}
		}
		
		override public function fault(info:Object):void
		{
			_model.decreaseLoadCounter();
			var alert : Alert = Alert.show(info.error.errorMsg, ResourceManager.getInstance().getString('cms', 'error'));
			refreshLists();
		}
	}
}