package com.vidiun.edw.model.datapacks
{
	import com.vidiun.vmvc.model.IDataPack;
	
	[Bindable]
	/**
	 * information about different user / partner permissions 
	 * @author Atar
	 */	
	public class PermissionsDataPack implements IDataPack {
		
		public var shared:Boolean = true;
		
		/**
		 * R&P: whether to enable custom data update
		 */		
		public var enableUpdateMetadata:Boolean = true;
		
		/**
		 * R&P: whether partner has remote storage feature
		 */		
		public var remoteStorageEnabled:Boolean = true;
		
		/**
		 * R&P: for image entries, add size params when requesting image
		 * (for accounts who use remote storage, then images don't use vidiun service)
		 * */
		public var enableThumbResize:Boolean = false;
		
		/**
		 * RnP: show clipping button in EDW
		 * */
		public var allowClipping:Boolean = true;
		
		/**
		 * RnP: show trimming button in EDW
		 * */
		public var allowTrimming:Boolean = true;
		
		/**
		 * RnP: provision Akamai live streams
		 * */
		public var enableAkamaiLive:Boolean = true;
		
		/**
		 * RnP: provision Vidiun live streams
		 * */
		public var enableVidiunLive:Boolean = true;
		
		/**
		 * RnP: by default record Vidiun live streams
		 * */
		public var enableVidiunRecording:Boolean = true;
		
		/**
		 * RnP: create Vidiun multicast live streams
		 * */
		public var enableVidiunMulticast:Boolean = true;
		
	}
}