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
	import com.vidiun.vo.VidiunIntegrationJobProviderData;

	[Bindable]
	public dynamic class VidiunVoicebaseJobProviderData extends VidiunIntegrationJobProviderData
	{
		/**
		* Entry ID
		**/
		public var entryId : String = null;

		/**
		* Flavor ID
		**/
		public var flavorAssetId : String = null;

		/**
		* input Transcript-asset ID
		**/
		public var transcriptId : String = null;

		/**
		* Caption formats
		**/
		public var captionAssetFormats : String = null;

		/**
		* Api key for service provider
		**/
		public var apiKey : String = null;

		/**
		* Api key for service provider
		**/
		public var apiPassword : String = null;

		/**
		* Transcript content language
		* @see com.vidiun.types.VidiunLanguage
		**/
		public var spokenLanguage : String = null;

		/**
		* Transcript Content location
		**/
		public var fileLocation : String = null;

		/**
		* should replace remote media content
		* @see com.vidiun.types.vidiunBoolean
		**/
		public var replaceMediaContent : Boolean;

		/**
		* additional parameters to send to VoiceBase
		**/
		public var additionalParameters : String = null;

		override public function getUpdateableParamKeys():Array
		{
			var arr : Array;
			arr = super.getUpdateableParamKeys();
			arr.push('entryId');
			arr.push('flavorAssetId');
			arr.push('transcriptId');
			arr.push('captionAssetFormats');
			arr.push('spokenLanguage');
			arr.push('replaceMediaContent');
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
