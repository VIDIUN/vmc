package com.vidiun.vmc.modules.content.model
{
	import com.vidiun.vo.VidiunDropFolder;
	import com.vidiun.vo.VidiunDropFolderFileFilter;
	import com.vidiun.vo.VidiunFilterPager;
	
	import mx.collections.ArrayCollection;

	[Bindable]
	public class DropFolderModel {
		
//		/**
//		 * currently selected drop folder 
//		 */		
//		public var selectedDropFolder:VidiunDropFolder;	
		
		/**
		 * list of DropFolders 
		 */
		public var dropFolders:ArrayCollection;
		
		
		/**
		 * list of files from all drop folders
		 */
		public var files:ArrayCollection;
		
		/**
		 * drop folders files filter
		 * */
		public var filter:VidiunDropFolderFileFilter;

		/**
		 * drop folders files pager
		 * */
		public var pager:VidiunFilterPager;
		
		/**
		 * total amount of drop folder files
		 * */
		public var filesTotalCount:int;
	
	}
}