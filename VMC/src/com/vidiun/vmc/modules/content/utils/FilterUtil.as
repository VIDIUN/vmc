package com.vidiun.vmc.modules.content.utils
{
	import com.vidiun.vmc.modules.account.view.CustomData;
	import com.vidiun.types.VidiunSearchOperatorType;
	import com.vidiun.vo.VidiunBaseEntryFilter;
	import com.vidiun.vo.VidiunMediaEntryFilter;
	import com.vidiun.vo.VidiunMetadataSearchItem;
	import com.vidiun.vo.VidiunPlaylistFilter;
	import com.vidiun.vo.VidiunSearchCondition;
	import com.vidiun.vo.VidiunSearchOperator;
	
	import mx.utils.Base64Decoder;

	/**
	 * this class provides method required for manipulations 
	 * on a string passed to Content module as initial entries filter  
	 * @author atar.shadmi
	 * 
	 */
	public class FilterUtil
	{
		/**
		 * creates a VidiunMediaEntryFilter from encoded data
		 * @param filter	encoded filter data
		 * */
		public static function createFilterFromString(filter:String):VidiunBaseEntryFilter {
			var dec:Base64Decoder = new Base64Decoder();
			dec.decode(filter);
			var filterString:String = dec.toByteArray().toString();
			var filterArray:Array = filterString.split("&");
			
			// distinguish between playlist and entry:
			var vmef:VidiunBaseEntryFilter;
			for (var j:int = 0; j < filterArray.length; j++) {
				if (filterArray[j].indexOf("objectType") == 0) {
					var cls:String = filterArray[j].split("=")[1];
					if (cls == "VidiunPlaylistFilter") {
						vmef = new VidiunPlaylistFilter();
					}
					else {
						vmef = new VidiunMediaEntryFilter();
					}
					break;
				}
			}
			
			var att:Array;
			var customDataFilters:Array = [];
			for (var i:int = 0; i < filterArray.length; i++) {
				att = filterArray[i].split("=");
				if (att[1] != '') {
					if (att[0].indexOf('customData:') == 0) {
						saveCustomDataValue(customDataFilters, filterArray[i]);
					}
					else {
						// VidiunMediaEntryFilter is dynamic, ok to put all values without testing
						vmef[att[0]] = att[1];
					}
				}
			}
			// parse the custom data array and make it advanced search component
			if (customDataFilters.length > 0) {
				handleCustomDataFilter(vmef, customDataFilters);
			}
			return vmef;
		}
		
		/**
		 * save custom data values to 3-atted objects according to index in the given array
		 * @param customDataFilters	the array holding custom data for processing
		 * @param key	the full key (customData:<ind>:<profileId|field|value>=<whatever>)
		 */
		public static function saveCustomDataValue(customDataFilters:Array, key:String):void {
			var regex:RegExp = /^customData:(\d*):(profileId|field|value)=(.*)$/;
			var ind:int = parseInt(key.replace(regex, "$1"));	// returns the index
			var att:String = key.replace(regex, "$2");	// profileId|field|value
			var value:* = key.replace(regex, "$3");
			var vo:CustomDataVo = customDataFilters[ind]; 
			if (!vo) {
				vo = new CustomDataVo();
				customDataFilters[ind] = vo;
			}
			vo[att] = value;
		}
		
		/**
		 * create custom data filter, including advanced search if required.
		 * @param vmef	filter to manipulate
		 * @param key	either profile id, field or value
		 * @param value	value for the given attribute
		 * 
		 */
		public static function handleCustomDataFilter(vmef:VidiunBaseEntryFilter, customDataFilters:Array):void {
			if (!vmef.advancedSearch) {
				// create advanced search component
				vmef.advancedSearch = new VidiunSearchOperator();
				vmef.advancedSearch.type = VidiunSearchOperatorType.SEARCH_AND;
				vmef.advancedSearch.items = new Array();
			}
			
			
			for (var i:int = 0; i<customDataFilters.length; i++) {
				var cdvo:CustomDataVo = customDataFilters[i] as CustomDataVo;
				var profileSearchItem:VidiunMetadataSearchItem = getMetadataProfileSearchItem(vmef.advancedSearch.items, cdvo.profileId);
				var fieldSearchCondition:VidiunSearchCondition = getMetadataFieldSearchCondition(profileSearchItem, cdvo.field);
				fieldSearchCondition.value = cdvo.value;
			}
		}
		
		
		
		/**
		 * get a new searchCondition for the given field
		 * @param fields 	all fields search items of the profile
		 * @param field		x-path of the field as in schema
		 * @return 	search condition that matches the given field
		 */
		public static function getMetadataFieldSearchCondition(profileSearchItem:VidiunMetadataSearchItem, field:String):VidiunSearchCondition {
			var searchItem:VidiunMetadataSearchItem;
			var searchCond:VidiunSearchCondition;
			var found:Boolean;
			
			for each (searchItem in profileSearchItem.items) {	
				if (searchItem) {
					if (searchItem.items.length > 0) {
						for each (searchCond in searchItem.items) {
							if (searchCond.field == field) {
								found = true;
								break;
							}
						} 
					}
					//else never supposed to happen
				}
			} 
			if (!found) {
				// create searchItem for the field
				searchItem = new VidiunMetadataSearchItem();
				searchItem.metadataProfileId = profileSearchItem.metadataProfileId;
				searchItem.type = VidiunSearchOperatorType.SEARCH_OR;
				searchItem.items = [];
				profileSearchItem.items.push(searchItem);
			}
			
			// create a searchCondition
			searchCond = new VidiunSearchCondition();
			searchCond.field = field;
			searchItem.items.push(searchCond);
			
			return searchCond;
		}
		
		
		
		
		/**
		 * get an existing searchItem if any, or a new one. 
		 * @param items
		 * @param profileId
		 * @return metadata profile searchItem corresponding to the given profile id
		 */
		public static function getMetadataProfileSearchItem(items:Array, profileId:int):VidiunMetadataSearchItem {
			var searchItem:VidiunMetadataSearchItem;
			var found:Boolean;
			
			for each (searchItem in items) {
				if (searchItem && searchItem.metadataProfileId == profileId) {
					found = true;
					break;
				}
			} 
			if (!found) {
				// create serachItem for the profile
				searchItem = new VidiunMetadataSearchItem();
				searchItem.metadataProfileId = profileId;
				searchItem.type = VidiunSearchOperatorType.SEARCH_AND;
				searchItem.items = [];
				items.push(searchItem);
			}
			return searchItem;
		}

	}
}

class CustomDataVo {
	public var profileId:int;
	public var field:String;
	public var value:String;
}