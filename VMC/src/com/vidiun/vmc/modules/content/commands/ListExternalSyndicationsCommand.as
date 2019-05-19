package com.vidiun.vmc.modules.content.commands
{
	import com.adobe.cairngorm.commands.ICommand;
	import com.adobe.cairngorm.control.CairngormEvent;
	import com.vidiun.commands.syndicationFeed.SyndicationFeedList;
	import com.vidiun.events.VidiunEvent;
	import com.vidiun.vmc.modules.content.vo.ExternalSyndicationVO;
	import com.vidiun.vo.VidiunBaseSyndicationFeed;
	import com.vidiun.vo.VidiunBaseSyndicationFeedListResponse;
	import com.vidiun.vo.VidiunFilterPager;
	import com.vidiun.vo.VidiunGenericSyndicationFeed;
	import com.vidiun.vo.VidiunGenericXsltSyndicationFeed;
	
	import mx.collections.ArrayCollection;
	import mx.controls.Alert;
	import mx.resources.ResourceManager;
	import mx.rpc.IResponder;
	
	public class ListExternalSyndicationsCommand extends VidiunCommand implements ICommand, IResponder
	{

		override public function execute(event:CairngormEvent):void
		{
			_model.increaseLoadCounter();
			var vfp:VidiunFilterPager = _model.extSynModel.syndicationFeedsFilterPager;
			if (event.data is VidiunFilterPager) {
				vfp = event.data;
			}
			var listFeeds:SyndicationFeedList = new SyndicationFeedList(_model.extSynModel.syndicationFeedsFilter, vfp);
		 	listFeeds.addEventListener(VidiunEvent.COMPLETE, result);
			listFeeds.addEventListener(VidiunEvent.FAILED, fault);
			_model.context.vc.post(listFeeds);	  
		}
		
		override public function result(event:Object):void
		{
			super.result(event);
			_model.decreaseLoadCounter();
			var tempArr:ArrayCollection = new ArrayCollection();
			_model.extSynModel.externalSyndications.removeAll();
			var response:VidiunBaseSyndicationFeedListResponse = event.data as VidiunBaseSyndicationFeedListResponse;
			_model.extSynModel.externalSyndicationFeedsTotalCount = response.totalCount;
			
			for each(var feed:Object in response.objects)
			{
				if (feed is VidiunBaseSyndicationFeed) {
					if (feed is VidiunGenericSyndicationFeed && !(feed is VidiunGenericXsltSyndicationFeed)) {
						// in VMC we only support the xslt generic type 
						continue;
					}
					var exSyn:ExternalSyndicationVO = new ExternalSyndicationVO();
					exSyn.vSyndicationFeed = feed as VidiunBaseSyndicationFeed;
					exSyn.id = feed.id;
					tempArr.addItem(exSyn);
				}
			}
			_model.extSynModel.externalSyndications = tempArr;
		}
	}
}