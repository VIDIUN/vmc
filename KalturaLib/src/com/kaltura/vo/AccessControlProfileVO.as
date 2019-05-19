package com.vidiun.vo {
	import com.adobe.cairngorm.vo.IValueObject;
	
	import mx.utils.ObjectProxy;
	import flash.utils.flash_proxy;

	[Bindable]
	/**
	 * This class is a wrapper for the VidiunAccessControl VO.
	 */
	public class AccessControlProfileVO extends ObjectProxy implements IValueObject {
		
		
		public static const SELECTED_CHANGED_EVENT:String = "accessControlSelectedChanged";


		/**
		 *  VidiunAccessControl VO, hold all the profile properties
		 */
		public var profile:VidiunAccessControl;
		
		/**
		 * id of the wrapped profile 
		 */		
		public var id:int;


		/**
		 * Constructor
		 *
		 */
		public function AccessControlProfileVO() {
//			profile = new VidiunAccessControl();
		}



		/**
		 * Creates a AccessControlProfileVO
		 * @return a new AccessControlProfileVO object
		 *
		 */
		public function clone():AccessControlProfileVO {
			var newAcp:AccessControlProfileVO = new AccessControlProfileVO();
			newAcp.profile = new VidiunAccessControl();
			newAcp.profile.name = this.profile.name.slice();
			newAcp.profile.description = this.profile.description.slice();
			newAcp.profile.createdAt = this.profile.createdAt;
			newAcp.profile.id = this.profile.id;
			newAcp.profile.isDefault = this.profile.isDefault;
			newAcp.profile.restrictions = new Array();

			for each (var restriction:VidiunBaseRestriction in this.profile.restrictions) {
				if (restriction is VidiunSiteRestriction) {
					var vsr:VidiunSiteRestriction = new VidiunSiteRestriction();
					vsr.siteRestrictionType = (restriction as VidiunSiteRestriction).siteRestrictionType;
					vsr.siteList = (restriction as VidiunSiteRestriction).siteList;
					newAcp.profile.restrictions.push(vsr);
				}
				else if (restriction is VidiunCountryRestriction) {
					var vcr:VidiunCountryRestriction = new VidiunCountryRestriction();
					vcr.countryRestrictionType = (restriction as VidiunCountryRestriction).countryRestrictionType;
					vcr.countryList = (restriction as VidiunCountryRestriction).countryList;
					newAcp.profile.restrictions.push(vcr);
				}
				else if (restriction is VidiunPreviewRestriction) {
					var vpr:VidiunPreviewRestriction = new VidiunPreviewRestriction();
					vpr.previewLength = (restriction as VidiunPreviewRestriction).previewLength;
					newAcp.profile.restrictions.push(vpr);
				}
				else if (restriction is VidiunSessionRestriction) {
					var vser:VidiunSessionRestriction = new VidiunSessionRestriction();
					newAcp.profile.restrictions.push(vser);
				}
				else if (restriction is VidiunDirectoryRestriction) {
					var vdr:VidiunDirectoryRestriction = new VidiunDirectoryRestriction();
					vdr.directoryRestrictionType = (restriction as VidiunDirectoryRestriction).directoryRestrictionType;
					newAcp.profile.restrictions.push(vdr);
				}
				else if (restriction is VidiunIpAddressRestriction) {
					var vir:VidiunIpAddressRestriction = new VidiunIpAddressRestriction();
					vir.ipAddressRestrictionType = (restriction as VidiunIpAddressRestriction).ipAddressRestrictionType;
					vir.ipAddressList = (restriction as VidiunIpAddressRestriction).ipAddressList;
					newAcp.profile.restrictions.push(vir);
				}
				else if (restriction is VidiunLimitFlavorsRestriction) {
					var vlf:VidiunLimitFlavorsRestriction = new VidiunLimitFlavorsRestriction();
					vlf.limitFlavorsRestrictionType = (restriction as VidiunLimitFlavorsRestriction).limitFlavorsRestrictionType;
					vlf.flavorParamsIds = (restriction as VidiunLimitFlavorsRestriction).flavorParamsIds;
					newAcp.profile.restrictions.push(vlf);
				}
			}


			return newAcp;
		}

	}
}
