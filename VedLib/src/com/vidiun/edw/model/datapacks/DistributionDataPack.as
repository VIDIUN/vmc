package com.vidiun.edw.model.datapacks
{
	import com.vidiun.edw.control.events.VedEntryEvent;
	import com.vidiun.edw.control.events.ThumbnailAssetEvent;
	import com.vidiun.edw.vo.DistributionInfo;
	import com.vidiun.events.FileUploadEvent;
	import com.vidiun.vmvc.control.VMvCController;
	import com.vidiun.vmvc.model.IDataPack;
	import com.vidiun.managers.FileUploadManager;
	import com.vidiun.types.VidiunMediaType;
	import com.vidiun.vo.VidiunBaseEntry;
	import com.vidiun.vo.VidiunMediaEntry;
	import com.vidiun.vo.VidiunMixEntry;
	
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	import mx.collections.ArrayCollection;
	
	[Bindable]
	/**
	 * information required for distribution of the current entry
	 * */
	public class DistributionDataPack implements IDataPack {
		
		public var shared:Boolean = false;
		
		/**
		 * contains all info regarding distribution profiles: distribution profiles and thumbnails 
		 */		
		public var distributionInfo:DistributionInfo = new DistributionInfo();
		
		
		/**
		 * FlavorAssetWithParamsVO objects 
		 * used for entry drilldown > flavors, distribution
		 */		
		public var flavorParamsAndAssetsByEntryId:ArrayCollection = new ArrayCollection();
		
		/**
		 * Indicates whether flavors were loaded 
		 * used in DistributionDetailsWindow
		 * */
		public var flavorsLoaded:Boolean = false;
		
		/**
		 * Holds a reference to the current entry to check whether it changed or not when loadThumbs is called. 
		 */		
		private var _thumbRequestorEntry:VidiunBaseEntry;
		
		/**
		 * Holds a reference to the current entry to check whether it changed or not when loadFlavors is called. 
		 */		
		private var _flavorRequestorEntry:VidiunBaseEntry;
		
		private var _flavorController:VMvCController;
		
		private var _listenToUpload:Boolean = false;
		private var _refreshOnce:Boolean = false;
		private var _timeoutTimer:Timer = new Timer(5,1);
		
		public function loadThumbs(controller:VMvCController, currEntry:VidiunBaseEntry):void{
			if (_thumbRequestorEntry != currEntry){
				_thumbRequestorEntry = currEntry;
				var listThumbs:ThumbnailAssetEvent = new ThumbnailAssetEvent(ThumbnailAssetEvent.LIST);
				controller.dispatch(listThumbs);
			}
		}
		
		public function loadFlavors(controller:VMvCController, currEntry:VidiunBaseEntry):void{
			if (_flavorRequestorEntry != currEntry){
				_flavorRequestorEntry = currEntry;
				_flavorController = controller;
				if (!_listenToUpload) {
					FileUploadManager.getInstance().addEventListener(FileUploadEvent.UPLOAD_STARTED, onFlavorsChanged);
					_listenToUpload = true;
				}
				
				refreshFlavors();
			}
		}
		
		public function clearFlavorUpdates():void{
			if (_listenToUpload){
				FileUploadManager.getInstance().removeEventListener(FileUploadEvent.UPLOAD_STARTED, onFlavorsChanged);
				_listenToUpload = false;
			}
		}
		
		/**
		 * since refreshFlavors is triggered by both set status and set replacementStatus on FlavorsTab,
		 * we get a redundant call if both change. this function removes one call.
		 * */
		public function refreshFlavors():void{
			if (!_timeoutTimer.running && _flavorRequestorEntry) {
				_timeoutTimer.addEventListener(TimerEvent.TIMER_COMPLETE, refreshOnce);
				_timeoutTimer.start();
			}
		}
		
		private function refreshOnce(event:TimerEvent):void {
			_timeoutTimer.removeEventListener(TimerEvent.TIMER_COMPLETE, refreshOnce);
			_timeoutTimer.reset();
			refreshData(false);
		}
		
		private function refreshData(refreshEntry:Boolean):void {
			if (_flavorRequestorEntry != null) {
				var cgEvent:VedEntryEvent = new VedEntryEvent(VedEntryEvent.GET_FLAVOR_ASSETS, _flavorRequestorEntry);
				_flavorController.dispatch(cgEvent);
				if (refreshEntry) {
					cgEvent = new VedEntryEvent(VedEntryEvent.UPDATE_SELECTED_ENTRY_REPLACEMENT_STATUS, null, _flavorRequestorEntry.id);
					_flavorController.dispatch(cgEvent);
				}
				
			}
		}
		
		
		private function onFlavorsChanged(event:Event):void {
			refreshData(true);
		}
	}
}