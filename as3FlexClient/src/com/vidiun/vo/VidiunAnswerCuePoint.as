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
	import com.vidiun.vo.VidiunCuePoint;

	[Bindable]
	public dynamic class VidiunAnswerCuePoint extends VidiunCuePoint
	{
		/**
		**/
		public var parentId : String = null;

		/**
		**/
		public var quizUserEntryId : String = null;

		/**
		**/
		public var answerKey : String = null;

		/**
		* @see com.vidiun.types.VidiunNullableBoolean
		**/
		public var isCorrect : int = int.MIN_VALUE;

		/**
		* Array of string
		**/
		public var correctAnswerKeys : Array = null;

		/**
		**/
		public var explanation : String = null;

		override public function getUpdateableParamKeys():Array
		{
			var arr : Array;
			arr = super.getUpdateableParamKeys();
			arr.push('answerKey');
			return arr;
		}

		override public function getInsertableParamKeys():Array
		{
			var arr : Array;
			arr = super.getInsertableParamKeys();
			arr.push('parentId');
			arr.push('quizUserEntryId');
			return arr;
		}

		override public function getElementType(arrayName:String):String
		{
			var result:String = '';
			switch (arrayName) {
				case 'correctAnswerKeys':
					result = 'VidiunString';
					break;
				default:
					result = super.getElementType(arrayName);
					break;
			}
			return result;
		}
	}
}
