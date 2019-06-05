package com.vidiun.vmc.modules.content.commands.cat {
	import com.adobe.cairngorm.control.CairngormEvent;
	import com.vidiun.commands.MultiRequest;
	import com.vidiun.commands.baseEntry.BaseEntryCount;
	import com.vidiun.commands.category.CategoryList;
	import com.vidiun.dataStructures.HashMap;
	import com.vidiun.edw.business.VedJSGate;
	import com.vidiun.edw.model.FilterModel;
	import com.vidiun.edw.model.datapacks.EntryDataPack;
	import com.vidiun.edw.model.types.APIErrorCode;
	import com.vidiun.edw.vo.CategoryVO;
	import com.vidiun.errors.VidiunError;
	import com.vidiun.events.VidiunEvent;
	import com.vidiun.vmc.modules.content.commands.VidiunCommand;
	import com.vidiun.types.VidiunEntryStatus;
	import com.vidiun.types.VidiunMediaType;
	import com.vidiun.vo.VidiunCategory;
	import com.vidiun.vo.VidiunCategoryFilter;
	import com.vidiun.vo.VidiunCategoryListResponse;
	import com.vidiun.vo.VidiunFilterPager;
	import com.vidiun.vo.VidiunMediaEntryFilter;
	
	import mx.collections.ArrayCollection;
	import mx.collections.Sort;
	import mx.collections.SortField;
	import mx.controls.Alert;
	import mx.resources.ResourceManager;

	public class ListCategoriesCommand extends VidiunCommand {
		
		private var _filterModel:FilterModel;
		
		override public function execute(event:CairngormEvent):void {
			_model.increaseLoadCounter();
			// reset selected categories
			_model.categoriesModel.selectedCategories = [];
			
			if (event.data) {
				_model.categoriesModel.filter = event.data[0] as VidiunCategoryFilter;
				_model.categoriesModel.pager = event.data[1] as VidiunFilterPager;
				if (event.data.length > 2) {
					if (event.data[2]) {
						// reload categories for tree
						if (_model.filterModel.catTreeDataManager) {
							_model.filterModel.catTreeDataManager.resetData();
						}
					}
				}
			}
			
			var listCategories:CategoryList = new CategoryList(_model.categoriesModel.filter, _model.categoriesModel.pager);

			listCategories.addEventListener(VidiunEvent.COMPLETE, result);
			listCategories.addEventListener(VidiunEvent.FAILED, fault);
			_model.context.vc.post(listCategories);
		}


		override public function result(data:Object):void {
			_model.decreaseLoadCounter();
			super.result(data);
			if (!checkError(data)) {		
//			var er:VidiunError = (data as VidiunEvent).error;
//			if (er) { 
//				Alert.show(getErrorText(er), ResourceManager.getInstance().getString('cms', 'error'));
//				return;
//			}
				_model.categoriesModel.categoriesList = new ArrayCollection((data.data as VidiunCategoryListResponse).objects);
				_model.categoriesModel.totalCategories = (data.data as VidiunCategoryListResponse).totalCount;
			}
		}
		
		
		


	}
}