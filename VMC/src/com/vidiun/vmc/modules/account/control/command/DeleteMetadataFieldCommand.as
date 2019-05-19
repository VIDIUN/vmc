package com.vidiun.vmc.modules.account.control.command
{
	import com.adobe.cairngorm.commands.ICommand;
	import com.adobe.cairngorm.control.CairngormEvent;
	import com.vidiun.vmc.modules.account.control.events.MetadataFieldEvent;
	import com.vidiun.vmc.modules.account.control.events.MetadataProfileEvent;
	import com.vidiun.vmc.modules.account.model.AccountModelLocator;
	import com.vidiun.utils.parsers.MetadataProfileParser;
	import com.vidiun.vo.MetadataFieldVO;
	
	import mx.controls.Alert;
	import mx.resources.ResourceManager;
	
	public class DeleteMetadataFieldCommand implements ICommand
	{
		private var _model : AccountModelLocator = AccountModelLocator.getInstance();

		public function execute(event:CairngormEvent):void
		{
			var deleteField:MetadataFieldVO = (event as MetadataFieldEvent).metadataField;
			if (!_model.selectedMetadataProfile || !deleteField)
				return;
			if (!_model.selectedMetadataProfile.xsd) {
				_model.selectedMetadataProfile.xsd = MetadataProfileParser.createNewXSD();
			}
			try {

				MetadataProfileParser.deleteFieldFromXSD(deleteField, _model.selectedMetadataProfile.xsd);			

			}
			catch (e:Error){
				Alert.show(ResourceManager.getInstance().getString('account','metadataMalformedXSDError'), ResourceManager.getInstance().getString('account','error'));
				return;
			}
			_model.selectedMetadataProfile.metadataProfileChanged = true;
		}

	}
}