package com.vidiun.edw.control.commands {
	import com.vidiun.commands.baseEntry.BaseEntryGet;
	import com.vidiun.edw.business.EntryUtil;
	import com.vidiun.edw.control.events.VedEntryEvent;
	import com.vidiun.edw.events.VedDataEvent;
	import com.vidiun.edw.model.datapacks.ContextDataPack;
	import com.vidiun.edw.model.datapacks.EntryDataPack;
	import com.vidiun.edw.model.types.APIErrorCode;
	import com.vidiun.errors.VidiunError;
	import com.vidiun.events.VidiunEvent;
	import com.vidiun.vmvc.control.VMvCEvent;
	import com.vidiun.vo.VidiunBaseEntry;
	import com.vidiun.vo.VidiunClipAttributes;
	
	import flash.events.IEventDispatcher;
	
	import mx.events.PropertyChangeEvent;

	public class GetSingleEntryCommand extends VedCommand {

		private var _eventType:String;
		
		override public function execute(event:VMvCEvent):void {
			_model.increaseLoadCounter();
			var e:VedEntryEvent = event as VedEntryEvent;
			_eventType = e.type;
			if (_eventType == VedEntryEvent.UPDATE_SELECTED_ENTRY_REPLACEMENT_STATUS) {
				(_model.getDataPack(EntryDataPack) as EntryDataPack).selectedEntryReloaded = false;
			}
			
			var getEntry:BaseEntryGet = new BaseEntryGet(e.entryId);

			getEntry.addEventListener(VidiunEvent.COMPLETE, result);
			getEntry.addEventListener(VidiunEvent.FAILED, fault);

			_client.post(getEntry);
		}


		override public function result(data:Object):void {
			var clipAttributes:VidiunClipAttributes; // compile this type into VMC
			super.result(data);
			
			if (data.data && data.data is VidiunBaseEntry) {
				var resultEntry:VidiunBaseEntry = data.data as VidiunBaseEntry;
				var edp:EntryDataPack = _model.getDataPack(EntryDataPack) as EntryDataPack;
				var dsp:IEventDispatcher = (_model.getDataPack(ContextDataPack) as ContextDataPack).dispatcher;
				if (_eventType == VedEntryEvent.GET_REPLACEMENT_ENTRY) {
					edp.selectedReplacementEntry = resultEntry;
				}
				else if (_eventType == VedEntryEvent.UPDATE_SELECTED_ENTRY_REPLACEMENT_STATUS) {
					var selectedEntry:VidiunBaseEntry = edp.selectedEntry;
					EntryUtil.updateChangebleFieldsOnly(resultEntry, selectedEntry);
					var e:VedDataEvent = new VedDataEvent(VedDataEvent.ENTRY_RELOADED);
					e.data = selectedEntry; 
					dsp.dispatchEvent(e);
					
					edp.selectedEntryReloaded = true;
				}
				else {
					// let the env.app know the entry is loaded so it can open another drilldown window
					var ee:VedDataEvent = new VedDataEvent(VedDataEvent.OPEN_ENTRY);
					ee.data = resultEntry; 
					dsp.dispatchEvent(ee);
				}
			}
			else {
				trace(_eventType, ": Error getting entry");
			}
			_model.decreaseLoadCounter();
		}

		
		override public function fault(info:Object):void {
			//if entry replacement doesn't exist it means that the replacement is ready
			if (_eventType == VedEntryEvent.GET_REPLACEMENT_ENTRY || _eventType == VedEntryEvent.UPDATE_SELECTED_ENTRY_REPLACEMENT_STATUS) {
				var er:VidiunError = (info as VidiunEvent).error;
				if (er.errorCode == APIErrorCode.ENTRY_ID_NOT_FOUND) {
					trace("GetSingleEntryCommand 703");
					_model.decreaseLoadCounter();
					return;
				}
			}

			super.fault(info);
		}
	}
}