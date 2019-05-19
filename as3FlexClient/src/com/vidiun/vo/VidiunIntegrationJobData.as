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
	import com.vidiun.vo.VidiunIntegrationJobTriggerData;

	import com.vidiun.vo.VidiunIntegrationJobProviderData;

	import com.vidiun.vo.VidiunJobData;

	[Bindable]
	public dynamic class VidiunIntegrationJobData extends VidiunJobData
	{
		/**
		**/
		public var callbackNotificationUrl : String = null;

		/**
		* @see com.vidiun.types.VidiunIntegrationProviderType
		**/
		public var providerType : String = null;

		/**
		* Additional data that relevant for the provider only
		**/
		public var providerData : VidiunIntegrationJobProviderData;

		/**
		* @see com.vidiun.types.VidiunIntegrationTriggerType
		**/
		public var triggerType : String = null;

		/**
		* Additional data that relevant for the trigger only
		**/
		public var triggerData : VidiunIntegrationJobTriggerData;

		override public function getUpdateableParamKeys():Array
		{
			var arr : Array;
			arr = super.getUpdateableParamKeys();
			arr.push('providerType');
			arr.push('providerData');
			arr.push('triggerType');
			arr.push('triggerData');
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
				case 'providerData':
					result = '';
					break;
				case 'triggerData':
					result = '';
					break;
				default:
					result = super.getElementType(arrayName);
					break;
			}
			return result;
		}
	}
}
