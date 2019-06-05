package com.vidiun.edw.model.datapacks
{
	import com.vidiun.vmvc.model.IDataPack;
	import com.vidiun.types.VidiunNullableBoolean;
	import com.vidiun.vo.VidiunBaseEntry;
	import com.vidiun.vo.VidiunUser;
	
	import mx.collections.ArrayCollection;
	
	[Bindable]
	/**
	 * information regarding the current entry, its replacement, etc
	 * */
	public class EntryDataPack implements IDataPack {
		
		/**
		 * max number of categories an entry may be associated with by default
		 * */
		public static const DEFAULT_CATEGORIES_NUM:int = 32;
		
		/**
		 * max number of categories an entry may be associated with if FEATURE_DISABLE_CATEGORY_LIMIT is on
		 * */
		public static const MANY_CATEGORIES_NUM:int = 200;
		
		
		public var shared:Boolean = false;
		
		/**
		 * the max number of categories to which an entry may be assigned 
		 */		
		public var maxNumCategories:int = MANY_CATEGORIES_NUM;
		
		/**
		 * list of Object {label}	<br>
		 * used for entry details window > entry metadata (autocomplete DP)
		 * */
		public var categoriesFullNameList:ArrayCollection = new ArrayCollection();
		
		/**
		 * Current Viewed Entry
		 */
		public var selectedEntry:VidiunBaseEntry;
		
		/**
		 * index of Current Viewed Entry
		 */
		public var selectedIndex:int;
		
		/**
		 * replacement entry of the selected entry 
		 */		
		public var selectedReplacementEntry:VidiunBaseEntry;
		
		
		/**
		 * Name of the replaced entry for the replacement entry
		 * */
		public var replacedEntryName:String;
		
		/**
		 * if selected entry was refreshed
		 * */
		public var selectedEntryReloaded:Boolean;
		
		/**
		 * if selected entry is a vidiun livestream entry, is it currently boradcasting HDS?
		 * (use Nullable so we can set "no value" and binding will fire)
		 */
		public var selectedLiveEntryIsLive:int = VidiunNullableBoolean.NULL_VALUE;
		
		/**
		 * when saving an entry we list all entries that have the same 
		 * referenceId as the entry being saved. this is the list.
		 */
		public var entriesWSameRefidAsSelected:Array;
		
		public var loadRoughcuts:Boolean = true;
		
		
		/**
		 * list of categories the current entry is associated with
		 */
		public var entryCategories:ArrayCollection;
		
		
		/**
		 * the owner of the selected entry
		 */		
		public var selectedEntryOwner:VidiunUser;
		
		/**
		 * the creator of the selected entry
		 */		
		public var selectedEntryCreator:VidiunUser;
		
		/**
		 * the editors of the selected entry
		 * [VidiunUser]
		 */		
		public var entryEditors:Array;
		
		/**
		 * the publishers of the selected entry
		 * [VidiunUser]
		 */		
		public var entryPublishers:Array;
	}
}