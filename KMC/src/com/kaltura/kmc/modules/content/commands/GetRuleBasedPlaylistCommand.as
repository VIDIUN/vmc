package com.vidiun.vmc.modules.content.commands
{
	import com.adobe.cairngorm.commands.ICommand;
	import com.adobe.cairngorm.control.CairngormEvent;
	import com.vidiun.vmc.modules.content.events.RuleBasedTypeEvent;
	import com.vidiun.commands.playlist.PlaylistExecuteFromFilters;
	import com.vidiun.events.VidiunEvent;
	import com.vidiun.utils.VTimeUtil;
	import com.vidiun.vo.VidiunPlaylist;
	
	import mx.rpc.IResponder;
	import com.vidiun.vmc.modules.content.events.VMCEntryEvent;

	public class GetRuleBasedPlaylistCommand extends VidiunCommand implements ICommand, IResponder
	{
		private var _currentPlaylist : VidiunPlaylist;
		
		override public function execute(event:CairngormEvent):void
		{	
			_model.increaseLoadCounter();
 			var e : VMCEntryEvent = event as VMCEntryEvent;
			_currentPlaylist = e.entryVo as VidiunPlaylist;
			if(_currentPlaylist.totalResults == int.MIN_VALUE)
				_currentPlaylist.totalResults = 50; // Ariel definition - up to 50 per playlist 
			var playlistGet:PlaylistExecuteFromFilters = new PlaylistExecuteFromFilters(_currentPlaylist.filters,_currentPlaylist.totalResults);
			playlistGet.addEventListener(VidiunEvent.COMPLETE, result);
			playlistGet.addEventListener(VidiunEvent.FAILED, fault);
			_model.context.vc.post(playlistGet);
		}
		
		override public function result(data:Object):void
		{
			super.result(data);
			_model.decreaseLoadCounter();
			//if this is a playlist - and not one rule - update duration and amount of entries
			if (_model.playlistModel.rulePlaylistType == RuleBasedTypeEvent.MULTY_RULES) {
				var totalDuration:Number = 0;
				var nEntries:uint;
				if (data.data is Array && (data.data as Array).length > 0) {
					var l:int = data.data.length; 
					for (nEntries=0; nEntries<l; nEntries++) {
						if(data.data[nEntries].hasOwnProperty("duration"))
							totalDuration += data.data[nEntries]["duration"];	
					}
				}
				_model.playlistModel.ruleBasedDuration = VTimeUtil.formatTime2(totalDuration);
				_model.playlistModel.ruleBasedEntriesAmount = nEntries;
			}
			
 			if(data.data is Array && _currentPlaylist.parts) {
				//TODO this is not a nice implementation :( 
				_currentPlaylist.parts.source = data.data;
				_currentPlaylist.parts = null;
				// sum all entries duration 
				_currentPlaylist = null;
			} 
		}
	}
}