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
	import com.vidiun.vo.VidiunRelatedFilter;

	[Bindable]
	public dynamic class VidiunCategoryEntryBaseFilter extends VidiunRelatedFilter
	{
		/**
		**/
		public var categoryIdEqual : int = int.MIN_VALUE;

		/**
		**/
		public var categoryIdIn : String = null;

		/**
		**/
		public var entryIdEqual : String = null;

		/**
		**/
		public var entryIdIn : String = null;

		/**
		**/
		public var createdAtGreaterThanOrEqual : int = int.MIN_VALUE;

		/**
		**/
		public var createdAtLessThanOrEqual : int = int.MIN_VALUE;

		/**
		**/
		public var categoryFullIdsStartsWith : String = null;

		/**
		* @see com.vidiun.types.VidiunCategoryEntryStatus
		**/
		public var statusEqual : int = int.MIN_VALUE;

		/**
		**/
		public var statusIn : String = null;

		/**
		**/
		public var creatorUserIdEqual : String = null;

		/**
		**/
		public var creatorUserIdIn : String = null;

		override public function getUpdateableParamKeys():Array
		{
			var arr : Array;
			arr = super.getUpdateableParamKeys();
			arr.push('categoryIdEqual');
			arr.push('categoryIdIn');
			arr.push('entryIdEqual');
			arr.push('entryIdIn');
			arr.push('createdAtGreaterThanOrEqual');
			arr.push('createdAtLessThanOrEqual');
			arr.push('categoryFullIdsStartsWith');
			arr.push('statusEqual');
			arr.push('statusIn');
			arr.push('creatorUserIdEqual');
			arr.push('creatorUserIdIn');
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