package com.vidiun.edw.control.commands.customData {
	import com.vidiun.commands.MultiRequest;
	import com.vidiun.commands.metadata.MetadataAdd;
	import com.vidiun.commands.metadata.MetadataUpdate;
	import com.vidiun.edw.business.MetadataDataParser;
	import com.vidiun.edw.control.commands.VedCommand;
	import com.vidiun.edw.control.events.VedEntryEvent;
	import com.vidiun.edw.control.events.MetadataDataEvent;
	import com.vidiun.edw.model.datapacks.CustomDataDataPack;
	import com.vidiun.edw.model.datapacks.FilterDataPack;
	import com.vidiun.edw.model.datapacks.PermissionsDataPack;
	import com.vidiun.edw.vo.CustomMetadataDataVO;
	import com.vidiun.events.VidiunEvent;
	import com.vidiun.vmvc.control.VMvCEvent;
	import com.vidiun.types.VidiunMetadataObjectType;
	import com.vidiun.vo.VMCMetadataProfileVO;
	import com.vidiun.vo.VidiunBaseEntry;
	
	import mx.collections.ArrayCollection;

	/**
	 * update current entry's custom data 
	 * @author atarsh
	 *
	 */
	public class UpdateMetadataDataCommand extends VedCommand {

		
		override public function execute(event:VMvCEvent):void {
			// custom data info
			var cddp:CustomDataDataPack = _model.getDataPack(CustomDataDataPack) as CustomDataDataPack;
			// use mr to update metadata for all profiles at once
			var mr:MultiRequest = new MultiRequest();
			var keepId:String = event.data;
			
			if ((_model.getDataPack(PermissionsDataPack) as PermissionsDataPack).enableUpdateMetadata && cddp.metadataInfoArray) {
				var metadataProfiles:ArrayCollection = (_model.getDataPack(FilterDataPack) as FilterDataPack).filterModel.metadataProfiles;
				for (var j:int = 0; j < cddp.metadataInfoArray.length; j++) {
					var metadataInfo:CustomMetadataDataVO = cddp.metadataInfoArray[j] as CustomMetadataDataVO;
					var profile:VMCMetadataProfileVO = metadataProfiles[j] as VMCMetadataProfileVO;
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
								VidiunMetadataObjectType.ENTRY,
								keepId,
								newMetadataXML.toXMLString());
							mr.addAction(metadataAdd);
						}
					}
				}
				
			}
			if (mr.actions.length > 0) {
				_model.increaseLoadCounter();
				// add listeners and post call
				mr.addEventListener(VidiunEvent.COMPLETE, result);
				mr.addEventListener(VidiunEvent.FAILED, fault);
				
				_client.post(mr);
			}
		}


		
		override public function result(data:Object):void {
			_model.decreaseLoadCounter();
			super.result(data);
			checkErrors(data);
		}

	}
}
