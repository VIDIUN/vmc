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
package com.vidiun.commands.bulk
{
		import com.vidiun.vo.VidiunBulkUploadFilter;
		import com.vidiun.vo.VidiunFilterPager;
	import com.vidiun.delegates.bulk.BulkListDelegate;
	import com.vidiun.net.VidiunCall;

	/**
	* List bulk upload batch jobs
	**/
	public class BulkList extends VidiunCall
	{
		public var filterFields : String;
		
		/**
		* @param bulkUploadFilter VidiunBulkUploadFilter
		* @param pager VidiunFilterPager
		**/
		public function BulkList( bulkUploadFilter : VidiunBulkUploadFilter=null,pager : VidiunFilterPager=null )
		{
			service= 'bulkupload_bulk';
			action= 'list';

			var keyArr : Array = new Array();
			var valueArr : Array = new Array();
			var keyValArr : Array = new Array();
			if (bulkUploadFilter) { 
				keyValArr = vidiunObject2Arrays(bulkUploadFilter, 'bulkUploadFilter');
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
			delegate = new BulkListDelegate( this , config );
		}
	}
}