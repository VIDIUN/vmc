package com.vidiun.vmc.modules.content.commands {
	import com.adobe.cairngorm.control.CairngormEvent;
	import com.vidiun.commands.playlist.PlaylistExecute;
	import com.vidiun.edw.control.events.VedEntryEvent;
	import com.vidiun.events.VidiunEvent;
	import com.vidiun.vmc.modules.content.events.VMCEntryEvent;
	import com.vidiun.vo.VidiunPlaylist;

	public class GetPlaylistCommand extends VidiunCommand {
		private var _currentPlaylist:VidiunPlaylist;


		override public function execute(event:CairngormEvent):void {
			_model.increaseLoadCounter();
			var e:VMCEntryEvent = event as VMCEntryEvent;
			_currentPlaylist = e.entryVo as VidiunPlaylist;
			var playlistGet:PlaylistExecute = new PlaylistExecute(_currentPlaylist.id);
			playlistGet.addEventListener(VidiunEvent.COMPLETE, result);
			playlistGet.addEventListener(VidiunEvent.FAILED, fault);
			_model.context.vc.post(playlistGet);
		}


		override public function result(data:Object):void {
			super.result(data);
			_model.decreaseLoadCounter();
			if (data.data is Array) {
				//this is not a nice implementation :( todo - fix this
				_currentPlaylist.parts.source = data.data;
				_currentPlaylist.parts = null;
			}
		}
	}
}