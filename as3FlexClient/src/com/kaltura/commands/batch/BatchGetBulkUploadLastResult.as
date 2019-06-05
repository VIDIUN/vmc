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
	import com.vidiun.delegates.batch.BatchGetBulkUploadLastResultDelegate;
	import com.vidiun.net.VidiunCall;

	/**
	* batch getBulkUploadLastResultAction action returns the last result of the bulk upload
	**/
	public class BatchGetBulkUploadLastResult extends VidiunCall
	{
		public var filterFields : String;
		
		/**
		* @param bulkUploadJobId int
		**/
		public function BatchGetBulkUploadLastResult( bulkUploadJobId : int )
		{
			service= 'batch';
			action= 'getBulkUploadLastResult';

			var keyArr : Array = new Array();
			var valueArr : Array = new Array();
			var keyValArr : Array = new Array();
			keyArr.push('bulkUploadJobId');
			valueArr.push(bulkUploadJobId);
			applySchema(keyArr, valueArr);
		}

		override public function execute() : void
		{
			setRequestArgument('filterFields', filterFields);
			delegate = new BatchGetBulkUploadLastResultDelegate( this , config );
		}
	}
}
