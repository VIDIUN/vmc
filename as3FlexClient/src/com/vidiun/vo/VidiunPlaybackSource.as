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
	import com.vidiun.vo.BaseFlexVo;

	[Bindable]
	public dynamic class VidiunPlaybackSource extends BaseFlexVo
	{
		/**
		**/
		public var deliveryProfileId : String = null;

		/**
		* source format according to delivery profile streamer type (applehttp, mpegdash etc.)
		**/
		public var format : String = null;

		/**
		* comma separated string according to deliveryProfile media protocols ('http,https' etc.)
		**/
		public var protocols : String = null;

		/**
		* comma separated string of flavor ids
		**/
		public var flavorIds : String = null;

		/**
		**/
		public var url : String = null;

		/**
		* drm data object containing relevant license url ,scheme name and certificate
		**/
		public var drm : Array = null;

		/** 
		* a list of attributes which may be updated on this object 
		**/ 
		public function getUpdateableParamKeys():Array
		{
			var arr : Array;
			arr = new Array();
			arr.push('deliveryProfileId');
			arr.push('format');
			arr.push('protocols');
			arr.push('flavorIds');
			arr.push('url');
			arr.push('drm');
			return arr;
		}

		/** 
		* a list of attributes which may only be inserted when initializing this object 
		**/ 
		public function getInsertableParamKeys():Array
		{
			var arr : Array;
			arr = new Array();
			return arr;
		}

		/** 
		* get the expected type of array elements 
		* @param arrayName 	 name of an attribute of type array of the current object 
		* @return 	 un-qualified class name 
		**/ 
		public function getElementType(arrayName:String):String
		{
			var result:String = '';
			switch (arrayName) {
				case 'drm':
					result = 'VidiunDrmPlaybackPluginData';
					break;
			}
			return result;
		}
	}
}