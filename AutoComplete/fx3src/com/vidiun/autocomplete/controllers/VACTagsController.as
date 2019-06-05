package com.vidiun.autocomplete.controllers
{
	import com.hillelcoren.components.AutoComplete;
	import com.vidiun.VidiunClient;
	import com.vidiun.autocomplete.controllers.base.VACControllerBase;
	import com.vidiun.autocomplete.itemRenderers.selection.TagsSelectedItem;
	import com.vidiun.commands.tag.TagSearch;
	import com.vidiun.net.VidiunCall;
	import com.vidiun.types.VidiunTaggedObjectType;
	import com.vidiun.vo.VidiunFilterPager;
	import com.vidiun.vo.VidiunTag;
	import com.vidiun.vo.VidiunTagFilter;
	import com.vidiun.vo.VidiunTagListResponse;
	
	import mx.core.ClassFactory;
	
	public class VACTagsController extends VACControllerBase
	{
		private var _objType:String;
		
		public function VACTagsController(autoComp:AutoComplete, client:VidiunClient, objType:String)
		{
			super(autoComp, client);
//			autoComp.allowEditingSelectedValues = true;
			autoComp.selectionItemRendererClassFactory = new ClassFactory(TagsSelectedItem);
//			autoComp.allowEditingNewValues = true;
			_objType = objType;
		}
		
		override protected function createCallHook():VidiunCall{
			var filter:VidiunTagFilter = new VidiunTagFilter();
			filter.tagStartsWith = _autoComp.searchText;
			filter.objectTypeEqual = _objType;
			var pager:VidiunFilterPager = new VidiunFilterPager();
			
			// TODO: Check size limit?
			pager.pageSize = 30;
			pager.pageIndex = 0;
			
			var listTags:TagSearch = new TagSearch(filter, pager);
			return listTags;
		}
		
		override protected function fetchElements(data:Object):Array{
			if ((data.data as VidiunTagListResponse).objects != null) {
			var tags:Vector.<VidiunTag> = Vector.<VidiunTag>((data.data as VidiunTagListResponse).objects);
			var tagNames:Array = new Array();
			
			for each (var tag:VidiunTag in tags){
				tagNames.push(tag.tag);
			}
				
			return tagNames;
			
			} else {
				return new Array();
			}
		}
	}
}