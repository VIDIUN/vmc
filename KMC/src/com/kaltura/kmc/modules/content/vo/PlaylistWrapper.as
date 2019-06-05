package com.vidiun.vmc.modules.content.vo
{
	import com.vidiun.vo.VidiunPlaylist;
	
	import mx.collections.ArrayCollection;
	
	public class PlaylistWrapper extends Object
	{
		
	[Bindable]
	public var playlist:VidiunPlaylist;
	[Bindable]
	public var parts:ArrayCollection;
	
		public function PlaylistWrapper(playlist:VidiunPlaylist= null,part:ArrayCollection = null) 
		{
			this.playlist=playlist;
			this.parts=part;
		}
	}
}