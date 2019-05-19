package com.vidiun.vmc.modules.content.commands
{
	import com.adobe.cairngorm.control.CairngormEvent;
	import com.vidiun.commands.metadataProfile.MetadataProfileList;
	import com.vidiun.edw.model.FilterModel;
	import com.vidiun.edw.model.datapacks.CustomDataDataPack;
	import com.vidiun.events.VidiunEvent;
	import com.vidiun.vmc.modules.content.business.CategoryFormBuilder;
	import com.vidiun.types.VidiunMetadataObjectType;
	import com.vidiun.types.VidiunMetadataOrderBy;
	import com.vidiun.types.VidiunMetadataProfileCreateMode;
	import com.vidiun.utils.parsers.MetadataProfileParser;
	import com.vidiun.vo.VMCMetadataProfileVO;
	import com.vidiun.vo.VidiunFilterPager;
	import com.vidiun.vo.VidiunMetadataProfile;
	import com.vidiun.vo.VidiunMetadataProfileFilter;
	import com.vidiun.vo.VidiunMetadataProfileListResponse;
	import com.vidiun.vo.MetadataFieldVO;
	
	import mx.collections.ArrayCollection;
	import mx.resources.ResourceManager;

	public class ListCategoryMetadataProfileCommand extends VidiunCommand
	{
		
		/**
		 * only if a metadata profile view contains layout with this name it will be used
		 */
		private static const VMC_LAYOUT_NAME:String = "VMC";

		
		override public function execute(event:CairngormEvent):void{
			_model.increaseLoadCounter();
			
			var filter:VidiunMetadataProfileFilter = new VidiunMetadataProfileFilter();
			filter.orderBy = VidiunMetadataOrderBy.CREATED_AT_DESC;
			filter.createModeNotEqual = VidiunMetadataProfileCreateMode.APP;
			filter.metadataObjectTypeEqual = VidiunMetadataObjectType.CATEGORY;
			var listMetadataProfile:MetadataProfileList = new MetadataProfileList(filter);
			listMetadataProfile.addEventListener(VidiunEvent.COMPLETE, result);
			listMetadataProfile.addEventListener(VidiunEvent.FAILED, fault);
			
			_model.context.vc.post(listMetadataProfile);
		}
		
		override public function result(data:Object):void{
			super.result(data);
			_model.decreaseLoadCounter();
			
			if (! checkError(data)){
				var response:VidiunMetadataProfileListResponse = data.data as VidiunMetadataProfileListResponse;
				var metadataProfiles:Array = new Array();
				var formBuilders:Array = new Array();
				if (response.objects) {
					for (var i:int = 0; i < response.objects.length; i++) {
						var recievedProfile:VidiunMetadataProfile = response.objects[i];
						if (recievedProfile) {
							var metadataProfile:VMCMetadataProfileVO = new VMCMetadataProfileVO();
							metadataProfile.profile = recievedProfile;
							metadataProfile.xsd = new XML(recievedProfile.xsd);
							metadataProfile.metadataFieldVOArray = MetadataProfileParser.fromXSDtoArray(metadataProfile.xsd);
							
							//set the displayed label of each label
							for each (var field:MetadataFieldVO in metadataProfile.metadataFieldVOArray) {
								var label:String = ResourceManager.getInstance().getString('customFields', field.defaultLabel);
								if (label) {
									field.displayedLabel = label;
								}
								else {
									field.displayedLabel = field.defaultLabel;
								}
							}
							
							//adds the profile to metadataProfiles, and its matching formBuilder to formBuilders
							metadataProfiles.push(metadataProfile);
							var fb:CategoryFormBuilder = new CategoryFormBuilder(metadataProfile);
							formBuilders.push(fb);
							var isViewExist:Boolean = false;
							
							if (recievedProfile.views) {
								try {
									var recievedView:XML = new XML(recievedProfile.views);
								}
								catch (e:Error) {
									//invalid view xmls
									continue;
								}
								for each (var layout:XML in recievedView.children()) {
									if (layout.@id == VMC_LAYOUT_NAME) {
										metadataProfile.viewXML = layout;
										isViewExist = true;
										continue;
									}
								}
							}
							if (!isViewExist) {
								//if no view was retruned, or no view with "VMC" name, we will set the default uiconf XML
								if (CustomDataDataPack.metadataDefaultUiconfXML){
									metadataProfile.viewXML = CustomDataDataPack.metadataDefaultUiconfXML.copy();
								}
								fb.buildInitialMxml();
							}
						}
					}
				}
				var filterModel:FilterModel = _model.filterModel;
				filterModel.categoryMetadataProfiles = new ArrayCollection(metadataProfiles);
				filterModel.categoryFormBuilders = new ArrayCollection(formBuilders);
			}
		}
	}
}