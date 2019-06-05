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
	import com.vidiun.vo.VidiunPlayReadyRight;

	[Bindable]
	public dynamic class VidiunPlayReadyPlayRight extends VidiunPlayReadyRight
	{
		/**
		* @see com.vidiun.types.VidiunPlayReadyAnalogVideoOPL
		**/
		public var analogVideoOPL : int = int.MIN_VALUE;

		/**
		**/
		public var analogVideoOutputProtectionList : Array = null;

		/**
		* @see com.vidiun.types.VidiunPlayReadyDigitalAudioOPL
		**/
		public var compressedDigitalAudioOPL : int = int.MIN_VALUE;

		/**
		* @see com.vidiun.types.VidiunPlayReadyCompressedDigitalVideoOPL
		**/
		public var compressedDigitalVideoOPL : int = int.MIN_VALUE;

		/**
		**/
		public var digitalAudioOutputProtectionList : Array = null;

		/**
		* @see com.vidiun.types.VidiunPlayReadyDigitalAudioOPL
		**/
		public var uncompressedDigitalAudioOPL : int = int.MIN_VALUE;

		/**
		* @see com.vidiun.types.VidiunPlayReadyUncompressedDigitalVideoOPL
		**/
		public var uncompressedDigitalVideoOPL : int = int.MIN_VALUE;

		/**
		**/
		public var firstPlayExpiration : int = int.MIN_VALUE;

		/**
		**/
		public var playEnablers : Array = null;

		override public function getUpdateableParamKeys():Array
		{
			var arr : Array;
			arr = super.getUpdateableParamKeys();
			arr.push('analogVideoOPL');
			arr.push('analogVideoOutputProtectionList');
			arr.push('compressedDigitalAudioOPL');
			arr.push('compressedDigitalVideoOPL');
			arr.push('digitalAudioOutputProtectionList');
			arr.push('uncompressedDigitalAudioOPL');
			arr.push('uncompressedDigitalVideoOPL');
			arr.push('firstPlayExpiration');
			arr.push('playEnablers');
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
				case 'analogVideoOutputProtectionList':
					result = 'VidiunPlayReadyAnalogVideoOPIdHolder';
					break;
				case 'digitalAudioOutputProtectionList':
					result = 'VidiunPlayReadyDigitalAudioOPIdHolder';
					break;
				case 'playEnablers':
					result = 'VidiunPlayReadyPlayEnablerHolder';
					break;
				default:
					result = super.getElementType(arrayName);
					break;
			}
			return result;
		}
	}
}
