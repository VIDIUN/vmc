package com.vidiun.edw.control.commands.customData {
	import com.vidiun.commands.metadataProfile.MetadataProfileList;
	import com.vidiun.edw.business.EntryFormBuilder;
	import com.vidiun.edw.control.commands.VedCommand;
	import com.vidiun.edw.model.FilterModel;
	import com.vidiun.edw.model.datapacks.CustomDataDataPack;
	import com.vidiun.edw.model.datapacks.FilterDataPack;
	import com.vidiun.edw.model.types.APIErrorCode;
	import com.vidiun.errors.VidiunError;
	import com.vidiun.events.VidiunEvent;
	import com.vidiun.vmvc.control.VMvCEvent;
	import com.vidiun.types.VidiunMetadataObjectType;
	import com.vidiun.types.VidiunMetadataOrderBy;
	import com.vidiun.types.VidiunMetadataProfileCreateMode;
	import com.vidiun.utils.parsers.MetadataProfileParser;
	import com.vidiun.vo.VMCMetadataProfileVO;
	import com.vidiun.vo.VidiunMetadataProfile;
	import com.vidiun.vo.VidiunMetadataProfileFilter;
	import com.vidiun.vo.VidiunMetadataProfileListResponse;
	import com.vidiun.vo.MetadataFieldVO;
	
	import mx.collections.ArrayCollection;
	import mx.controls.Alert;
	import mx.resources.ResourceManager;

	/**
	 * This command is being executed when the event MetadataProfileEvent.LIST is dispatched.
	 * @author Michal
	 *
	 */
	public class ListMetadataProfileCommand extends VedCommand {

		/**
		 * only if a metadata profile view contains layout with this name it will be used
		 */
		public static const VMC_LAYOUT_NAME:String = "VMC";


		/**
		 * This command requests the server for the last created metadata profile
		 * @param event the event that triggered this command
		 *
		 */
		override public function execute(event:VMvCEvent):void {
			_model.increaseLoadCounter();
			var filter:VidiunMetadataProfileFilter = new VidiunMetadataProfileFilter();
			filter.orderBy = VidiunMetadataOrderBy.CREATED_AT_DESC;
			filter.createModeNotEqual = VidiunMetadataProfileCreateMode.APP;
			filter.metadataObjectTypeEqual = VidiunMetadataObjectType.ENTRY;
			var listMetadataProfile:MetadataProfileList = new MetadataProfileList(filter);
			listMetadataProfile.addEventListener(VidiunEvent.COMPLETE, result);
			listMetadataProfile.addEventListener(VidiunEvent.FAILED, fault);

			_client.post(listMetadataProfile);
		}


		/**
		 * This function handles the response from the server. if a profile returned from the server then it will be
		 * saved into the model.
		 * @param data the data returned from the server
		 *
		 */
		override public function result(data:Object):void {
			_model.decreaseLoadCounter();

			if (data.error) {
				var er:VidiunError = data.error as VidiunError;
				if (er) {
					// ignore service forbidden
					if (er.errorCode != APIErrorCode.SERVICE_FORBIDDEN) {
						Alert.show(er.errorMsg, "Error");
					}
				}
			}
			else {
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
							var fb:EntryFormBuilder = new EntryFormBuilder(metadataProfile);
							formBuilders.push(fb);
							var isViewExist:Boolean = false;
	
							if (recievedProfile.views) {
								var recievedView:XML;
								try {
									recievedView = new XML(recievedProfile.views);
								}
								catch (e:Error) {
									//invalid view xmls
									continue;
								}
								for each (var layout:XML in recievedView.children()) {
									if (layout.@id == ListMetadataProfileCommand.VMC_LAYOUT_NAME) {
										metadataProfile.viewXML = layout;
										isViewExist = true;
										continue;
									}
								}
							}
							if (!isViewExist) {
								//if no view was retruned, or no view with "VMC" name, we will set the default metadata view uiconf XML
								if (CustomDataDataPack.metadataDefaultUiconfXML){
									metadataProfile.viewXML = CustomDataDataPack.metadataDefaultUiconfXML.copy();
								}
								// create the actual view:
								fb.buildInitialMxml();
							}
						}
					}
				}
				var filterModel:FilterModel = (_model.getDataPack(FilterDataPack) as FilterDataPack).filterModel;
				filterModel.metadataProfiles = new ArrayCollection(metadataProfiles);
				filterModel.formBuilders = new ArrayCollection(formBuilders);
			}

		}


		/**
		 * This function will be called if the request failed
		 * @param info the info returned from the server
		 *
		 */
		override public function fault(info:Object):void {
			if (info && info.error && info.error.errorMsg && info.error.errorCode != APIErrorCode.SERVICE_FORBIDDEN) {
				Alert.show(info.error.errorMsg, ResourceManager.getInstance().getString('cms', 'error'));
			}
			_model.decreaseLoadCounter();
		}
	}
}
