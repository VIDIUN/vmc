package com.vidiun.vmc.modules.content.commands.bulk
{
	import com.adobe.cairngorm.control.CairngormEvent;
	import com.vidiun.commands.bulkUpload.BulkUploadAbort;
	import com.vidiun.events.VidiunEvent;
	import com.vidiun.vmc.modules.content.commands.VidiunCommand;
	import com.vidiun.vmc.modules.content.events.BulkEvent;
	import com.vidiun.vo.VidiunBulkUpload;
	
	public class DeleteBulkUploadCommand extends VidiunCommand {
		
		override public function execute(event:CairngormEvent):void
		{
			_model.increaseLoadCounter();
			var vbu:BulkUploadAbort = new BulkUploadAbort(event.data);
			vbu.addEventListener(VidiunEvent.COMPLETE, result);
			vbu.addEventListener(VidiunEvent.FAILED, fault);
			_model.context.vc.post(vbu);
		}
		
		override public function result( data : Object ) : void
		{
			super.result(data);
			var temp:VidiunBulkUpload;
//			var bulkEvent : BulkEvent = new BulkEvent( BulkEvent.LIST_BULK_UPLOAD );
//			bulkEvent.dispatch();
			_model.decreaseLoadCounter();
		}
	}
}