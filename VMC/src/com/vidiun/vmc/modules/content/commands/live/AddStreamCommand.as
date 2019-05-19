package com.vidiun.vmc.modules.content.commands.live {
	import com.adobe.cairngorm.control.CairngormEvent;
	import com.vidiun.commands.liveStream.LiveStreamAdd;
	import com.vidiun.edw.control.DataTabController;
	import com.vidiun.edw.control.VedController;
	import com.vidiun.edw.control.events.VedEntryEvent;
	import com.vidiun.edw.control.events.ModelEvent;
	import com.vidiun.edw.control.events.SearchEvent;
	import com.vidiun.events.VidiunEvent;
	import com.vidiun.vmc.modules.content.commands.VidiunCommand;
	import com.vidiun.vmc.modules.content.events.AddStreamEvent;
	import com.vidiun.vmc.modules.content.events.WindowEvent;
	import com.vidiun.vmc.modules.content.vo.StreamVo;
	import com.vidiun.vmvc.control.VMvCEvent;
	import com.vidiun.types.VidiunDVRStatus;
	import com.vidiun.types.VidiunLivePublishStatus;
	import com.vidiun.types.VidiunMediaType;
	import com.vidiun.types.VidiunNullableBoolean;
	import com.vidiun.types.VidiunPlaybackProtocol;
	import com.vidiun.types.VidiunRecordStatus;
	import com.vidiun.types.VidiunSourceType;
	import com.vidiun.vo.VidiunLiveStreamConfiguration;
	import com.vidiun.vo.VidiunLiveStreamEntry;
	
	import mx.controls.Alert;
	import mx.events.CloseEvent;
	import mx.resources.IResourceManager;
	import mx.resources.ResourceManager;

	[ResourceBundle("live")]
	
	public class AddStreamCommand extends VidiunCommand {

		private var _sourceType:String = null;
		
		private var _createdEntryId:String;
		
		
		
		override public function execute(event:CairngormEvent):void {
			var streamVo:StreamVo = (event as AddStreamEvent).streamVo;
			var liveEntry:VidiunLiveStreamEntry = new VidiunLiveStreamEntry();
			liveEntry.mediaType = VidiunMediaType.LIVE_STREAM_FLASH;

			liveEntry.name = streamVo.streamName;
			liveEntry.description = streamVo.description;
			
			if (streamVo.streamType == StreamVo.STREAM_TYPE_UNIVERSAL) {
				setAkamaiUniversalParams(liveEntry, streamVo);
				_sourceType = VidiunSourceType.AKAMAI_UNIVERSAL_LIVE;
			}
			else if (streamVo.streamType == StreamVo.STREAM_TYPE_MANUAL) {
				setManualParams(liveEntry, streamVo);
				_sourceType = VidiunSourceType.MANUAL_LIVE_STREAM;
			}
			else if (streamVo.streamType == StreamVo.STREAM_TYPE_VIDIUN) {
				setVidiunLiveParams(liveEntry, streamVo);
				_sourceType = VidiunSourceType.LIVE_STREAM;
			}
			else if (streamVo.streamType == StreamVo.STREAM_TYPE_MULTICAST) {
				setMulticastParams(liveEntry, streamVo);
				_sourceType = VidiunSourceType.LIVE_STREAM;
			}

			var addEntry:LiveStreamAdd = new LiveStreamAdd(liveEntry, _sourceType);
			addEntry.addEventListener(VidiunEvent.COMPLETE, result);
			addEntry.addEventListener(VidiunEvent.FAILED, fault);
			_model.increaseLoadCounter();
			_model.context.vc.post(addEntry);
		}
		
		
		/**
		 * set parameters relevant to Vidiun multicast live streams 
		 * @param liveEntry	entry to manipulate
		 * @param streamVo	data
		 */
		private function setMulticastParams(liveEntry:VidiunLiveStreamEntry, streamVo:StreamVo):void {
			liveEntry.dvrStatus = VidiunDVRStatus.DISABLED;
			
			// recording
			if (streamVo.recordingEnabled) {
				liveEntry.recordStatus = parseInt(streamVo.recordingType);
				
			}
			else {
				liveEntry.recordStatus = VidiunRecordStatus.DISABLED;
			}
			
			liveEntry.conversionProfileId = streamVo.conversionProfileId;
			
			liveEntry.pushPublishEnabled = VidiunLivePublishStatus.ENABLED; 
		}		
		
		
		/**
		 * set parameters relevant to Vidiun live streams 
		 * @param liveEntry	entry to manipulate
		 * @param streamVo	data
		 */
		private function setVidiunLiveParams(liveEntry:VidiunLiveStreamEntry, streamVo:StreamVo):void {
			// dvr
			if (streamVo.dvrEnabled) {
				liveEntry.dvrStatus = VidiunDVRStatus.ENABLED;
				liveEntry.dvrWindow = 120; // 2 hours, in minutes
			}
			else {
				liveEntry.dvrStatus = VidiunDVRStatus.DISABLED;
			}
			// recording
			if (streamVo.recordingEnabled) {
				liveEntry.recordStatus = parseInt(streamVo.recordingType);
			}
			else {
				liveEntry.recordStatus = VidiunRecordStatus.DISABLED;
			}
			
			liveEntry.conversionProfileId = streamVo.conversionProfileId;
			
			if (streamVo.autoStartStreaming) {
				liveEntry.explicitLive = VidiunNullableBoolean.FALSE_VALUE;
			}
			else {
				liveEntry.explicitLive = VidiunNullableBoolean.TRUE_VALUE;
			}
		}
		
		
		/**
		 * set parameters relevant to manual live streams 
		 * @param liveEntry	entry to manipulate
		 * @param streamVo	data
		 */
		private function setManualParams(liveEntry:VidiunLiveStreamEntry, streamVo:StreamVo):void {
			liveEntry.hlsStreamUrl = streamVo.mobileHLSURL; // legacy, empty value is ok
			liveEntry.liveStreamConfigurations = new Array();
			var cfg:VidiunLiveStreamConfiguration;
			// add config for hls
			if (streamVo.mobileHLSURL) {
				cfg = new VidiunLiveStreamConfiguration();
				cfg.protocol = VidiunPlaybackProtocol.APPLE_HTTP;
				cfg.url = streamVo.mobileHLSURL;
				liveEntry.liveStreamConfigurations.push(cfg);
			}
			// add config for hds
			if (streamVo.flashHDSURL) {
				cfg = new VidiunLiveStreamConfiguration();
				if (streamVo.isAkamaiHds) {
					cfg.protocol = VidiunPlaybackProtocol.AKAMAI_HDS;
				}
				else {
					cfg.protocol = VidiunPlaybackProtocol.HDS;
				}
				cfg.url = streamVo.flashHDSURL;
				liveEntry.liveStreamConfigurations.push(cfg);
			}
		}
		
		
		/**
		 * set parameters relevant to Akamai universal live streams 
		 * @param liveEntry	entry to manipulate
		 * @param streamVo	data
		 */
		private function setAkamaiUniversalParams(liveEntry:VidiunLiveStreamEntry, streamVo:StreamVo):void {
			liveEntry.encodingIP1 = streamVo.primaryIp;
			liveEntry.encodingIP2 = streamVo.secondaryIp;
			
			if (streamVo.dvrEnabled) {
				liveEntry.dvrStatus = VidiunDVRStatus.ENABLED;
				liveEntry.dvrWindow = 30;
			}
			else {
				liveEntry.dvrStatus = VidiunDVRStatus.DISABLED;
			}
			
			if (!streamVo.password)
				liveEntry.streamPassword = "";
			else
				liveEntry.streamPassword = streamVo.password;
		}		
		

		override public function result(data:Object):void {
			super.result(data);
			_createdEntryId = (data.data as VidiunLiveStreamEntry).id;
			var rm:IResourceManager = ResourceManager.getInstance();
			if (_sourceType == VidiunSourceType.MANUAL_LIVE_STREAM) {
				Alert.show(rm.getString('live', 'manualLiveEntryCreatedMessage', [_createdEntryId]), rm.getString('live', 'manualLiveEntryCreatedMessageTitle'));
			}
			else if (_sourceType == VidiunSourceType.LIVE_STREAM) {
				showVidiunLiveCreaetedMessage();
			}
			else {
				Alert.show(rm.getString('live', 'liveEntryTimeMessage'), rm.getString('live', 'liveEntryTimeMessageTitle'));
			}
			
			_model.decreaseLoadCounter();

			var cgEvent:WindowEvent = new WindowEvent(WindowEvent.CLOSE);
			cgEvent.dispatch();

			var searchEvent2:SearchEvent = new SearchEvent(SearchEvent.SEARCH_ENTRIES, _model.listableVo);
			VedController.getInstance().dispatch(searchEvent2);
		}
		
		
		private function showVidiunLiveCreaetedMessage():void {
			var rm:IResourceManager = ResourceManager.getInstance();
			Alert.show(rm.getString('live', 'vidiunLiveEntryCreatedMessage'), rm.getString('live', 'liveEntryTimeMessageTitle'), Alert.YES|Alert.NO, null, gotoEntry);
		}
		
		private function gotoEntry(event:CloseEvent):void {
			if (event.detail == Alert.YES) {
				var cg:VMvCEvent = new ModelEvent(ModelEvent.DUPLICATE_ENTRY_DETAILS_MODEL);
				DataTabController.getInstance().dispatch(cg);
				cg = new VedEntryEvent(VedEntryEvent.GET_ENTRY_AND_DRILLDOWN, null, _createdEntryId);
				DataTabController.getInstance().dispatch(cg);
			}
		}
	}
}
