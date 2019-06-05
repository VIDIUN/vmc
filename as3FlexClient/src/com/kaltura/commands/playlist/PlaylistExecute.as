// ===================================================================================================
//                           _  __     _ _
//                          | |/ /__ _| | |_ _  _ _ _ __ _
//                          | ' </ _` | |  _| || | '_/ _` |
//                          |_|\_\__,_|_|\__|\_,_|_| \__,_|
//
// This file is part of the Vidiun Collaborative Media Suite which allows users
// to do with audio, video, and animation what Wiki platfroms allow them to do with
// text.
//
// Copyright (C) 2006-2017  Vidiun Inc.
//
// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU Affero General Public License as
// published by the Free Software Foundation, either version 3 of the
// License, or (at your option) any later version.
//
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU Affero General Public License for more details.
//
// You should have received a copy of the GNU Affero General Public License
// along with this program.  If not, see <http://www.gnu.org/licenses/>.
//
// @ignore
// ===================================================================================================
package com.vidiun.commands.playlist
{
		import com.vidiun.vo.VidiunContext;
		import com.vidiun.vo.VidiunMediaEntryFilterForPlaylist;
		import com.vidiun.vo.VidiunFilterPager;
	import com.vidiun.delegates.playlist.PlaylistExecuteDelegate;
	import com.vidiun.net.VidiunCall;

	/**
	* Retrieve playlist for playing purpose
	**/
	public class PlaylistExecute extends VidiunCall
	{
		public var filterFields : String;
		
		/**
		* @param id String
		* @param detailed String
		* @param playlistContext VidiunContext
		* @param filter VidiunMediaEntryFilterForPlaylist
		* @param pager VidiunFilterPager
		**/
		public function PlaylistExecute( id : String,detailed : String='',playlistContext : VidiunContext=null,filter : VidiunMediaEntryFilterForPlaylist=null,pager : VidiunFilterPager=null )
		{
			service= 'playlist';
			action= 'execute';

			var keyArr : Array = new Array();
			var valueArr : Array = new Array();
			var keyValArr : Array = new Array();
			keyArr.push('id');
			valueArr.push(id);
			keyArr.push('detailed');
			valueArr.push(detailed);
			if (playlistContext) { 
				keyValArr = vidiunObject2Arrays(playlistContext, 'playlistContext');
				keyArr = keyArr.concat(keyValArr[0]);
				valueArr = valueArr.concat(keyValArr[1]);
			} 
			if (filter) { 
				keyValArr = vidiunObject2Arrays(filter, 'filter');
				keyArr = keyArr.concat(keyValArr[0]);
				valueArr = valueArr.concat(keyValArr[1]);
			} 
			if (pager) { 
				keyValArr = vidiunObject2Arrays(pager, 'pager');
				keyArr = keyArr.concat(keyValArr[0]);
				valueArr = valueArr.concat(keyValArr[1]);
			} 
			applySchema(keyArr, valueArr);
		}

		override public function execute() : void
		{
			setRequestArgument('filterFields', filterFields);
			delegate = new PlaylistExecuteDelegate( this , config );
		}
	}
}
