package com.vidiun.edw.model.util
{
	import mx.collections.ArrayCollection;
	import com.vidiun.vo.FlavorVO;
	import com.vidiun.vo.VidiunFlavorParams;
	import com.vidiun.utils.VCountriesUtil;
	import com.vidiun.vo.VidiunSiteRestriction;
	import com.vidiun.types.VidiunSiteRestrictionType;
	import mx.resources.ResourceManager;
	import mx.resources.IResourceManager;
	import com.vidiun.vo.VidiunIpAddressRestriction;
	import com.vidiun.types.VidiunIpAddressRestrictionType;
	import com.vidiun.vo.VidiunLimitFlavorsRestriction;
	import com.vidiun.types.VidiunLimitFlavorsRestrictionType;
	import com.vidiun.types.VidiunCountryRestrictionType;
	import com.vidiun.vo.VidiunCountryRestriction;
	import com.vidiun.edw.model.FilterModel;

	/**
	 * This class holds helper methods used in Entry Access Control section. 
	 * @author atar.shadmi
	 * @see modules.ved.EntryAccessControl
	 */
	public class EntryAccessControlUtil
	{
		private static var resourceManager:IResourceManager = ResourceManager.getInstance();
		
		private static var _filterModel:FilterModel;
		
		public static function setModel(value:FilterModel):void {
			_filterModel = value;
		}
		
		public static function getSiteRestrictionText (rstrct:VidiunSiteRestriction):String {
			var result:String;
			if (rstrct.siteRestrictionType == VidiunSiteRestrictionType.ALLOW_SITE_LIST) {
				result = resourceManager.getString('drilldown', 'ALLOW_SITES') + ":  ";
			}
			else {
				result = resourceManager.getString('drilldown', 'RESTRICT_SITES') + ":  ";
			}
			result += rstrct.siteList;
			return result;
		}
		
		public static function getIPRestrictionText (rstrct:VidiunIpAddressRestriction):String {
			var result:String;
			if (rstrct.ipAddressRestrictionType == VidiunIpAddressRestrictionType.ALLOW_LIST) {
				result = resourceManager.getString('drilldown', 'ALLOW_IPS') + ":  ";
			}
			else {
				result = resourceManager.getString('drilldown', 'RESTRICT_IPS') + ":  ";
			}
			result += rstrct.ipAddressList;
			return result;
		}
		
		/**
		 * NOTE: filter model must be set before triggering this method 
		 * @param rstrct
		 * @return 
		 * 
		 */
		public static function getFlavorRestrictionText (rstrct:VidiunLimitFlavorsRestriction):String {
			var result:String;
			if (rstrct.limitFlavorsRestrictionType == VidiunLimitFlavorsRestrictionType.ALLOW_LIST) {
				result = resourceManager.getString('drilldown', 'ALLOW_FLAVORS') + ":  ";
			}
			else {
				result = resourceManager.getString('drilldown', 'RESTRICT_FLAVORS') + ":  ";
			}
//			result += "\n";
			var tmp:Array = rstrct.flavorParamsIds.split(",");
			for each (var flavorParamsId:int in tmp) {
				result += "\n" + getFlavorNameById(flavorParamsId);
			}
//			if (tmp.length) {
//				// at least one flavor
//				result = result.substr(0, result.length - 2);
//			}
			return result;
		}
		
		public static function getCountryRestrictionText (rstrct:VidiunCountryRestriction):String {
			var result:String;
			if (rstrct.countryRestrictionType == VidiunCountryRestrictionType.ALLOW_COUNTRY_LIST) {
				result = resourceManager.getString('drilldown', 'ALLOW_COUNTRIES') + ": "
			}
			else {
				result = resourceManager.getString('drilldown', 'RESTRICT_COUNTRIES') + ": ";
			}
			result += "\n" + EntryAccessControlUtil.getCountriesList(rstrct.countryList);
			
			return result;
		}
		
		private static function getFlavorNameById(flavorParamsId:int):String {
			for each (var vFlavor:VidiunFlavorParams in _filterModel.flavorParams) {
				if (vFlavor.id == flavorParamsId) {
					return vFlavor.name;
				}
			}
			return '';
		}
		
		/**
		 * filter model holds VidiunFlavorParams, but the window requires FlavorVOs.
		 * this method wraps each VidiunFlavorParams in FlavorVO like Account module does.
		 * */
		public static function wrapInFlavorVo(ac:ArrayCollection):ArrayCollection {
			var tempArrCol:ArrayCollection = new ArrayCollection();
			var flavor:FlavorVO;
			for each(var vFlavor:Object in ac) {
				if (vFlavor is VidiunFlavorParams) {
					flavor = new FlavorVO();
					flavor.vFlavor = vFlavor as VidiunFlavorParams;
					tempArrCol.addItem(flavor);
				}
			}
			return tempArrCol;
		}
		
		
		public static function getCountriesList(countriesCodesList:String):String {
			var cArr:Array = countriesCodesList.split(',');
			var countriesList:String = '';
			for each (var countryCode:String in cArr) {
				countriesList += VCountriesUtil.instance.getCountryName(countryCode) + ', ';
			}
			
			return countriesList.substr(0, countriesList.length - 2);
		}
		
		
		/**
		 * show profile name in profiles dropdown 
		 * @param item
		 * @return 
		 * 
		 */
		public static function dropdownLabelFunction(item:Object):String {
			return item.profile.name;
		}
	}
}