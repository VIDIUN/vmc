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
package com.vidiun.vo
{
	import com.vidiun.vo.VidiunFilter;

	[Bindable]
	public dynamic class VidiunMetadataProfileBaseFilter extends VidiunFilter
	{
		/**
		**/
		public var idEqual : int = int.MIN_VALUE;

		/**
		**/
		public var partnerIdEqual : int = int.MIN_VALUE;

		/**
		* @see com.vidiun.types.VidiunMetadataObjectType
		**/
		public var metadataObjectTypeEqual : String = null;

		/**
		**/
		public var metadataObjectTypeIn : String = null;

		/**
		**/
		public var versionEqual : int = int.MIN_VALUE;

		/**
		**/
		public var nameEqual : String = null;

		/**
		**/
		public var systemNameEqual : String = null;

		/**
		**/
		public var systemNameIn : String = null;

		/**
		**/
		public var createdAtGreaterThanOrEqual : int = int.MIN_VALUE;

		/**
		**/
		public var createdAtLessThanOrEqual : int = int.MIN_VALUE;

		/**
		**/
		public var updatedAtGreaterThanOrEqual : int = int.MIN_VALUE;

		/**
		**/
		public var updatedAtLessThanOrEqual : int = int.MIN_VALUE;

		/**
		* @see com.vidiun.types.VidiunMetadataProfileStatus
		**/
		public var statusEqual : int = int.MIN_VALUE;

		/**
		**/
		public var statusIn : String = null;

		/**
		* @see com.vidiun.types.VidiunMetadataProfileCreateMode
		**/
		public var createModeEqual : int = int.MIN_VALUE;

		/**
		* @see com.vidiun.types.VidiunMetadataProfileCreateMode
		**/
		public var createModeNotEqual : int = int.MIN_VALUE;

		/**
		**/
		public var createModeIn : String = null;

		/**
		**/
		public var createModeNotIn : String = null;

		override public function getUpdateableParamKeys():Array
		{
			var arr : Array;
			arr = super.getUpdateableParamKeys();
			arr.push('idEqual');
			arr.push('partnerIdEqual');
			arr.push('metadataObjectTypeEqual');
			arr.push('metadataObjectTypeIn');
			arr.push('versionEqual');
			arr.push('nameEqual');
			arr.push('systemNameEqual');
			arr.push('systemNameIn');
			arr.push('createdAtGreaterThanOrEqual');
			arr.push('createdAtLessThanOrEqual');
			arr.push('updatedAtGreaterThanOrEqual');
			arr.push('updatedAtLessThanOrEqual');
			arr.push('statusEqual');
			arr.push('statusIn');
			arr.push('createModeEqual');
			arr.push('createModeNotEqual');
			arr.push('createModeIn');
			arr.push('createModeNotIn');
			return arr;
		}

		override public function getInsertableParamKeys():Array
		{
			var arr : Array;
			arr = super.getInsertableParamKeys();
			return arr;
		}

		override public function getElementType(arrayName:String):String
		{
			var result:String = '';
			switch (arrayName) {
				default:
					result = super.getElementType(arrayName);
					break;
			}
			return result;
		}
	}
}