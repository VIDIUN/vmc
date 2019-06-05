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
	public dynamic class VidiunServerNodeBaseFilter extends VidiunFilter
	{
		/**
		**/
		public var idEqual : int = int.MIN_VALUE;

		/**
		**/
		public var idIn : String = null;

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
		**/
		public var heartbeatTimeGreaterThanOrEqual : int = int.MIN_VALUE;

		/**
		**/
		public var heartbeatTimeLessThanOrEqual : int = int.MIN_VALUE;

		/**
		**/
		public var nameEqual : String = null;

		/**
		**/
		public var nameIn : String = null;

		/**
		**/
		public var systemNameEqual : String = null;

		/**
		**/
		public var systemNameIn : String = null;

		/**
		**/
		public var hostNameLike : String = null;

		/**
		**/
		public var hostNameMultiLikeOr : String = null;

		/**
		**/
		public var hostNameMultiLikeAnd : String = null;

		/**
		* @see com.vidiun.types.VidiunServerNodeStatus
		**/
		public var statusEqual : int = int.MIN_VALUE;

		/**
		**/
		public var statusIn : String = null;

		/**
		* @see com.vidiun.types.VidiunServerNodeType
		**/
		public var typeEqual : String = null;

		/**
		**/
		public var typeIn : String = null;

		/**
		**/
		public var tagsLike : String = null;

		/**
		**/
		public var tagsMultiLikeOr : String = null;

		/**
		**/
		public var tagsMultiLikeAnd : String = null;

		/**
		**/
		public var dcEqual : int = int.MIN_VALUE;

		/**
		**/
		public var dcIn : String = null;

		/**
		**/
		public var parentIdLike : String = null;

		/**
		**/
		public var parentIdMultiLikeOr : String = null;

		/**
		**/
		public var parentIdMultiLikeAnd : String = null;

		override public function getUpdateableParamKeys():Array
		{
			var arr : Array;
			arr = super.getUpdateableParamKeys();
			arr.push('idEqual');
			arr.push('idIn');
			arr.push('createdAtGreaterThanOrEqual');
			arr.push('createdAtLessThanOrEqual');
			arr.push('updatedAtGreaterThanOrEqual');
			arr.push('updatedAtLessThanOrEqual');
			arr.push('heartbeatTimeGreaterThanOrEqual');
			arr.push('heartbeatTimeLessThanOrEqual');
			arr.push('nameEqual');
			arr.push('nameIn');
			arr.push('systemNameEqual');
			arr.push('systemNameIn');
			arr.push('hostNameLike');
			arr.push('hostNameMultiLikeOr');
			arr.push('hostNameMultiLikeAnd');
			arr.push('statusEqual');
			arr.push('statusIn');
			arr.push('typeEqual');
			arr.push('typeIn');
			arr.push('tagsLike');
			arr.push('tagsMultiLikeOr');
			arr.push('tagsMultiLikeAnd');
			arr.push('dcEqual');
			arr.push('dcIn');
			arr.push('parentIdLike');
			arr.push('parentIdMultiLikeOr');
			arr.push('parentIdMultiLikeAnd');
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
