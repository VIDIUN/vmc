package com.vidiun.edw.control.events
{
	import com.vidiun.edw.business.IDataOwner;
	import com.vidiun.edw.model.FilterModel;
	import com.vidiun.vmvc.control.VMvCEvent;
	
	public class LoadEvent extends VMvCEvent {
		
		public static const LOAD_FILTER_DATA : String = "content_loadFilterData";
		public static const LOAD_ENTRY_DATA : String = "content_loadEntryData";
		
		private var _caller : IDataOwner;
		private var _entryId:String;
		private var _filterModel:FilterModel;
		
		public function LoadEvent(type:String, owner:IDataOwner, filterModel:FilterModel, entryid:String = '', bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
			_caller = owner;
			_filterModel = filterModel;
			_entryId = entryid;
		}
		
		/**
		 * the component who triggered this data load 
		 */
		public function get caller():IDataOwner
		{
			return _caller;
		}

		/**
		 * on entry data load, the id of the entry in question. 
		 */		
		public function get entryId():String
		{
			return _entryId;
		}
		
		/**
		 * for filter data load, the filtermodel to use 
		 */		
		public function get filterModel():FilterModel
		{
			return _filterModel;
		}

	}
}