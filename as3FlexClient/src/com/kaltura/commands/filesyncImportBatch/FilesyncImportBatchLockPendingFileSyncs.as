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
package com.vidiun.commands.filesyncImportBatch
{
		import com.vidiun.vo.VidiunFileSyncFilter;
	import com.vidiun.delegates.filesyncImportBatch.FilesyncImportBatchLockPendingFileSyncsDelegate;
	import com.vidiun.net.VidiunCall;

	/**
	* batch lockPendingFileSyncs action locks file syncs for import by the file sync periodic worker
	**/
	public class FilesyncImportBatchLockPendingFileSyncs extends VidiunCall
	{
		public var filterFields : String;
		
		/**
		* @param filter VidiunFileSyncFilter
		* @param workerId int
		* @param sourceDc int
		* @param maxCount int
		* @param maxSize int
		**/
		public function FilesyncImportBatchLockPendingFileSyncs( filter : VidiunFileSyncFilter,workerId : int,sourceDc : int,maxCount : int,maxSize : int=int.MIN_VALUE )
		{
			service= 'multicenters_filesyncimportbatch';
			action= 'lockPendingFileSyncs';

			var keyArr : Array = new Array();
			var valueArr : Array = new Array();
			var keyValArr : Array = new Array();
				keyValArr = vidiunObject2Arrays(filter, 'filter');
				keyArr = keyArr.concat(keyValArr[0]);
				valueArr = valueArr.concat(keyValArr[1]);
			keyArr.push('workerId');
			valueArr.push(workerId);
			keyArr.push('sourceDc');
			valueArr.push(sourceDc);
			keyArr.push('maxCount');
			valueArr.push(maxCount);
			keyArr.push('maxSize');
			valueArr.push(maxSize);
			applySchema(keyArr, valueArr);
		}

		override public function execute() : void
		{
			setRequestArgument('filterFields', filterFields);
			delegate = new FilesyncImportBatchLockPendingFileSyncsDelegate( this , config );
		}
	}
}
