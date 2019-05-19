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
package com.vidiun.types
{
	public class VidiunFlavorAssetStatus
	{
		public static const ERROR : int = -1;
		public static const QUEUED : int = 0;
		public static const CONVERTING : int = 1;
		public static const READY : int = 2;
		public static const DELETED : int = 3;
		public static const NOT_APPLICABLE : int = 4;
		public static const TEMP : int = 5;
		public static const WAIT_FOR_CONVERT : int = 6;
		public static const IMPORTING : int = 7;
		public static const VALIDATING : int = 8;
		public static const EXPORTING : int = 9;
	}
}
