package com.vidiun.vmc.modules.content.commands
{
	import com.adobe.cairngorm.commands.ICommand;
	import com.adobe.cairngorm.control.CairngormEvent;
	import com.vidiun.analytics.GoogleAnalyticsConsts;
	import com.vidiun.analytics.GoogleAnalyticsTracker;
	import com.vidiun.analytics.VAnalyticsTracker;
	import com.vidiun.analytics.VAnalyticsTrackerConsts;
	import com.vidiun.commands.MultiRequest;
	import com.vidiun.commands.baseEntry.BaseEntryApprove;
	import com.vidiun.commands.baseEntry.BaseEntryReject;
	import com.vidiun.edw.control.events.SearchEvent;
	import com.vidiun.events.VidiunEvent;
	import com.vidiun.edw.control.VedController;
	import com.vidiun.vmc.modules.content.events.CategoryEvent;
	import com.vidiun.vmc.modules.content.events.ModerationsEvent;
	import com.vidiun.types.VidiunStatsVmcEventType;
	import com.vidiun.vo.VidiunBaseEntry;
	
	import mx.controls.Alert;
	import mx.resources.ResourceManager;
	import mx.rpc.IResponder;
    
   
    
	public class UpdateEntryModerationCommand extends VidiunCommand implements ICommand, IResponder
	{
		private var moderationType:int;
		 
		override public function execute(event:CairngormEvent):void
		{
			var entriesToUpdate:Array = (event as ModerationsEvent).entries;
		    moderationType = (event as ModerationsEvent).moderationType;
			
			var mr:MultiRequest = new MultiRequest();
			var i:uint;
			if (moderationType == ModerationsEvent.APPROVE) {
				// approve
				for(i=0; i<entriesToUpdate.length;i++)
				{
	        		var aproveEntry:BaseEntryApprove = new BaseEntryApprove((entriesToUpdate[i] as VidiunBaseEntry).id);
					mr.addAction(aproveEntry);
				}
			}
			else if (moderationType == ModerationsEvent.REJECT) {
				// reject
				for( i = 0; i<entriesToUpdate.length;i++)
				{
	        		var reject:BaseEntryReject = new BaseEntryReject((entriesToUpdate[i] as VidiunBaseEntry).id);
					mr.addAction(reject);
				}
			}
			
			
			// reset the array
			_model.moderationModel.moderationsArray.source = [];
			
			mr.addEventListener(VidiunEvent.COMPLETE,result);
			mr.addEventListener(VidiunEvent.FAILED,fault);

			_model.increaseLoadCounter();
			_model.context.vc.post(mr);
			
		}
			

		
		override public function result(data:Object):void
		{
			super.result(data);
			_model.decreaseLoadCounter();
			var searchEvent : SearchEvent = new SearchEvent(SearchEvent.SEARCH_ENTRIES , _model.listableVo  );
			VedController.getInstance().dispatch(searchEvent);
			

			//dispatching - single dispatch for each entry
			if(moderationType)
			{
				switch(moderationType){
					case (1):
					for each (var baseEntryApprove:BaseEntryApprove in data.currentTarget.actions )
					{
						GoogleAnalyticsTracker.getInstance().sendToGA(GoogleAnalyticsConsts.CONTENT_APPROVE_MODERATION, GoogleAnalyticsConsts.CONTENT);
				        VAnalyticsTracker.getInstance().sendEvent(VAnalyticsTrackerConsts.CONTENT,VidiunStatsVmcEventType.CONTENT_APPROVE_MODERATION,
																  "Moderation>ApproveSelected");
					}
					break;
					case(2):
					for each (var baseEntryReject:BaseEntryReject in data.currentTarget.actions )
					{
				    	GoogleAnalyticsTracker.getInstance().sendToGA(GoogleAnalyticsConsts.CONTENT_REJECT_MODERATION, GoogleAnalyticsConsts.CONTENT);
						VAnalyticsTracker.getInstance().sendEvent(VAnalyticsTrackerConsts.CONTENT,VidiunStatsVmcEventType.CONTENT_REJECT_MODERATION,
															  "Moderation>RejectSelected");
					}
					break;
				}
			}
		}
	}
}	
