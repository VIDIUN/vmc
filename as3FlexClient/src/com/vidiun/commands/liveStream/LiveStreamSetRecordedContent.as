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
package com.vidiun.commands.liveStream
{
		import com.vidiun.vo.VidiunDataCenterContentResource;
	import com.vidiun.delegates.liveStream.LiveStreamSetRecordedContentDelegate;
	import com.vidiun.net.VidiunCall;

	/**
	* Set recorded video to live entry
	**/
	public class LiveStreamSetRecordedContent extends VidiunCall
	{
		public var filterFields : String;
		
		/**
		* @param entryId String
		* @param mediaServerIndex String
		* @param resource VidiunDataCenterContentResource
		* @param duration Number
		* @param recordedEntryId String
		* @param flavorParamsId int
		**/
		public function LiveStreamSetRecordedContent( entryId : String,mediaServerIndex : String,resource : VidiunDataCenterContentResource,duration : Number,recordedEntryId : String = null,flavorParamsId : int=int.MIN_VALUE )
		{
			service= 'livestream';
			action= 'setRecordedContent';

			var keyArr : Array = new Array();
			var valueArr : Array = new Array();
			var keyValArr : Array = new Array();
			keyArr.push('entryId');
			valueArr.push(entryId);
			keyArr.push('mediaServerIndex');
			valueArr.push(mediaServerIndex);
				keyValArr = vidiunObject2Arrays(resource, 'resource');
				keyArr = keyArr.concat(keyValArr[0]);
				valueArr = valueArr.concat(keyValArr[1]);
			keyArr.push('duration');
			valueArr.push(duration);
			keyArr.push('recordedEntryId');
			valueArr.push(recordedEntryId);
			keyArr.push('flavorParamsId');
			valueArr.push(flavorParamsId);
			applySchema(keyArr, valueArr);
		}

		override public function execute() : void
		{
			setRequestArgument('filterFields', filterFields);
			delegate = new LiveStreamSetRecordedContentDelegate( this , config );
		}
	}
}