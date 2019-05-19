package com.vidiun.edw.model.datapacks
{
	import com.vidiun.edw.model.FilterModel;
	import com.vidiun.vmvc.model.IDataPack;
	
	[Bindable]
	/**
	 * gateway to access the filter model of VMC
	 * */
	public class FilterDataPack implements IDataPack {
		
		public var shared:Boolean = true;
		
		public var filterModel:FilterModel;
	}
}