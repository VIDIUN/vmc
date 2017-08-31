// ===================================================================================================
//                           _  __     _ _
//                          | |/ /__ _| | |_ _  _ _ _ __ _
//                          | ' </ _` | |  _| || | '_/ _` |
//                          |_|\_\__,_|_|\__|\_,_|_| \__,_|
//
// This file is part of the Kaltura Collaborative Media Suite which allows users
// to do with audio, video, and animation what Wiki platfroms allow them to do with
// text.
//
// Copyright (C) 2006-2017  Kaltura Inc.
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
package com.kaltura.commands.xInternal
{
	import com.kaltura.delegates.xInternal.XInternalXAddBulkDownloadDelegate;
	import com.kaltura.net.KalturaCall;

	/**
	* Creates new download job for multiple entry ids (comma separated), an email will be sent when the job is done
	* This sevice support the following entries:
	* - MediaEntry
	* - Video will be converted using the flavor params id
	* - Audio will be downloaded as MP3
	* - Image will be downloaded as Jpeg
	* - MixEntry will be flattened using the flavor params id
	* - Other entry types are not supported
	* Returns the admin email that the email message will be sent to
	**/
	public class XInternalXAddBulkDownload extends KalturaCall
	{
		public var filterFields : String;
		
		/**
		* @param entryIds String
		* @param flavorParamsId String
		**/
		public function XInternalXAddBulkDownload( entryIds : String,flavorParamsId : String='' )
		{
			service= 'xinternal';
			action= 'xAddBulkDownload';

			var keyArr : Array = new Array();
			var valueArr : Array = new Array();
			var keyValArr : Array = new Array();
			keyArr.push('entryIds');
			valueArr.push(entryIds);
			keyArr.push('flavorParamsId');
			valueArr.push(flavorParamsId);
			applySchema(keyArr, valueArr);
		}

		override public function execute() : void
		{
			setRequestArgument('filterFields', filterFields);
			delegate = new XInternalXAddBulkDownloadDelegate( this , config );
		}
	}
}
