package com.vidiun.vmc.modules.analytics.commands {
	import com.adobe.cairngorm.commands.ICommand;
	import com.adobe.cairngorm.control.CairngormEvent;
	import com.vidiun.commands.category.CategoryList;
	import com.vidiun.dataStructures.HashMap;
	import com.vidiun.edw.vo.CategoryVO;
	import com.vidiun.errors.VidiunError;
	import com.vidiun.events.VidiunEvent;
	import com.vidiun.vmc.business.CategoryUtils;
	import com.vidiun.vmc.modules.analytics.model.AnalyticsModelLocator;
	import com.vidiun.types.VidiunCategoryOrderBy;
	import com.vidiun.vo.VidiunCategory;
	import com.vidiun.vo.VidiunCategoryFilter;
	import com.vidiun.vo.VidiunCategoryListResponse;
	
	import mx.collections.ArrayCollection;
	import mx.controls.Alert;
	import mx.resources.ResourceManager;
	import mx.rpc.IResponder;

	public class ListCategoriesCommand implements ICommand, IResponder {
		private var _model:AnalyticsModelLocator = AnalyticsModelLocator.getInstance();


		public function execute(event:CairngormEvent):void {
			_model.loadingFlag = true;
			_model.loadingCategories = true;

			var f:VidiunCategoryFilter = new VidiunCategoryFilter();
			f.orderBy = VidiunCategoryOrderBy.NAME_ASC;
			var listCategories:CategoryList = new CategoryList(f);

			listCategories.addEventListener(VidiunEvent.COMPLETE, result);
			listCategories.addEventListener(VidiunEvent.FAILED, fault);
			_model.vc.post(listCategories);
		}


		public function fault(info:Object):void {
			_model.loadingCategories = true;
			_model.checkLoading();
			Alert.show(info.error.errorMsg, ResourceManager.getInstance().getString('analytics', 'error'));
		}


		public function result(event:Object):void {
			_model.loadingCategories = true;
			_model.checkLoading();

			var vclr:VidiunCategoryListResponse;
			var vc:VidiunCategory;

			if (event.data[0] is VidiunError) {
				Alert.show((event.data[0] as VidiunError).errorMsg, ResourceManager.getInstance().getString('analytics', 'error'));
			}
			else {
				_model.categories = buildCategoriesHyrarchy((event.data as VidiunCategoryListResponse).objects, _model.categoriesMap);
			}

		}
		
		private function buildCategoriesHyrarchy(vCats:Array, catMap:HashMap):ArrayCollection {
			var allCategories:ArrayCollection = new ArrayCollection();	// all categories, so we can scan them easily
			var rootLevel:ArrayCollection = new ArrayCollection();	// categories in the root level
			var category:CategoryVO;
			// create category VOs and add to hashmap
			for each (var vCat:VidiunCategory in vCats) {
				category = new CategoryVO(vCat.id, vCat.name, vCat);
				catMap.put(vCat.id + '', category);
				allCategories.addItem(category)
			}
			
			// create tree: list children on parent categories
			for each (category in allCategories) {
				var parentCategory:CategoryVO = catMap.getValue(category.category.parentId + '') as CategoryVO;
				if (parentCategory != null) {
					if (!parentCategory.children) {
						parentCategory.children = new ArrayCollection();
					}
					parentCategory.children.addItem(category);
				}
				else {
					// parent is root
					rootLevel.addItem(category);
				}
			}
			
			var temp:Array;
			// sort on partnerSortValue
			for each (category in allCategories) {
				if (category.children) {
					temp = category.children.source;
					temp.sort(CategoryUtils.compareValues);
				}
			}
			
			return rootLevel;
		}
		

	}
}
