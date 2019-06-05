package com.vidiun.vmc.modules.content.commands
{
	import com.adobe.cairngorm.commands.ICommand;
	import com.adobe.cairngorm.control.CairngormEvent;
	import com.vidiun.commands.MultiRequest;
	import com.vidiun.commands.syndicationFeed.SyndicationFeedAdd;
	import com.vidiun.commands.syndicationFeed.SyndicationFeedGetEntryCount;
	import com.vidiun.errors.VidiunError;
	import com.vidiun.events.VidiunEvent;
	import com.vidiun.vmc.modules.content.events.ExternalSyndicationEvent;
	import com.vidiun.vmc.modules.content.view.window.externalsyndication.popupwindows.ExternalSyndicationNotificationPopUpWindow;
	import com.vidiun.vo.VidiunBaseSyndicationFeed;
	import com.vidiun.vo.VidiunGenericXsltSyndicationFeed;
	import com.vidiun.vo.VidiunSyndicationFeedEntryCount;
	
	import flash.display.DisplayObject;
	
	import mx.controls.Alert;
	import mx.core.Application;
	import mx.managers.PopUpManager;
	import mx.resources.ResourceManager;
	import mx.rpc.IResponder;
	
	public class AddNewExternalSyndicationCommand extends VidiunCommand implements ICommand, IResponder
	{
		override public function execute(event:CairngormEvent):void
		{
			_model.increaseLoadCounter();
			
			var mr:MultiRequest = new MultiRequest();
			var newFeed:VidiunBaseSyndicationFeed = event.data as VidiunBaseSyndicationFeed;
		 	var addNewFeed:SyndicationFeedAdd = new SyndicationFeedAdd(newFeed);
		 	mr.addAction(addNewFeed);
		 	
		 	var countersAction:SyndicationFeedGetEntryCount = new SyndicationFeedGetEntryCount("{1:result:id}");
		 	mr.addAction(countersAction);
		 	
		 	mr.addEventListener(VidiunEvent.COMPLETE, result);
			mr.addEventListener(VidiunEvent.FAILED, fault);
			_model.context.vc.post(mr);	   
		}
		
		override public function result(data:Object):void
		{
			super.result(data);
			if (data.data[0] is VidiunBaseSyndicationFeed) 
			{
				if (!(data.data[0] is VidiunGenericXsltSyndicationFeed)) {	
					var extFeedPopUp:ExternalSyndicationNotificationPopUpWindow = new ExternalSyndicationNotificationPopUpWindow();
					extFeedPopUp.partnerData = _model.extSynModel.partnerData;
					extFeedPopUp.rootUrl = _model.context.rootUrl;
					extFeedPopUp.flavorParams = _model.filterModel.flavorParams;
		   			extFeedPopUp.feed = data.data[0] as VidiunBaseSyndicationFeed;
		   			extFeedPopUp.feedCountersData = data.data[1] as VidiunSyndicationFeedEntryCount;
					PopUpManager.addPopUp(extFeedPopUp, Application.application as DisplayObject, true);
					PopUpManager.centerPopUp(extFeedPopUp);
				} 
			}
			else if (data.data[0].error) {
				Alert.show(data.data[0].error.message, ResourceManager.getInstance().getString('cms','error'));
			}
			
			_model.decreaseLoadCounter();
			var getFeedsList:ExternalSyndicationEvent = new ExternalSyndicationEvent(ExternalSyndicationEvent.LIST_EXTERNAL_SYNDICATIONS);
			getFeedsList.dispatch();	
		}


	}
}