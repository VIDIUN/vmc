package com.vidiun.edw.control.commands {
	import com.vidiun.commands.accessControl.AccessControlList;
	import com.vidiun.edw.control.commands.VedCommand;
	import com.vidiun.edw.model.datapacks.FilterDataPack;
	import com.vidiun.events.VidiunEvent;
	import com.vidiun.vmvc.control.VMvCEvent;
	import com.vidiun.types.VidiunAccessControlOrderBy;
	import com.vidiun.vo.AccessControlProfileVO;
	import com.vidiun.vo.VidiunAccessControl;
	import com.vidiun.vo.VidiunAccessControlFilter;
	import com.vidiun.vo.VidiunAccessControlListResponse;
	import com.vidiun.vo.VidiunBaseRestriction;
	import com.vidiun.vo.VidiunFilterPager;
	
	import mx.collections.ArrayCollection;
	import mx.controls.Alert;
	import mx.resources.ResourceManager;

	public class ListAccessControlsCommand extends VedCommand {

		override public function execute(event:VMvCEvent):void {
			_model.increaseLoadCounter();
			var filter:VidiunAccessControlFilter = new VidiunAccessControlFilter();
			filter.orderBy = VidiunAccessControlOrderBy.CREATED_AT_DESC;
			var pager:VidiunFilterPager = new VidiunFilterPager();
			pager.pageSize = 1000;
			var listAcp:AccessControlList = new AccessControlList(filter, pager);
			listAcp.addEventListener(VidiunEvent.COMPLETE, result);
			listAcp.addEventListener(VidiunEvent.FAILED, fault);
			_client.post(listAcp);
		}


		override public function result(data:Object):void {
			super.result(data);
			if (data.success) {
				var response:VidiunAccessControlListResponse = data.data as VidiunAccessControlListResponse;
				var tempArrCol:ArrayCollection = new ArrayCollection();
				for each (var vac:VidiunAccessControl in response.objects) {
					var acVo:AccessControlProfileVO = new AccessControlProfileVO();
					acVo.profile = vac;
					acVo.id = vac.id;
					if (vac.restrictions ) {
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
				(_model.getDataPack(FilterDataPack) as FilterDataPack).filterModel.accessControlProfiles = tempArrCol;
			}
			else {
				Alert.show(data.error, ResourceManager.getInstance().getString('cms', 'error'));
			}

			_model.decreaseLoadCounter();
		}
	}
}