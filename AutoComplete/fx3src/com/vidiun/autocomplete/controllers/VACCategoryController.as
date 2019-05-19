package com.vidiun.autocomplete.controllers
{
	import com.hillelcoren.components.AutoComplete;
	import com.hillelcoren.utils.StringUtils;
	import com.vidiun.VidiunClient;
	import com.vidiun.autocomplete.controllers.base.VACControllerBase;
	import com.vidiun.autocomplete.itemRenderers.selection.CategorySelectedItem;
	import com.vidiun.commands.category.CategoryList;
	import com.vidiun.events.VidiunEvent;
	import com.vidiun.net.VidiunCall;
	import com.vidiun.vo.VidiunCategory;
	import com.vidiun.vo.VidiunCategoryFilter;
	import com.vidiun.vo.VidiunCategoryListResponse;
	
	import flash.events.Event;
	import flash.utils.setTimeout;
	
	import mx.collections.ArrayCollection;
	import mx.core.ClassFactory;
	import mx.utils.ArrayUtil;

	public class VACCategoryController extends VACControllerBase
	{
		public function VACCategoryController(autoComp:AutoComplete, client:VidiunClient)
		{
			super(autoComp, client);
			autoComp.dropDownLabelFunction = categoryLabelFunction;
			autoComp.selectionItemRendererClassFactory = new ClassFactory(CategorySelectedItem);
			autoComp.comparisonFunction = categoryComparison;
		}
		
		private function categoryComparison(itemA:Object, itemB:Object):Boolean{
			var categoryA:VidiunCategory = itemA as VidiunCategory;
			var categoryB:VidiunCategory = itemB as VidiunCategory;
			
			if (categoryA == null || categoryB == null){
				trace ("categoryComparison --> Trying to compare non-category object");
				return false;
			}
			
			return categoryA.id == categoryB.id;
		}
		
		override protected function createCallHook():VidiunCall{
			var filter:VidiunCategoryFilter = new VidiunCategoryFilter();
			filter.nameOrReferenceIdStartsWith = _autoComp.searchText;
			var listCategories:CategoryList = new CategoryList(filter);
			
			return listCategories;
		}
		
		override protected function fetchElements(data:Object):Array{
			var ret:Array = (data.data as VidiunCategoryListResponse).objects;
			if (ret != null){
				ret.sortOn("fullName", Array.CASEINSENSITIVE);
			}
			return ret;
		}
		
		private function categoryLabelFunction(item:Object):String{
			var category:VidiunCategory = item as VidiunCategory;
			
			var labelText:String = category.fullName;
			if (category.referenceId != null && category.referenceId != ""){
				labelText += " (" + category.referenceId + ")";
			}
			
			var searchStr:String = _autoComp.searchText;
			
			// there are problems using ">"s and "<"s in HTML
			labelText = labelText.replace( "<", "&lt;" ).replace( ">", "&gt;" );				
			
			var returnStr:String = StringUtils.highlightMatch( labelText, searchStr );
			
			var isDisabled:Boolean = false;
			var currCat:VidiunCategory = item as VidiunCategory;
			var vc:VidiunCategory;
			for each (vc in _autoComp.disabledItems.source){
				if (vc.id == currCat.id){
					isDisabled = true;
					break;
				}
			}
			
			var isSelected:Boolean = false;
			for each (vc in _autoComp.selectedItems.source){
				if (vc.id == currCat.id){
					isSelected = true;
					break;
				}
			}
			
			if (isSelected || isDisabled)
			{
				returnStr = "<font color='" + Consts.COLOR_TEXT_DISABLED + "'>" + returnStr + "</font>";
			}
			
			return returnStr;
		}
	}
}