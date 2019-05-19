package com.vidiun.edw.model.datapacks
{
	import com.vidiun.vmvc.model.IDataPack;
	import com.vidiun.vo.VidiunDropFolder;
	
	import mx.collections.ArrayCollection;
	
	[Bindable]
	public class DropFolderDataPack implements IDataPack {
		
		public var shared:Boolean = false;
		
		/**
		 * currently selected drop folder 
		 */		
		public var selectedDropFolder:VidiunDropFolder;
		
		/**
		 * list of DropFolders 
		 */
		public var dropFolders:ArrayCollection;
		
		/**
		 * list of files in the selected DropFolder
		 */
		public var dropFolderFiles:ArrayCollection;
	}
}