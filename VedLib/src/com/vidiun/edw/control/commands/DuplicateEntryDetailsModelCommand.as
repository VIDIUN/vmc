package com.vidiun.edw.control.commands
{
	import com.vidiun.edw.control.commands.VedCommand;
	import com.vidiun.edw.model.EntryDetailsModel;
	import com.vidiun.edw.model.datapacks.EntryDataPack;
	import com.vidiun.vmvc.control.VMvCEvent;
	import com.vidiun.vmvc.model.VMvCModel;

	public class DuplicateEntryDetailsModelCommand extends VedCommand {
		
		override public function execute(event:VMvCEvent):void
		{
			// need to copy maxCats because entry data pack is not shared.
			var maxCats:int = (VMvCModel.getInstance().getDataPack(EntryDataPack) as EntryDataPack).maxNumCategories;
			VMvCModel.addModel();
			(VMvCModel.getInstance().getDataPack(EntryDataPack) as EntryDataPack).maxNumCategories = maxCats;
		}
	}
}