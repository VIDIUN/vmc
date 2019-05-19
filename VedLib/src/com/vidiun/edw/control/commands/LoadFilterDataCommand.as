package com.vidiun.edw.control.commands
{
	import com.vidiun.commands.MultiRequest;
	import com.vidiun.commands.accessControl.AccessControlList;
	import com.vidiun.commands.baseEntry.BaseEntryCount;
	import com.vidiun.commands.category.CategoryList;
	import com.vidiun.commands.distributionProfile.DistributionProfileList;
	import com.vidiun.commands.flavorParams.FlavorParamsList;
	import com.vidiun.core.VClassFactory;
	import com.vidiun.dataStructures.HashMap;
	import com.vidiun.edw.business.ClientUtil;
	import com.vidiun.edw.business.IDataOwner;
	import com.vidiun.edw.control.DataTabController;
	import com.vidiun.edw.control.events.LoadEvent;
	import com.vidiun.edw.control.events.MetadataProfileEvent;
	import com.vidiun.edw.model.FilterModel;
	import com.vidiun.edw.model.datapacks.DistributionDataPack;
	import com.vidiun.edw.model.datapacks.EntryDataPack;
	import com.vidiun.edw.model.util.FlavorParamsUtil;
	import com.vidiun.edw.vo.CategoryVO;
	import com.vidiun.events.VidiunEvent;
	import com.vidiun.vmvc.control.VMvCEvent;
	import com.vidiun.types.VidiunAccessControlOrderBy;
	import com.vidiun.types.VidiunDistributionProfileStatus;
	import com.vidiun.types.VidiunEntryStatus;
	import com.vidiun.types.VidiunMediaType;
	import com.vidiun.vo.AccessControlProfileVO;
	import com.vidiun.vo.VidiunAccessControl;
	import com.vidiun.vo.VidiunAccessControlFilter;
	import com.vidiun.vo.VidiunAccessControlListResponse;
	import com.vidiun.vo.VidiunBaseRestriction;
	import com.vidiun.vo.VidiunCategory;
	import com.vidiun.vo.VidiunCategoryFilter;
	import com.vidiun.vo.VidiunCategoryListResponse;
	import com.vidiun.vo.VidiunDistributionProfile;
	import com.vidiun.vo.VidiunDistributionProfileListResponse;
	import com.vidiun.vo.VidiunDistributionThumbDimensions;
	import com.vidiun.vo.VidiunFilterPager;
	import com.vidiun.vo.VidiunFlavorParams;
	import com.vidiun.vo.VidiunFlavorParamsListResponse;
	import com.vidiun.vo.VidiunMediaEntryFilter;
	
	import flash.xml.XMLDocument;
	import flash.xml.XMLNode;
	
	import mx.collections.ArrayCollection;
	import mx.collections.Sort;
	import mx.collections.SortField;
	import mx.resources.ResourceManager;
	import mx.rpc.xml.SimpleXMLEncoder;

	/**
	 * load all data that is relevant for filter:
	 * <lu>
	 * <li>distribution profiles</li>
	 * <li>flavor params</li>
	 * <li>metadata profile</li>
	 * <li>access control profiles</li>
	 * <li>categories</li>
	 * </lu> 
	 * @author Atar
	 * 
	 */	
	public class LoadFilterDataCommand extends VedCommand {
		
		public static const DEFAULT_PAGE_SIZE:int = 500;
		
		/**
		 * reference to the filter model in use
		 * */
		private var _filterModel:FilterModel;
		
		/**
		 * the element that triggered the data load.
		 */		
		private var _caller:IDataOwner;
		
		override public function execute(event:VMvCEvent):void {
			_caller = (event as LoadEvent).caller;
			_filterModel = (event as LoadEvent).filterModel;
			
			if (!_filterModel.loadingRequired) {
				_caller.onRequestedDataLoaded();				
				return;
			}
			
			_model.increaseLoadCounter();
			
			var pager:VidiunFilterPager;
			
			// custom data hack
			if (_filterModel.enableCustomData) {
				var lmdp:MetadataProfileEvent = new MetadataProfileEvent(MetadataProfileEvent.LIST);
				DataTabController.getInstance().dispatch(lmdp);
			}
			
			var multiRequest:MultiRequest = new MultiRequest();
			
			// distribution
			if (_filterModel.enableDistribution) {
				pager = new VidiunFilterPager();
				pager.pageSize = DEFAULT_PAGE_SIZE;
				var listDistributionProfile:DistributionProfileList = new DistributionProfileList(null, pager);
				multiRequest.addAction(listDistributionProfile);
			}
			// flavor params
			pager = new VidiunFilterPager();
			pager.pageSize = DEFAULT_PAGE_SIZE;
			var listFlavorParams:FlavorParamsList = new FlavorParamsList(null, pager);
			multiRequest.addAction(listFlavorParams);
			// access control
			var acfilter:VidiunAccessControlFilter = new VidiunAccessControlFilter();
			acfilter.orderBy = VidiunAccessControlOrderBy.CREATED_AT_DESC;
			pager = new VidiunFilterPager();
			pager.pageSize = 1000;
			var getListAccessControlProfiles:AccessControlList = new AccessControlList(acfilter, pager);
			multiRequest.addAction(getListAccessControlProfiles);
			
			// listeners
			multiRequest.addEventListener(VidiunEvent.COMPLETE, result);
			multiRequest.addEventListener(VidiunEvent.FAILED, fault);
			
			_client.post(multiRequest);
		}
	
		override public function result(data:Object):void {
			if (!checkErrors(data)) {
				var responseCount:int = 0;
				
				if (_filterModel.enableDistribution) {
					// distribution
					handleListDistributionProfileResult(data.data[responseCount] as VidiunDistributionProfileListResponse);
					responseCount ++;
				}
				
				// flavor params
				handleFlavorsData(data.data[responseCount] as VidiunFlavorParamsListResponse);
				responseCount ++;
				
				// access control
				handleAccessControls(data.data[responseCount] as VidiunAccessControlListResponse);
				responseCount ++;
				
				_filterModel.loadingRequired = false;
				_caller.onRequestedDataLoaded();
			}
			_model.decreaseLoadCounter();

		}
		
		
		/**
		 * coppied from ListDistributionProfilesCommand 
		 */
		private function handleListDistributionProfileResult(profilesResult:VidiunDistributionProfileListResponse) : void {
			var dum:VidiunDistributionThumbDimensions;
			var profilesArray:Array = new Array();
			//as3flexClient can't generate these objects since we don't include them in the swf 
			for each (var profile:Object in profilesResult.objects) {
				var newProfile:VidiunDistributionProfile;
				if (profile is VidiunDistributionProfile) {
					newProfile = profile as VidiunDistributionProfile;
				}
				else {
					newProfile = ClientUtil.createClassInstanceFromObject(VidiunDistributionProfile, profile);
					//fix bug: simpleXmlEncoder not working properly for nested objects
					if (profile.requiredThumbDimensions is Array)
						newProfile.requiredThumbDimensions = profile.requiredThumbDimensions;
				}
				if (newProfile.status == VidiunDistributionProfileStatus.ENABLED)
					profilesArray.push(newProfile);
			}
			var ddp:DistributionDataPack = _model.getDataPack(DistributionDataPack) as DistributionDataPack;
			ddp.distributionInfo.distributionProfiles = profilesArray;
			ddp.distributionInfo.entryDistributions = new Array();
		}
		
		
		/**
		 * coppied from ListFlavorsParamsCommand 
		 */
		private function handleFlavorsData(response:VidiunFlavorParamsListResponse):void {
			clearOldFlavorData();
			var tempFlavorParamsArr:ArrayCollection = new ArrayCollection();
			// loop on Object and cast to VidiunFlavorParams so we don't crash on unknown types:
			for each (var vFlavor:Object in response.objects) {
				if (vFlavor is VidiunFlavorParams) {
					tempFlavorParamsArr.addItem(vFlavor);
				}
				else {
					tempFlavorParamsArr.addItem(FlavorParamsUtil.makeFlavorParams(vFlavor));
				}
			}
			_filterModel.flavorParams = tempFlavorParamsArr;
		}
		
		
		/**
		 * coppied from ListAccessControlsCommand 
		 */
		private function handleAccessControls(response:VidiunAccessControlListResponse):void {
			var tempArrCol:ArrayCollection = new ArrayCollection();
			for each(var vac:VidiunAccessControl in response.objects)
			{
				var acVo:AccessControlProfileVO = new AccessControlProfileVO();
				acVo.profile = vac;
				acVo.id = vac.id;
				if (vac.restrictions) {
					// remove unknown objects
					// if any restriction is unknown, we remove it from the list.
					// this means it is not supported in VMC at the moment
					for (var i:int = 0; i<vac.restrictions.length; i++) {
						if (! (vac.restrictions[i] is VidiunBaseRestriction)) {
							vac.restrictions.splice(i, 1);
						}
					}
				}
				tempArrCol.addItem(acVo);
			}
			_filterModel.accessControlProfiles = tempArrCol;
		}
		
		
		
		private function clearOldFlavorData():void {
			_filterModel.flavorParams.removeAll();
		}
		
	}
}