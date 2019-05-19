package com.vidiun.vmc.modules.content.commands
{
	import com.adobe.cairngorm.commands.ICommand;
	import com.adobe.cairngorm.control.CairngormEvent;
	import com.vidiun.vmc.modules.content.events.ExternalSyndicationEvent;
	import com.vidiun.commands.syndicationFeed.SyndicationFeedUpdate;
	import com.vidiun.events.VidiunEvent;
	import com.vidiun.vo.VidiunBaseSyndicationFeed;
	
	import mx.rpc.IResponder;
	
	public class UpdateExternalSyndicationCommand extends VidiunCommand implements ICommand, IResponder
	{
		override public function execute(event:CairngormEvent):void
		{
			_model.increaseLoadCounter();
			var feed:VidiunBaseSyndicationFeed = event.data as VidiunBaseSyndicationFeed;
			var id:String = feed.id;
//			feed.id = null;
//			feed.type = "";
//			feed.feedUrl = null;
//			feed.partnerId = int.MIN_VALUE;
//			feed.status = int.MIN_VALUE;
//			feed.createdAt = int.MIN_VALUE;
			feed.setUpdatedFieldsOnly(true);
		
		 	var updateFeed:SyndicationFeedUpdate = new SyndicationFeedUpdate(id, feed);
		 	updateFeed.addEventListener(VidiunEvent.COMPLETE, result);
			updateFeed.addEventListener(VidiunEvent.FAILED, fault);
			_model.context.vc.post(updateFeed);	   
		}

		override public function result(data:Object):void
		{
			_model.decreaseLoadCounter();
			var feedListEvent:ExternalSyndicationEvent = new ExternalSyndicationEvent(ExternalSyndicationEvent.LIST_EXTERNAL_SYNDICATIONS);
			feedListEvent.dispatch();
		}

	}
}