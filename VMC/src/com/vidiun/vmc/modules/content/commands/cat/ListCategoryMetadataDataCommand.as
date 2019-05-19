package com.vidiun.vmc.modules.content.commands.cat
{
	import com.adobe.cairngorm.control.CairngormEvent;
	import com.vidiun.commands.metadata.MetadataList;
	import com.vidiun.edw.model.FilterModel;
	import com.vidiun.edw.vo.CustomMetadataDataVO;
	import com.vidiun.events.VidiunEvent;
	import com.vidiun.vmc.modules.content.business.CategoryFormBuilder;
	import com.vidiun.vmc.modules.content.commands.VidiunCommand;
	import com.vidiun.vmc.modules.content.model.CategoriesModel;
	import com.vidiun.types.VidiunMetadataObjectType;
	import com.vidiun.vo.VMCMetadataProfileVO;
	import com.vidiun.vo.VidiunCategory;
	import com.vidiun.vo.VidiunFilterPager;
	import com.vidiun.vo.VidiunMetadata;
	import com.vidiun.vo.VidiunMetadataFilter;
	import com.vidiun.vo.VidiunMetadataListResponse;
	
	import mx.collections.ArrayCollection;
	
	public class ListCategoryMetadataDataCommand extends VidiunCommand
	{
		
		/**
		 * This command requests the server for the latest valid metadata data, that suits
		 * the current profile id and current profile version
		 * @param event the event that triggered this command
		 * 
		 */		
		override public function execute(event:CairngormEvent):void
		{
			var filterModel:FilterModel = _model.filterModel;
			var catModel:CategoriesModel = _model.categoriesModel;
			if (!filterModel.categoryMetadataProfiles || !catModel.selectedCategory)
				return;
			
			var filter:VidiunMetadataFilter = new VidiunMetadataFilter();
			filter.objectIdEqual = String(catModel.selectedCategory.id);	
			filter.metadataObjectTypeEqual = VidiunMetadataObjectType.CATEGORY;
			var pager:VidiunFilterPager = new VidiunFilterPager();
			
			var listMetadataData:MetadataList = new MetadataList(filter, pager);
			listMetadataData.addEventListener(VidiunEvent.COMPLETE, result);
			listMetadataData.addEventListener(VidiunEvent.FAILED, fault);
			
			_model.context.vc.post(listMetadataData);
		}
		 
		/**
		 * This function handles the response returned from the server 
		 * @param data the data returned from the server
		 * 
		 */		
		override public function result(data:Object):void
		{
			super.result(data);
			
			var metadataResponse:VidiunMetadataListResponse = data.data as VidiunMetadataListResponse;
			
			var filterModel:FilterModel = _model.filterModel;
			var catModel:CategoriesModel = _model.categoriesModel;
			catModel.metadataInfo = new ArrayCollection;
			
			//go over all profiles and match to the metadata data
			for (var i:int = 0; i<filterModel.categoryMetadataProfiles.length; i++) {
				var categoryMetadata:CustomMetadataDataVO = new CustomMetadataDataVO(); 
				catModel.metadataInfo.addItem(categoryMetadata);
				
				// get the form builder that matches this profile:
				var formBuilder:CategoryFormBuilder = filterModel.categoryFormBuilders[i] as CategoryFormBuilder;
				formBuilder.metadataInfo = categoryMetadata;
				
				// add the VidiunMetadata of this profile to the EntryMetadataDataVO
				var profileId:int = (filterModel.categoryMetadataProfiles[i] as VMCMetadataProfileVO).profile.id;
				for each (var metadata:VidiunMetadata in metadataResponse.objects) {
					if (metadata.metadataProfileId == profileId) {
						categoryMetadata.metadata = metadata;
						break;
					}
				}
				formBuilder.updateMultiTags();
			}
		}
	}
}