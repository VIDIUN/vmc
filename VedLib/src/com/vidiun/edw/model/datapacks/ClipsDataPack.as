package com.vidiun.edw.model.datapacks
{
	import com.vidiun.vmvc.model.IDataPack;
	
	[Bindable]
	/**
	 * information about clips created from the current entry
	 * */
	public class ClipsDataPack implements IDataPack {
		
		public var shared:Boolean = false;
		
		/**
		 * clips derived from the current entry, 
		 * <code>VidiunBaseEntry</code> objects
		 */		
		public var clips:Array;
	}
}