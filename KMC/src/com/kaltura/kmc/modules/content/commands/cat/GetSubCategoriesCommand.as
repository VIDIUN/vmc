package com.vidiun.vmc.modules.content.commands.cat
{
	import com.adobe.cairngorm.control.CairngormEvent;
	import com.vidiun.commands.category.CategoryList;
	import com.vidiun.errors.VidiunError;
	import com.vidiun.events.VidiunEvent;
	import com.vidiun.vmc.modules.content.commands.VidiunCommand;
	import com.vidiun.vmc.modules.content.events.CategoryEvent;
	import com.vidiun.vmc.modules.content.model.CategoriesModel;
	import com.vidiun.types.VidiunCategoryOrderBy;
	import com.vidiun.vo.VidiunCategory;
	import com.vidiun.vo.VidiunCategoryFilter;
	import com.vidiun.vo.VidiunCategoryListResponse;
	import com.vidiun.vo.VidiunFilterPager;
	
	import mx.collections.ArrayCollection;
	import mx.controls.Alert;
	import mx.resources.ResourceManager;

	public class GetSubCategoriesCommand extends VidiunCommand {
		
		override public function execute(event:CairngormEvent):void {
			switch (event.type) {
				case CategoryEvent.RESET_SUB_CATEGORIES:
					_model.categoriesModel.subCategories = null;
					break;
				
				case CategoryEvent.GET_SUB_CATEGORIES:
					_model.increaseLoadCounter();
					
					// filter
					var f:VidiunCategoryFilter = new VidiunCategoryFilter();
					f.parentIdEqual = _model.categoriesModel.selectedCategory.id;
					f.orderBy = VidiunCategoryOrderBy.NAME_DESC;
					// pager
					var p:VidiunFilterPager = new VidiunFilterPager();
					p.pageSize = CategoriesModel.SUB_CATEGORIES_LIMIT;
					p.pageIndex = 1;
					
					var listCategories:CategoryList = new CategoryList(f, p);
					listCategories.addEventListener(VidiunEvent.COMPLETE, result);
					listCategories.addEventListener(VidiunEvent.FAILED, fault);
					_model.context.vc.post(listCategories);
					break;
			}
		}
		
		
		override public function result(data:Object):void {
			_model.decreaseLoadCounter();
			super.result(data);
			
			var er:VidiunError = (data as VidiunEvent).error;
			if (er) { 
				Alert.show(getErrorText(er), ResourceManager.getInstance().getString('cms', 'error'));
				return;
			}
			if ((data.data as VidiunCategoryListResponse).totalCount <= CategoriesModel.SUB_CATEGORIES_LIMIT) {
				// only set to model if less than 50
				var ar:Array = (data.data as VidiunCategoryListResponse).objects;
				if (ar && ar.length > 1) {
					if (ar[0].partnerSortValue || ar[1].partnerSortValue) { 
						ar.sortOn("partnerSortValue", Array.NUMERIC);
					}
					else {
						ar.sortOn("name");
					}
				}
				_model.categoriesModel.subCategories = new ArrayCollection(ar);
			}
		}
		
	}
}