package com.vidiun.edw.control.commands
{
	import com.vidiun.commands.category.CategoryList;
	import com.vidiun.commands.categoryEntry.CategoryEntryList;
	import com.vidiun.edw.control.events.VedEntryEvent;
	import com.vidiun.edw.model.datapacks.EntryDataPack;
	import com.vidiun.events.VidiunEvent;
	import com.vidiun.vmvc.control.VMvCEvent;
	import com.vidiun.vo.VidiunCategoryEntry;
	import com.vidiun.vo.VidiunCategoryEntryFilter;
	import com.vidiun.vo.VidiunCategoryEntryListResponse;
	import com.vidiun.vo.VidiunCategoryFilter;
	import com.vidiun.vo.VidiunCategoryListResponse;
	import com.vidiun.vo.VidiunFilterPager;
	
	import mx.collections.ArrayCollection;

	public class GetEntryCategoriesCommand extends VedCommand {
		
		override public function execute(event:VMvCEvent):void {
			var edp:EntryDataPack = _model.getDataPack(EntryDataPack) as EntryDataPack;
			switch (event.type) {
				case VedEntryEvent.RESET_ENTRY_CATEGORIES:
					edp.entryCategories = new ArrayCollection();
					break;
				case VedEntryEvent.GET_ENTRY_CATEGORIES:
					_model.increaseLoadCounter();
					
					// get a list of VidiunCategoryEntries
					var e:VedEntryEvent = event as VedEntryEvent;
					
					var f:VidiunCategoryEntryFilter = new VidiunCategoryEntryFilter();
					f.entryIdEqual = e.entryVo.id;
					var p:VidiunFilterPager = new VidiunFilterPager();
					p.pageSize = edp.maxNumCategories;
					var getcats:CategoryEntryList = new CategoryEntryList(f, p);
					
					getcats.addEventListener(VidiunEvent.COMPLETE, result);
					getcats.addEventListener(VidiunEvent.FAILED, fault);
					
					_client.post(getcats);
					break;
			}
		}
		
		
		override public function result(data:Object):void {
			super.result(data);
			var edp:EntryDataPack = _model.getDataPack(EntryDataPack) as EntryDataPack;
			if (data.data is VidiunCategoryEntryListResponse) {
				// get a list of VidiunCategories
				var vce:VidiunCategoryEntry;
				var str:String = '';
				var vces:Array = data.data.objects;
				if (!vces || !vces.length) {
					_model.decreaseLoadCounter();
					return;
				}
				
				for each (vce in vces) {
					str += vce.categoryId + ",";
				}
				var f:VidiunCategoryFilter = new VidiunCategoryFilter();
				f.idIn = str;
				var p:VidiunFilterPager = new VidiunFilterPager();
				p.pageSize = edp.maxNumCategories;
				var getcats:CategoryList = new CategoryList(f, p);
				
				getcats.addEventListener(VidiunEvent.COMPLETE, result);
				getcats.addEventListener(VidiunEvent.FAILED, fault);
				
				_client.post(getcats);
			}
			else if (data.data is VidiunCategoryListResponse) {
				// put the VidiunCategories on the model
				edp.entryCategories = new ArrayCollection((data.data as VidiunCategoryListResponse).objects);
				_model.decreaseLoadCounter();
			}
		}
	}
}