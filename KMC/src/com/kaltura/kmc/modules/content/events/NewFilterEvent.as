package com.vidiun.vmc.modules.content.events
{
	import com.vidiun.vo.VidiunMediaEntryFilterForPlaylist;
	
	import flash.events.Event;

	public class NewFilterEvent extends Event
	{
		static public const NEW_PLAYLIST_FILTER:String = "content_newPlaylistFilter";
		static public const EMPTY_PLAYLIST_FILTER:String = "content_emptyPlaylistFilter";
		
		private var _ruleVo:VidiunMediaEntryFilterForPlaylist;
		
		public function NewFilterEvent(type:String,playlistFilterVo:VidiunMediaEntryFilterForPlaylist, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
			_ruleVo = playlistFilterVo;
		}
		
		public function get ruleVo():VidiunMediaEntryFilterForPlaylist
		{
			return _ruleVo;
		}
		
		/**
		 * @inheritDoc 
		 */		
		override public function clone():Event {
			return new NewFilterEvent(type, _ruleVo, bubbles, cancelable);
		}

	}
}