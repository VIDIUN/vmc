package com.vidiun.vmc.modules.content.commands {
	import com.adobe.cairngorm.commands.ICommand;
	import com.adobe.cairngorm.control.CairngormEvent;
	import com.vidiun.commands.playlist.PlaylistList;
	import com.vidiun.edw.control.events.SearchEvent;
	import com.vidiun.edw.vo.ListableVo;
	import com.vidiun.events.VidiunEvent;
	import com.vidiun.vmc.modules.content.events.VMCSearchEvent;
	import com.vidiun.types.VidiunPlaylistOrderBy;
	import com.vidiun.vo.VidiunFilterPager;
	import com.vidiun.vo.VidiunMediaEntryFilterForPlaylist;
	import com.vidiun.vo.VidiunPlaylist;
	import com.vidiun.vo.VidiunPlaylistFilter;
	import com.vidiun.vo.VidiunPlaylistListResponse;
	
	import mx.collections.ArrayCollection;
	import mx.rpc.IResponder;

	public class ListPlaylistCommand extends VidiunCommand implements ICommand, IResponder {
		// Atar: I have no idea why we need this.
		VidiunMediaEntryFilterForPlaylist;

		/**
		 * External Syndication windows don't send a listableVO, playlist panel does. 
		 */		
		private var _caller:ListableVo;


		/**
		 * @inheritDoc
		 * */
		override public function execute(event:CairngormEvent):void {
			_model.increaseLoadCounter();
			_caller = (event as VMCSearchEvent).listableVo;

			if (_caller == null) {
				var pf:VidiunPlaylistFilter = new VidiunPlaylistFilter();
				pf.orderBy = VidiunPlaylistOrderBy.CREATED_AT_DESC;
				var pg:VidiunFilterPager = new VidiunFilterPager();
				pg.pageSize = 500;
				var generalPlaylistList:PlaylistList = new PlaylistList(pf, pg);
				generalPlaylistList.addEventListener(VidiunEvent.COMPLETE, result);
				generalPlaylistList.addEventListener(VidiunEvent.FAILED, fault);
				_model.context.vc.post(generalPlaylistList);
			}
			else {
				var vpf:VidiunPlaylistFilter = VidiunPlaylistFilter(_caller.filterVo);
				var playlistList:PlaylistList = new PlaylistList(vpf as VidiunPlaylistFilter,
																 _caller.pagingComponent.vidiunFilterPager);
				playlistList.addEventListener(VidiunEvent.COMPLETE, result);
				playlistList.addEventListener(VidiunEvent.FAILED, fault);
				_model.context.vc.post(playlistList);
			}
		}


		/**
		 * @inheritDoc
		 * */
		override public function result(data:Object):void {
			super.result(data);
			_model.decreaseLoadCounter();
			if (_caller == null) {
				// from ext.syn subtab
				var tempArr:ArrayCollection = new ArrayCollection();
				var playlistListResult:VidiunPlaylistListResponse = data.data as VidiunPlaylistListResponse;
				for each (var playList:VidiunPlaylist in playlistListResult.objects) {
					tempArr.addItem(playList);
				}
				_model.extSynModel.generalPlayListdata = tempArr;
			}
			else {
				// from playlists subtab
				_caller.arrayCollection = new ArrayCollection(data.data.objects);
				_caller.pagingComponent.totalCount = data.data.totalCount;

				_caller = null;
			}
		}
	}
}