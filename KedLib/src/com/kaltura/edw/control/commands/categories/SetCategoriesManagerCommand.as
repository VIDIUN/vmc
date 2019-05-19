package com.vidiun.edw.control.commands.categories
{
	import com.vidiun.edw.components.fltr.cat.data.ICategoriesDataManger;
	import com.vidiun.edw.control.commands.VedCommand;
	import com.vidiun.edw.model.FilterModel;
	import com.vidiun.edw.model.datapacks.FilterDataPack;
	import com.vidiun.vmvc.control.VMvCEvent;

	public class SetCategoriesManagerCommand extends VedCommand {
		
		override public function execute(event:VMvCEvent):void
		{
			var filterModel:FilterModel = (_model.getDataPack(FilterDataPack) as FilterDataPack).filterModel;
			filterModel.catTreeDataManager = event.data as ICategoriesDataManger;
		}
	}
}