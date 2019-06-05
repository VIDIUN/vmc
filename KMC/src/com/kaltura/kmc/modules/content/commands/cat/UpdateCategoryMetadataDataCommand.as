package com.vidiun.vmc.modules.content.commands.cat
{
	import com.adobe.cairngorm.control.CairngormEvent;
	import com.vidiun.commands.MultiRequest;
	import com.vidiun.commands.metadata.MetadataAdd;
	import com.vidiun.commands.metadata.MetadataUpdate;
	import com.vidiun.edw.business.MetadataDataParser;
	import com.vidiun.edw.vo.CustomMetadataDataVO;
	import com.vidiun.errors.VidiunError;
	import com.vidiun.events.VidiunEvent;
	import com.vidiun.vmc.modules.content.commands.VidiunCommand;
	import com.vidiun.types.VidiunMetadataObjectType;
	import com.vidiun.vo.VMCMetadataProfileVO;
	import com.vidiun.vo.VidiunCategory;
	
	import mx.collections.ArrayCollection;
	import mx.controls.Alert;
	import mx.resources.ResourceManager;
	
	public class UpdateCategoryMetadataDataCommand extends VidiunCommand
	{
		override public function execute(event:CairngormEvent):void{
			_model.increaseLoadCounter();
			
			var catid:String = event.data;
			
			var mr:MultiRequest = new MultiRequest();
			
			
			var infoArray:ArrayCollection = _model.categoriesModel.metadataInfo;
			var profileArray:ArrayCollection = _model.filterModel.categoryMetadataProfiles;
			for (var j:int = 0; j < infoArray.length; j++) {
				var metadataInfo:CustomMetadataDataVO = infoArray[j] as CustomMetadataDataVO;
				var profile:VMCMetadataProfileVO = profileArray[j] as VMCMetadataProfileVO;
				if (metadataInfo && profile && profile.profile) {
					var newMetadataXML:XML = MetadataDataParser.toMetadataXML(metadataInfo, profile);
					//metadata exists--> update request
					if (metadataInfo.metadata) {
						var originalMetadataXML:XML = new XML(metadataInfo.metadata.xml);
						if (!(MetadataDataParser.compareMetadata(newMetadataXML, originalMetadataXML))) {
							var metadataUpdate:MetadataUpdate = new MetadataUpdate(metadataInfo.metadata.id,
								newMetadataXML.toXMLString());
							mr.addAction(metadataUpdate);
						}
					}
					else if (newMetadataXML.children().length() > 0) {
						var metadataAdd:MetadataAdd = new MetadataAdd(profile.profile.id,
							VidiunMetadataObjectType.CATEGORY,
							catid,
							newMetadataXML.toXMLString());
						mr.addAction(metadataAdd);
					}
				}
			}
			
			// add listeners and post call
			mr.addEventListener(VidiunEvent.COMPLETE, result);
			mr.addEventListener(VidiunEvent.FAILED, fault);
			
			_model.context.vc.post(mr);
		}
		
		override public function result(data:Object):void {
			super.result(data);
			_model.decreaseLoadCounter();
			
			var isErr:Boolean;
			if (data.data && data.data is Array) {
				for (var i:uint = 0; i < (data.data as Array).length; i++) {
					if ((data.data as Array)[i] is VidiunError) {
						isErr = true;
						Alert.show(ResourceManager.getInstance().getString('drilldown', 'error') + ": " +
							((data.data as Array)[i] as VidiunError).errorMsg);
					}
					else if ((data.data as Array)[i].hasOwnProperty("error")) {
						isErr = true;
						Alert.show((data.data as Array)[i].error.message, ResourceManager.getInstance().getString('drilldown', 'error'));
					}
				}
			}
		}
	}
}