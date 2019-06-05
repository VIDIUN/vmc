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
	import com.vidiun.vo.VidiunDeliveryProfile;

	[Bindable]
	public dynamic class VidiunDeliveryProfileForensicWatermark extends VidiunDeliveryProfile
	{
		/**
		* The URL used to pull manifest from the server, keyed by dc id, asterisk means all dcs
		**/
		public var internalUrl : Array = null;

		/**
		* The key used to encrypt the URI (256 bits)
		**/
		public var encryptionKey : String = null;

		/**
		* The iv used to encrypt the URI (128 bits)
		**/
		public var encryptionIv : String = null;

		/**
		* The regex used to match the encrypted part of the URI (according to the 'encrypt' named group)
		**/
		public var encryptionRegex : String = null;

		override public function getUpdateableParamKeys():Array
		{
			var arr : Array;
			arr = super.getUpdateableParamKeys();
			arr.push('internalUrl');
			arr.push('encryptionKey');
			arr.push('encryptionIv');
			arr.push('encryptionRegex');
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
				case 'internalUrl':
					result = 'VidiunKeyValue';
					break;
				default:
					result = super.getElementType(arrayName);
					break;
			}
			return result;
		}
	}
}