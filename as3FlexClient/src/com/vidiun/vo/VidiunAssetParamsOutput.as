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
	import com.vidiun.vo.VidiunAssetParams;

	[Bindable]
	public dynamic class VidiunAssetParamsOutput extends VidiunAssetParams
	{
		/**
		**/
		public var assetParamsId : int = int.MIN_VALUE;

		/**
		**/
		public var assetParamsVersion : String = null;

		/**
		**/
		public var assetId : String = null;

		/**
		**/
		public var assetVersion : String = null;

		/**
		**/
		public var readyBehavior : int = int.MIN_VALUE;

		/**
		* The container format of the Flavor Params
		* @see com.vidiun.types.VidiunContainerFormat
		**/
		public var format : String = null;

		override public function getUpdateableParamKeys():Array
		{
			var arr : Array;
			arr = super.getUpdateableParamKeys();
			arr.push('assetParamsId');
			arr.push('assetParamsVersion');
			arr.push('assetId');
			arr.push('assetVersion');
			arr.push('readyBehavior');
			arr.push('format');
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