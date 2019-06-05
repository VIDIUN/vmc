package com.vidiun.vmc.modules.content.commands
{
	import com.adobe.cairngorm.control.CairngormEvent;
	import com.vidiun.commands.MultiRequest;
	import com.vidiun.commands.categoryEntry.CategoryEntryDelete;
	import com.vidiun.errors.VidiunError;
	import com.vidiun.events.VidiunEvent;
	import com.vidiun.vmc.modules.content.events.EntriesEvent;
	import com.vidiun.vmc.modules.content.events.VMCSearchEvent;
	import com.vidiun.vo.VidiunBaseEntry;
	import com.vidiun.vo.VidiunCategory;
	import com.vidiun.vo.VidiunCategoryEntry;
	
	import mx.collections.ArrayCollection;
	import mx.controls.Alert;
	import mx.resources.IResourceManager;
	import mx.resources.ResourceManager;

	public class RemoveCategoriesEntriesCommand extends VidiunCommand {
		
		
		private static const CHUNK_SIZE:int = 50;
		private var _calls:Array; 
		
		
		/**
		 * crete the list of categoryEntry.delete calls that should be executed
		 * according to given entries and categories
		 * */
		private function genenrateCallsList(entries:Array, categories:Array):Array {
			var calls:Array = [];
			var ced:CategoryEntryDelete;
			var vce:VidiunCategoryEntry;
			for each (var vbe:VidiunBaseEntry in entries) {
				for each (var vc:VidiunCategory in categories) {
					for (var i:int = 0; i<_model.selectedEntriesCategoriesVObjects.length; i++) {
						vce = _model.selectedEntriesCategoriesVObjects[i] as VidiunCategoryEntry;
						if (vce.entryId == vbe.id && vce.categoryId == vc.id) {
							ced = new CategoryEntryDelete(vbe.id, vc.id);
							calls.push(ced);
							_model.selectedEntriesCategoriesVObjects.splice(i, 1);
							break;
						}
					}
				}
			}
			return calls;
		}
		
		
		/**
		 * send an MR with up-to-CHUNK_SIZE next calls
		 * */ 
		private function issueNextCall():void {
			_model.increaseLoadCounter();
			var mr:MultiRequest = new MultiRequest();
			mr.actions = _calls.splice(0, CHUNK_SIZE);
			mr.addEventListener(VidiunEvent.COMPLETE, result);
			mr.addEventListener(VidiunEvent.FAILED, fault);
			_model.context.vc.post(mr);
		}
		
		
		override public function execute(event:CairngormEvent):void {
			// for each entry, if it has the category remove it.
			// split calls array to chunks of CHUNK_SIZE calls per MR
			var e:EntriesEvent = event as EntriesEvent;
			var categories:Array = e.data as Array; // elements are VidiunCategories
			var entries:Array = _model.selectedEntries;
			
			_calls = this.genenrateCallsList(entries, categories);
			_model.selectedEntriesCategoriesVObjects = null;
			issueNextCall(); 
		}
		
		
		override public function result(data:Object):void {
			super.result(data);
			_model.decreaseLoadCounter();
			
			// look for error
			var str:String = '';
			var er:VidiunError = (data as VidiunEvent).error;
			var rm:IResourceManager = ResourceManager.getInstance();
			if (er) {
				str = rm.getString('cms', er.errorCode);
				if (!str) {
					str = er.errorMsg;
				} 
				Alert.show(str, rm.getString('cms', 'error'));
				
			}
			else {
				// look inside MR, ignore irrelevant
				for each (var o:Object in data.data) {
					er = o as VidiunError;
					if (er) {
						if (er.errorCode != "ENTRY_IS_NOT_ASSIGNED_TO_CATEGORY") {
							str = rm.getString('cms', er.errorCode);
							if (!str) {
								str = er.errorMsg;
							} 
							Alert.show(str, rm.getString('cms', 'error'));
						}
					}
					else if (o.error) {
						// in MR errors aren't created
						if (o.error.code != "ENTRY_IS_NOT_ASSIGNED_TO_CATEGORY") {
							str = rm.getString('cms', o.error.code);
							if (!str) {
								str = o.error.message;
							} 
							Alert.show(str, rm.getString('cms', 'error'));
						}
					}
				}	
			}
			if (_calls.length > 0) {
				issueNextCall();
			}
			else {
				allChunksDone();
			}
		}
		
		private function allChunksDone():void {
			var searchEvent:VMCSearchEvent = new VMCSearchEvent(VMCSearchEvent.DO_SEARCH_ENTRIES , _model.listableVo  );
			searchEvent.dispatch();
		}
	}
}