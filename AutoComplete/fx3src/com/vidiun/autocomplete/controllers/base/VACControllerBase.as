package com.vidiun.autocomplete.controllers.base
{
	import com.hillelcoren.components.AutoComplete;
	import com.vidiun.VidiunClient;
	import com.vidiun.core.VClassFactory;
	import com.vidiun.events.VidiunEvent;
	import com.vidiun.net.VidiunCall;
	
	import flash.events.Event;
	import flash.utils.setTimeout;
	
	import mx.collections.ArrayCollection;

	public class VACControllerBase
	{
		public var minPrefixLength:uint = 3;
		
		protected var _elementSelection:ArrayCollection;
		protected var _autoComp:AutoComplete;
		protected var _client:VidiunClient;
		
		private var _pendingCall:VidiunCall;
		
		public function VACControllerBase(autoComp:AutoComplete, client:VidiunClient)
		{
			_elementSelection = new ArrayCollection();
			_autoComp = autoComp;
			_autoComp.autoSelectEnabled = false;
			_autoComp.backspaceAction = AutoComplete.BACKSPACE_REMOVE;
			_autoComp.showRemoveIcon = true;
			_autoComp.setStyle("selectedItemStyleName", "selectionBox");
			_autoComp.setStyle("autoCompleteDropDownStyleName", "autoCompleteDropDown");
			_client = client;
			
			_autoComp.dataProvider = _elementSelection;
			_autoComp.addEventListener(AutoComplete.SEARCH_CHANGE, onSearchChange);
		}
		
		private function onSearchChange(event:Event):void{
			if (_autoComp.searchText != null){
				if (_pendingCall != null){
					_pendingCall.removeEventListener(VidiunEvent.COMPLETE, result);
					_pendingCall.removeEventListener(VidiunEvent.FAILED, fault);
				}
				
				_autoComp.clearSuggestions();
				
				if (_autoComp.searchText.length > (minPrefixLength - 1)){
					_elementSelection.removeAll();
					
					var call:VidiunCall = createCallHook();
					
					call.addEventListener(VidiunEvent.COMPLETE, result);
					call.addEventListener(VidiunEvent.FAILED, fault);
					call.queued = false;
					_autoComp.notifySearching();
					_pendingCall = call;
					_client.post(call);
				} 
			}
		}
		
		private function result(data:Object):void{
			_pendingCall = null;
			var elements:Array = fetchElements(data);
			if (elements != null && elements.length > 0){
				for each (var element:Object in elements){
					_elementSelection.addItem(element);
				}
			}
			_autoComp.search();
		}
		
		protected function fault(info:VidiunEvent):void{
			throw new Error(info.error.errorMsg);
		}
		
		protected function fetchElements(data:Object):Array{
			return null;
		}
		
		protected function createCallHook():VidiunCall{
			return null;
		}
	}
}