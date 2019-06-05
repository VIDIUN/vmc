package com.vidiun.edw.control.commands.categories
{
	import com.vidiun.edw.control.commands.VedCommand;
	import com.vidiun.edw.model.FilterModel;
	import com.vidiun.edw.model.datapacks.FilterDataPack;
	import com.vidiun.vmvc.control.VMvCEvent;
	
	public class FlushCategoriesDataCommand extends VedCommand {
		
		override public function execute(event:VMvCEvent):void {
			var filterModel:FilterModel = (_model.getDataPack(FilterDataPack) as FilterDataPack).filterModel;
			filterModel.categoriesMapForEntries.clear();
			filterModel.categoriesForEntries = null;
			
			filterModel.categoriesMapForMod.clear();
			filterModel.categoriesForMod = null;
			
			filterModel.categoriesMapForCats.clear();
			filterModel.categoriesForCats = null;
			
			filterModel.categoriesMapGeneral.clear();
			filterModel.categoriesGeneral = null;
		}
	}
}