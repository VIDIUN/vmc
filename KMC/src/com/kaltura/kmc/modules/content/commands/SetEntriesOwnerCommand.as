package com.vidiun.vmc.modules.content.commands
{
	import com.adobe.cairngorm.control.CairngormEvent;
	import com.vidiun.commands.MultiRequest;
	import com.vidiun.commands.baseEntry.BaseEntryUpdate;
	import com.vidiun.errors.VidiunError;
	import com.vidiun.events.VidiunEvent;
	import com.vidiun.vmc.modules.content.events.EntriesEvent;
	import com.vidiun.vo.VidiunBaseEntry;
	
	import mx.controls.Alert;
	import mx.resources.IResourceManager;
	import mx.resources.ResourceManager;

	public class SetEntriesOwnerCommand extends VidiunCommand {
		
		override public function execute(event:CairngormEvent):void {
			_model.increaseLoadCounter();
			
			var e:EntriesEvent = event as EntriesEvent;
			var userid:String = e.data;
			var entry:VidiunBaseEntry;
			var updateEntry:BaseEntryUpdate
			var mr:MultiRequest = new MultiRequest();
			
			for (var i:uint = 0; i < e.entries.length; i++) {
				entry = e.entries[i] as VidiunBaseEntry;
				entry.userId = userid;
				entry.setUpdatedFieldsOnly(true);
				if (entry.conversionProfileId) {
					entry.conversionProfileId = int.MIN_VALUE;
				}
				// don't send categories - we use categoryEntry service to update them in EntryData panel
				entry.categories = null;
				entry.categoriesIds = null;
				
				updateEntry = new BaseEntryUpdate(entry.id, entry);
				mr.addAction(updateEntry);
			}
			mr.addEventListener(VidiunEvent.COMPLETE, result);
			mr.addEventListener(VidiunEvent.FAILED, fault);
			_model.context.vc.post(mr);
			
		}
		override public function result(data:Object):void {
			super.result(data);
			_model.decreaseLoadCounter();
			if (!checkError(data)) {
				Alert.show(ResourceManager.getInstance().getString('cms', 'updateCompleteOwner'));
			}
		}
	}
}