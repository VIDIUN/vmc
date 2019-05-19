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
package com.vidiun.commands.batch
{
		import com.vidiun.vo.VidiunExclusiveLockKey;
	import com.vidiun.delegates.batch.BatchFreeExclusiveJobDelegate;
	import com.vidiun.net.VidiunCall;

	/**
	* batch freeExclusiveJobAction action allows to get a generic BatchJob
	**/
	public class BatchFreeExclusiveJob extends VidiunCall
	{
		public var filterFields : String;
		
		/**
		* @param id int
		* @param lockKey VidiunExclusiveLockKey
		* @param jobType String
		* @param resetExecutionAttempts Boolean
		**/
		public function BatchFreeExclusiveJob( id : int,lockKey : VidiunExclusiveLockKey,jobType : String,resetExecutionAttempts : Boolean=false )
		{
			service= 'batch';
			action= 'freeExclusiveJob';

			var keyArr : Array = new Array();
			var valueArr : Array = new Array();
			var keyValArr : Array = new Array();
			keyArr.push('id');
			valueArr.push(id);
				keyValArr = vidiunObject2Arrays(lockKey, 'lockKey');
				keyArr = keyArr.concat(keyValArr[0]);
				valueArr = valueArr.concat(keyValArr[1]);
			keyArr.push('jobType');
			valueArr.push(jobType);
			keyArr.push('resetExecutionAttempts');
			valueArr.push(resetExecutionAttempts);
			applySchema(keyArr, valueArr);
		}

		override public function execute() : void
		{
			setRequestArgument('filterFields', filterFields);
			delegate = new BatchFreeExclusiveJobDelegate( this , config );
		}
	}
}
