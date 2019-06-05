package com.vidiun.vmc.modules.content.commands {
	import com.adobe.cairngorm.control.CairngormEvent;
	import com.vidiun.analytics.GoogleAnalyticsConsts;
	import com.vidiun.analytics.GoogleAnalyticsTracker;
	import com.vidiun.analytics.VAnalyticsTracker;
	import com.vidiun.analytics.VAnalyticsTrackerConsts;
	import com.vidiun.commands.playlist.PlaylistAdd;
	import com.vidiun.events.VidiunEvent;
	import com.vidiun.vmc.modules.content.events.VMCSearchEvent;
	import com.vidiun.vmc.modules.content.events.WindowEvent;
	import com.vidiun.types.VidiunPlaylistType;
	import com.vidiun.types.VidiunStatsVmcEventType;
	import com.vidiun.utils.SoManager;
	import com.vidiun.vo.VidiunPlaylist;
	import com.vidiun.vo.VidiunPlaylistFilter;
	import com.vidiun.vmc.modules.content.events.VMCEntryEvent;

	public class AddEntryCommand extends VidiunCommand {
		private var _playListType:Number;


		override public function execute(event:CairngormEvent):void {
			_model.increaseLoadCounter();
			var e:VMCEntryEvent = event as VMCEntryEvent;
			var addplaylist:PlaylistAdd = new PlaylistAdd(e.entryVo as VidiunPlaylist);
			addplaylist.addEventListener(VidiunEvent.COMPLETE, result);
			addplaylist.addEventListener(VidiunEvent.FAILED, fault);
			_model.context.vc.post(addplaylist);
			_playListType = e.entryVo.playlistType;
			//first time funnel
			if (!SoManager.getInstance().checkOrFlush(GoogleAnalyticsConsts.CONTENT_FIRST_TIME_PLAYLIST_CREATION))
				GoogleAnalyticsTracker.getInstance().sendToGA(GoogleAnalyticsConsts.CONTENT_FIRST_TIME_PLAYLIST_CREATION, GoogleAnalyticsConsts.CONTENT);
		}


		override public function result(data:Object):void {
			super.result(data);
			_model.decreaseLoadCounter();
			if (_model.listableVo.filterVo is VidiunPlaylistFilter) {
				var searchEvent:VMCSearchEvent = new VMCSearchEvent(VMCSearchEvent.SEARCH_PLAYLIST, _model.listableVo);
				searchEvent.dispatch();
			}
			var cgEvent:WindowEvent = new WindowEvent(WindowEvent.CLOSE);
			cgEvent.dispatch();

			if (_playListType == VidiunPlaylistType.DYNAMIC) {
				VAnalyticsTracker.getInstance().sendEvent(VAnalyticsTrackerConsts.CONTENT, VidiunStatsVmcEventType.CONTENT_ADD_PLAYLIST, "RuleBasedPlayList>AddPlayList" + ">" + data.data.id);
				GoogleAnalyticsTracker.getInstance().sendToGA(GoogleAnalyticsConsts.CONTENT_ADD_RULEBASED_PLAYLIST, GoogleAnalyticsConsts.CONTENT);
			}
			else if (_playListType == VidiunPlaylistType.STATIC_LIST) {
				VAnalyticsTracker.getInstance().sendEvent(VAnalyticsTrackerConsts.CONTENT, VidiunStatsVmcEventType.CONTENT_ADD_PLAYLIST, "ManuallPlayList>AddPlayList" + ">" + data.data.id);
				GoogleAnalyticsTracker.getInstance().sendToGA(GoogleAnalyticsConsts.CONTENT_ADD_PLAYLIST, GoogleAnalyticsConsts.CONTENT);
			}

		}
	}
}