package com.vidiun.edw.control.commands
{
	import com.vidiun.commands.MultiRequest;
	import com.vidiun.commands.categoryEntry.CategoryEntryAdd;
	import com.vidiun.commands.categoryEntry.CategoryEntryDelete;
	import com.vidiun.edw.control.events.VedEntryEvent;
	import com.vidiun.errors.VidiunError;
	import com.vidiun.events.VidiunEvent;
	import com.vidiun.vmvc.control.VMvCEvent;
	import com.vidiun.vo.VidiunCategory;
	import com.vidiun.vo.VidiunCategoryEntry;
	
	import mx.controls.Alert;
	import mx.resources.ResourceManager;

	public class UpdateEntryCategoriesCommand extends VedCommand {
		
		override public function execute(event:VMvCEvent):void {
			_model.increaseLoadCounter();
			var e:VedEntryEvent = event as VedEntryEvent;
			var mr:MultiRequest = new MultiRequest();
			var toAdd:Array = e.data[0];	// categories to add to the entry
			var toRemove:Array = e.data[1];	// categories to remove from the entry
			
			var vCat:VidiunCategory;
			var ce:VidiunCategoryEntry;
			// add
			for each (vCat in toAdd) {
				ce = new VidiunCategoryEntry();
				ce.categoryId = vCat.id;
				ce.entryId = e.entryVo.id;
				mr.addAction(new CategoryEntryAdd(ce));
			} 
			// remove
			for each (vCat in toRemove) {
				ce = new VidiunCategoryEntry();
				mr.addAction(new CategoryEntryDelete(e.entryVo.id, vCat.id));
			} 
			
			
			mr.addEventListener(VidiunEvent.COMPLETE, result);
			mr.addEventListener(VidiunEvent.FAILED, fault);

			_client.post(mr);
		}
		
		
		override public function result(data:Object):void {
			super.result(data);
			var er:VidiunError = (data as VidiunEvent).error;
			for each (var o:Object in data.data) {
				er = o.error as VidiunError;
				if (er) {
					Alert.show(er.errorMsg, ResourceManager.getInstance().getString('drilldown', 'error'));
				}
			}
		
			_model.decreaseLoadCounter();
		}
	}
}