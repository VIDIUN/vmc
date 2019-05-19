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
		import com.vidiun.vo.VidiunBatchJobFilter;
	import com.vidiun.delegates.batch.BatchGetExclusiveJobsDelegate;
	import com.vidiun.net.VidiunCall;

	/**
	* batch getExclusiveJobsAction action allows to get a BatchJob
	**/
	public class BatchGetExclusiveJobs extends VidiunCall
	{
		public var filterFields : String;
		
		/**
		* @param lockKey VidiunExclusiveLockKey
		* @param maxExecutionTime int
		* @param numberOfJobs int
		* @param filter VidiunBatchJobFilter
		* @param jobType String
		* @param maxJobToPullForCache int
		**/
		public function BatchGetExclusiveJobs( lockKey : VidiunExclusiveLockKey,maxExecutionTime : int,numberOfJobs : int,filter : VidiunBatchJobFilter=null,jobType : String = null,maxJobToPullForCache : int=0 )
		{
			service= 'batch';
			action= 'getExclusiveJobs';

			var keyArr : Array = new Array();
			var valueArr : Array = new Array();
			var keyValArr : Array = new Array();
				keyValArr = vidiunObject2Arrays(lockKey, 'lockKey');
				keyArr = keyArr.concat(keyValArr[0]);
				valueArr = valueArr.concat(keyValArr[1]);
			keyArr.push('maxExecutionTime');
			valueArr.push(maxExecutionTime);
			keyArr.push('numberOfJobs');
			valueArr.push(numberOfJobs);
			if (filter) { 
				keyValArr = vidiunObject2Arrays(filter, 'filter');
				keyArr = keyArr.concat(keyValArr[0]);
				valueArr = valueArr.concat(keyValArr[1]);
			} 
			keyArr.push('jobType');
			valueArr.push(jobType);
			keyArr.push('maxJobToPullForCache');
			valueArr.push(maxJobToPullForCache);
			applySchema(keyArr, valueArr);
		}

		override public function execute() : void
		{
			setRequestArgument('filterFields', filterFields);
			delegate = new BatchGetExclusiveJobsDelegate( this , config );
		}
	}
}
