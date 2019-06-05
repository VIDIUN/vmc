package com.vidiun.edw.control.commands.customData {
	import com.vidiun.commands.metadata.MetadataList;
	import com.vidiun.edw.business.EntryFormBuilder;
	import com.vidiun.edw.control.commands.VedCommand;
	import com.vidiun.edw.control.events.MetadataDataEvent;
	import com.vidiun.edw.model.FilterModel;
	import com.vidiun.edw.model.datapacks.CustomDataDataPack;
	import com.vidiun.edw.model.datapacks.EntryDataPack;
	import com.vidiun.edw.model.datapacks.FilterDataPack;
	import com.vidiun.edw.vo.CustomMetadataDataVO;
	import com.vidiun.events.VidiunEvent;
	import com.vidiun.vmvc.control.VMvCEvent;
	import com.vidiun.vo.VMCMetadataProfileVO;
	import com.vidiun.vo.VidiunFilterPager;
	import com.vidiun.vo.VidiunMetadata;
	import com.vidiun.vo.VidiunMetadataFilter;
	import com.vidiun.vo.VidiunMetadataListResponse;
	
	import mx.collections.ArrayCollection;

	/**
	 * This class sends a metadata data list request to the server and handles the response
	 * @author Michal
	 *
	 */
	public class ListMetadataDataCommand extends VedCommand {

		private var _filterModel:FilterModel;


		/**
		 * This command requests the server for the latest valid metadata data, that suits
		 * the current profile id and current profile version
		 * @param event the event that triggered this command
		 *
		 */
		override public function execute(event:VMvCEvent):void {
			_filterModel = (_model.getDataPack(FilterDataPack) as FilterDataPack).filterModel;
			
			if (event.type == MetadataDataEvent.RESET) {
				var metadataEmptyData:Array = new Array;
				var vMetadata:VidiunMetadata;
				var prof:VMCMetadataProfileVO;
				for (var i:int = 0; i < _filterModel.metadataProfiles.length; i++) {
					prof = _filterModel.metadataProfiles[i] as VMCMetadataProfileVO;
					vMetadata = new VidiunMetadata();
					vMetadata.metadataProfileId = prof.profile.id;
					metadataEmptyData.push(vMetadata);
				}
				setDataToModel(metadataEmptyData);
			}
			else { // list
				
				var edp:EntryDataPack = _model.getDataPack(EntryDataPack) as EntryDataPack;
				if (!_filterModel.metadataProfiles || !edp.selectedEntry.id)
					return;

				var filter:VidiunMetadataFilter = new VidiunMetadataFilter();
				filter.objectIdEqual = edp.selectedEntry.id;

				var listMetadataData:MetadataList = new MetadataList(filter);
				listMetadataData.addEventListener(VidiunEvent.COMPLETE, result);
				listMetadataData.addEventListener(VidiunEvent.FAILED, fault);

				_client.post(listMetadataData);
			}
		}


		/**
		 * This function handles the response returned from the server
		 * @param data the data returned from the server
		 *
		 */
		override public function result(data:Object):void {
			super.result(data);
			var metadataResponse:VidiunMetadataListResponse = data.data as VidiunMetadataListResponse;
			setDataToModel(metadataResponse.objects);
		}


		/**
		 * match given data to profiles and form builders
		 * @param metadataArray entry metadata data
		 */
		private function setDataToModel(metadataArray:Array):void {
			var cddp:CustomDataDataPack = _model.getDataPack(CustomDataDataPack) as CustomDataDataPack;
			cddp.metadataInfoArray = new ArrayCollection();

			//go over all profiles and match to the metadata data
			for (var i:int = 0; i < _filterModel.metadataProfiles.length; i++) {
				var entryMetadata:CustomMetadataDataVO = new CustomMetadataDataVO();
				cddp.metadataInfoArray.addItem(entryMetadata);

				// get the form builder that matches this profile:
				var formBuilder:EntryFormBuilder = _filterModel.formBuilders[i] as EntryFormBuilder;
				formBuilder.metadataInfo = entryMetadata;

				// add the VidiunMetadata of this profile to the EntryMetadataDataVO
				var profileId:int = (_filterModel.metadataProfiles[i] as VMCMetadataProfileVO).profile.id;
				for each (var metadata:VidiunMetadata in metadataArray) {
					if (metadata.metadataProfileId == profileId) {
						entryMetadata.metadata = metadata;
						break;
					}
				}
				formBuilder.updateMultiTags();
			}
		}

	}
}
