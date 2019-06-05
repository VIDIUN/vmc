package com.vidiun.vmc.modules.content.commands
{
	import com.adobe.cairngorm.commands.ICommand;
	import com.adobe.cairngorm.control.CairngormEvent;
	import com.vidiun.vmc.modules.content.events.ExternalSyndicationEvent;
	import com.vidiun.commands.MultiRequest;
	import com.vidiun.commands.syndicationFeed.SyndicationFeedDelete;
	import com.vidiun.events.VidiunEvent;
	
	import mx.controls.Alert;
	import mx.resources.ResourceManager;
	import mx.rpc.IResponder;
	
	public class DeleteExternalSyndicationCommand extends VidiunCommand implements ICommand, IResponder
	{
			
		override public function execute(event:CairngormEvent):void
		{
			_model.increaseLoadCounter();
		 	var mr:MultiRequest = new MultiRequest();
			for each (var id:String in event.data)
			{
				var deleteFeed:SyndicationFeedDelete = new SyndicationFeedDelete(id);
				mr.addAction(deleteFeed);
			}
					
            mr.addEventListener(VidiunEvent.COMPLETE, result);
            mr.addEventListener(VidiunEvent.FAILED, fault);
            _model.context.vc.post(mr); 
		}
		
		override public function result(data:Object):void
		{
			super.result(data);
			_model.decreaseLoadCounter();
			Alert.show(ResourceManager.getInstance().getString('cms', 'feedDeleteDoneMsg'));
			var getFeedsList:ExternalSyndicationEvent = new ExternalSyndicationEvent(ExternalSyndicationEvent.LIST_EXTERNAL_SYNDICATIONS);
			getFeedsList.dispatch();
		}
		
		
		

	}
}