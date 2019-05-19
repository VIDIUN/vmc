package com.vidiun.vmc.modules.content.commands {
	import com.adobe.cairngorm.commands.ICommand;
	import com.adobe.cairngorm.control.CairngormEvent;
	import com.vidiun.commands.MultiRequest;
	import com.vidiun.commands.uiConf.UiConfList;
	import com.vidiun.commands.uiConf.UiConfListTemplates;
	import com.vidiun.events.VidiunEvent;
	import com.vidiun.vmc.modules.content.events.UIConfEvent;
	import com.vidiun.vo.VidiunFilterPager;
	import com.vidiun.vo.VidiunUiConf;
	import com.vidiun.vo.VidiunUiConfFilter;
	import com.vidiun.vo.VidiunUiConfListResponse;
	
	import mx.collections.ArrayCollection;
	import mx.controls.Alert;
	import mx.resources.ResourceManager;
	import mx.rpc.IResponder;

	public class ListUIConfCommand extends VidiunCommand implements ICommand, IResponder {
		private var players:ArrayCollection;
		private var lastPage:int = 1;
		private var totalCount:int = 0;
		private var filter:VidiunUiConfFilter;
		
		private const CHUNK_SIZE:int = 500;


		override public function execute(event:CairngormEvent):void {
			_model.increaseLoadCounter();

			var mr:MultiRequest = new MultiRequest();

			filter = new VidiunUiConfFilter();
			filter.partnerIdEqual = 0; // we assume the general partner is always 0
			filter.tagsMultiLikeAnd = "autodeploy,vmc_v" + VMC.VERSION + ",vmc_previewembed";

			var getUIConfTemplates:UiConfListTemplates = new UiConfListTemplates(filter);
			mr.addAction(getUIConfTemplates);

			filter = (event as UIConfEvent).uiConfFilter;
			var pager:VidiunFilterPager = new VidiunFilterPager();
			pager.pageSize = CHUNK_SIZE;
			pager.pageIndex = 1;
			var getListUIConfs:UiConfList = new UiConfList(filter, pager);
			mr.addAction(getListUIConfs);

			mr.addEventListener(VidiunEvent.COMPLETE, result);
			mr.addEventListener(VidiunEvent.FAILED, fault);
			_model.context.vc.post(mr);
		}


		override public function result(event:Object):void {
			super.result(event);
			var uiConf:VidiunUiConf;

			if (event.error != null) {
				Alert.show(ResourceManager.getInstance().getString('cms', 'playersListErrorMsg'), ResourceManager.getInstance().getString('cms', 'error'));
			}

			players = new ArrayCollection();
			// process templates
			var response:VidiunUiConfListResponse = event.data[0] as VidiunUiConfListResponse;
			for each (var uiconf:VidiunUiConf in response.objects) {
				if (uiconf.name.toLocaleLowerCase() == "dark player") {
					players.addItemAt(uiconf, 0);
				}
				else {
					players.addItem(uiconf);
				}
			}

			// process partner players
			response = event.data[1] as VidiunUiConfListResponse;
			for each (uiconf in response.objects) {
				uiconf.name = ((uiconf.name == null) || (uiconf.name == '')) ? "Player(" + uiconf.id + ")" : uiconf.name;
				players.addItem(uiconf);
			}
			// see if we have more players:
			if (response.totalCount > CHUNK_SIZE) {
				lastPage ++;
				getPlayersListPage(lastPage);
			}
			else {
				_model.extSynModel.uiConfData = players;
				_model.decreaseLoadCounter();	
			}
		}
		
		
		private function getPlayersListPage(nPage:int):void {
			var pager:VidiunFilterPager = new VidiunFilterPager();
			pager.pageSize = CHUNK_SIZE;
			pager.pageIndex = nPage;
			var listUIConfs:UiConfList = new UiConfList(filter, pager);
			listUIConfs.addEventListener(VidiunEvent.COMPLETE, result2);
			listUIConfs.addEventListener(VidiunEvent.FAILED, fault);
			_model.context.vc.post(listUIConfs);
		}
		
		
		private function result2(event:Object):void {
			super.result(event);
			var uiConf:VidiunUiConf;
			
			if (event.error != null) {
				Alert.show(ResourceManager.getInstance().getString('cms', 'playersListErrorMsg'), ResourceManager.getInstance().getString('cms', 'error'));
			}
			
			// process partner players
			var response:VidiunUiConfListResponse = event.data as VidiunUiConfListResponse;
			for each (var uiconf:VidiunUiConf in response.objects) {
				uiconf.name = ((uiconf.name == null) || (uiconf.name == '')) ? "Player(" + uiconf.id + ")" : uiconf.name;
				players.addItem(uiconf);
			}
			// see if we have more players:
			if (response.totalCount > CHUNK_SIZE * lastPage) {
				lastPage ++;
				getPlayersListPage(lastPage);
			}
			else {
				_model.extSynModel.uiConfData = players;
				_model.decreaseLoadCounter();	
			}
		}



		override public function fault(event:Object):void {
			_model.decreaseLoadCounter();
			Alert.show(event.error.errorMsg, ResourceManager.getInstance().getString('cms', 'error'));
		}

	}
}
