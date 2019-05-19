package com.vidiun.vmc.modules.content.commands.bulk {
	import com.adobe.cairngorm.control.CairngormEvent;
	import com.vidiun.commands.bulk.BulkList;
	import com.vidiun.events.VidiunEvent;
	import com.vidiun.vmc.modules.content.commands.VidiunCommand;
	import com.vidiun.vo.VidiunBulkUploadFilter;
	import com.vidiun.vo.VidiunBulkUploadListResponse;
	import com.vidiun.vo.VidiunBulkUploadResult;
	import com.vidiun.vo.VidiunFilterPager;
	
	import mx.collections.ArrayCollection;

	public class ListBulkUploadCommand extends VidiunCommand {
		override public function execute(event:CairngormEvent):void {
			_model.increaseLoadCounter();
			
			var f:VidiunBulkUploadFilter;
			var p:VidiunFilterPager;
			
			if (event.data) {
				// use given and save
				_model.bulkUploadModel.lastFilterUsed = f = event.data[0] as VidiunBulkUploadFilter;
				_model.bulkUploadModel.lastPagerUsed = p = event.data[1] as VidiunFilterPager;
			}
			else {
				// use saved
				f = _model.bulkUploadModel.lastFilterUsed;
				p = _model.bulkUploadModel.lastPagerUsed;
			}
			
			
			var listBulks:BulkList = new BulkList(f, p);
			listBulks.addEventListener(VidiunEvent.COMPLETE, result);
			listBulks.addEventListener(VidiunEvent.FAILED, fault);
			_model.context.vc.post(listBulks);

		}


		override public function result(data:Object):void {
			super.result(data);
			var vbr:VidiunBulkUploadResult;
			_model.bulkUploadModel.bulkUploadTotalCount = data.data.totalCount;

			_model.bulkUploadModel.bulkUploads = new ArrayCollection((data.data as VidiunBulkUploadListResponse).objects);
			_model.decreaseLoadCounter();
		}

	}
}