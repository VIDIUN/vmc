package com.vidiun.edw.control.commands
{
	import com.vidiun.commands.baseEntry.BaseEntryList;
	import com.vidiun.edw.control.events.SearchEvent;
	import com.vidiun.edw.vo.ListableVo;
	import com.vidiun.events.VidiunEvent;
	import com.vidiun.vmvc.control.VMvCEvent;
	import com.vidiun.vo.VidiunBaseEntry;
	import com.vidiun.vo.VidiunBaseEntryFilter;
	import com.vidiun.vo.VidiunBaseEntryListResponse;
	import com.vidiun.vo.VidiunMediaEntry;
	import com.vidiun.vo.VidiunMixEntry;
	
	import mx.collections.ArrayCollection;

	public class ListEntriesCommand extends VedCommand
	{
		private var _caller:ListableVo;
		
		/**
		 * @inheritDoc
		 */		
		override public function execute(event:VMvCEvent):void
		{
			_model.increaseLoadCounter();
			_caller = (event as SearchEvent).listableVo;
			var getMediaList:BaseEntryList = new BaseEntryList(_caller.filterVo as VidiunBaseEntryFilter ,_caller.pagingComponent.vidiunFilterPager );
		 	getMediaList.addEventListener(VidiunEvent.COMPLETE, result);
			getMediaList.addEventListener(VidiunEvent.FAILED, fault);
			_client.post(getMediaList);	  
		}

		/**
		 * @inheritDoc
		 */
		override public function result(data:Object):void
		{
			super.result(data);
			// the following variables are used to force  
			// their types to compile into the application
			var vme:VidiunMediaEntry; 
			var vbe:VidiunBaseEntry;
			var mix:VidiunMixEntry;
			var recivedData:VidiunBaseEntryListResponse = VidiunBaseEntryListResponse(data.data);
			// only use object we can handle
			var tempAr:Array = [];
			for each (var o:Object in recivedData.objects) {
				if (o is VidiunBaseEntry) {
					tempAr.push(o);
				}
			}
			_caller.arrayCollection = new ArrayCollection (tempAr);
			_caller.pagingComponent.totalCount = recivedData.totalCount;
			_model.decreaseLoadCounter();
		}
		
	}
}